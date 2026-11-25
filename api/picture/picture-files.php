<?php
// Bilder der Orte als Dateien im Ordner /bilder/orte/ auf dem Webserver.
// In tbl_place.picture_file steht nur der Dateiname, einheitlich
// <Ort-ID>-<name>-<6 Zufallszeichen>.<endung> (siehe picture_file_name).
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

/** Ortsname als Teil eines Dateinamens: "Zürich Fried Chicken" -> "zuerich-fried-chicken" */
function _picture_slug($name)
{
    $name = function_exists('mb_strtolower') ? mb_strtolower((string) $name, 'UTF-8') : strtolower((string) $name);
    $name = strtr($name, [
        'ä' => 'ae', 'ö' => 'oe', 'ü' => 'ue', 'Ä' => 'ae', 'Ö' => 'oe', 'Ü' => 'ue', 'ß' => 'ss',
        'à' => 'a', 'á' => 'a', 'â' => 'a', 'ã' => 'a', 'å' => 'a', 'æ' => 'ae', 'ç' => 'c',
        'è' => 'e', 'é' => 'e', 'ê' => 'e', 'ë' => 'e', 'ì' => 'i', 'í' => 'i', 'î' => 'i', 'ï' => 'i',
        'ñ' => 'n', 'ò' => 'o', 'ó' => 'o', 'ô' => 'o', 'õ' => 'o', 'ø' => 'o', 'ơ' => 'o', 'œ' => 'oe',
        'ù' => 'u', 'ú' => 'u', 'û' => 'u', 'ư' => 'u', 'ý' => 'y', 'ÿ' => 'y'
    ]);
    // Alles andere (Sonderzeichen, nicht-lateinische Schrift) wird zu Bindestrichen
    $slug = trim(preg_replace('/[^a-z0-9]+/', '-', $name), '-');
    $slug = trim(substr($slug, 0, 40), '-');
    return $slug === '' ? 'ort' : $slug;
}

/** Einheitlicher Dateiname: <Ort-ID>-<name>-<6 Zufallszeichen>.<endung>, z.B. "112-banh-mi-136-a3f9c2.jpg" */
function picture_file_name($place, $extension)
{
    return intval($place->id) . '-' . _picture_slug($place->name) . '-' . bin2hex(random_bytes(3)) . '.' . strtolower($extension);
}

/** Hat die Datei schon das einheitliche Namensschema für diesen Ort? */
function has_picture_file_name($place, $name)
{
    return is_string($name) && preg_match('/^' . intval($place->id) . '-[a-z0-9-]+-[a-f0-9]{6}\.[a-z]+$/', $name) === 1;
}

/** Bild (bereits geprüft) für einen Ort speichern. Gibt den Dateinamen zurück, NULL bei Fehler. */
function save_picture_file($data, $place, $extension = 'jpg')
{
    $dir = picture_dir();
    if (!is_dir($dir) && !mkdir($dir, 0755, TRUE)) {
        return NULL;
    }
    $name = picture_file_name($place, $extension);
    if (file_put_contents($dir . '/' . $name, $data, LOCK_EX) === FALSE) {
        return NULL;
    }
    return $name;
}

/** Vorhandene Bilddatei eines Ortes auf das einheitliche Schema umbenennen. Gibt den neuen Namen zurück, NULL bei Fehler. */
function rename_picture_file($place)
{
    $old = $place->pictureFile;
    if (!_is_safe_picture_name($old) || !is_file(picture_dir() . '/' . $old)) {
        return NULL;
    }
    $extension = strtolower(pathinfo($old, PATHINFO_EXTENSION)) ?: 'jpg';
    $new = picture_file_name($place, $extension);
    return rename(picture_dir() . '/' . $old, picture_dir() . '/' . $new) ? $new : NULL;
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
