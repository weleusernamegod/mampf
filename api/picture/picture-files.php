<?php
// Bilder der Orte als Dateien im Ordner /bilder/orte/ auf dem Webserver.
// In tbl_place.picture_file steht nur der Dateiname.
// Alte Bilder (tbl_picture, tbl_place.picture_id) werden noch angezeigt, bis
// api/admin-bilder-umziehen.php sie zu Dateien gemacht hat.

require_once(__DIR__ . '/picture-repository.php');

const PICTURE_URL_PATH = '/bilder/orte/';

/** Ordner auf dem Server: <webroot>/bilder/orte (api/picture liegt in <webroot>/api/picture) */
function picture_dir()
{
    return dirname(__DIR__, 2) . '/bilder/orte';
}

/** Nur Dateinamen, die wir selbst vergeben (keine Pfade, kein ".."). */
function _is_safe_picture_name($name)
{
    return is_string($name) && preg_match('/^[A-Za-z0-9][A-Za-z0-9._-]{0,99}$/', $name) && strpos($name, '..') === FALSE;
}

/** URL des Bildes für Karte und Admin, NULL = kein Bild. */
function picture_url($place)
{
    if (!is_null($place->pictureFile) && _is_safe_picture_name($place->pictureFile)) {
        return PICTURE_URL_PATH . rawurlencode($place->pictureFile);
    }
    if (!is_null($place->pictureId)) {
        return '/api/get-public-picture.php?id=' . intval($place->pictureId);
    }
    return NULL;
}

/** Bild (bereits geprüftes JPEG) mit zufälligem Namen speichern. Gibt den Dateinamen zurück, NULL bei Fehler. */
function save_picture_file($data, $extension = 'jpg')
{
    $dir = picture_dir();
    if (!is_dir($dir) && !mkdir($dir, 0755, TRUE)) {
        return NULL;
    }
    $name = bin2hex(random_bytes(12)) . '.' . $extension;
    if (file_put_contents($dir . '/' . $name, $data, LOCK_EX) === FALSE) {
        return NULL;
    }
    return $name;
}

/** Bilddatei löschen (falls vorhanden). */
function delete_picture_file($name)
{
    if (!_is_safe_picture_name($name)) {
        return;
    }
    $path = picture_dir() . '/' . $name;
    if (is_file($path)) {
        unlink($path);
    }
}

/** Altes Datenbank-Bild löschen, aber nur wenn kein Ort es mehr verwendet. */
function delete_picture_if_unused($pictureId)
{
    global $mysqli;

    $statement = $mysqli->prepare("SELECT COUNT(*) AS n FROM tbl_place WHERE picture_id = ?");
    $statement->bind_param("i", $pictureId);
    $statement->execute();
    $inUse = intval($statement->get_result()->fetch_assoc()['n']) > 0;
    $statement->close();

    if (!$inUse) {
        delete_picture_by_id($pictureId);
    }
}
?>
