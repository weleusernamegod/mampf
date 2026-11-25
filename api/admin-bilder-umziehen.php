<?php
// Einmalig (darf aber mehrmals laufen): Bilder der Orte vereinheitlichen. Nur für Admins.
//  1. Alte Bilder aus der Datenbank (tbl_picture) werden zu Dateien in /bilder/orte/.
//  2. Vorhandene Bilddateien mit anderem Namen werden umbenannt auf
//     <Ort-ID>-<name>-<6 Zufallszeichen>.<endung> (z.B. "112-banh-mi-136-a3f9c2.jpg").
// Aufruf im Browser (angemeldet als Admin):
//   https://mampf.io/api/admin-bilder-umziehen.php
include('config.php');
include('util/db-util.php');
include('util/api-util.php');
include('util/login-util.php');
include('place/place-repository.php');
include('picture/picture-repository.php');
include('picture/picture-files.php');

require_once('place/place.php');
require_once('picture/picture.php');

assert_logged_in();
if (!is_admin()) {
    http_response_code(403);
    exit();
}

$EXTENSIONS = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp', 'image/gif' => 'gif'];

$mysqli = create_db_connection();
$ergebnis = ['umgezogen' => [], 'umbenannt' => [], 'fehler' => []];

foreach (find_all_places() as $place) {
    // 1. Altes Datenbank-Bild -> Datei
    if (!is_null($place->pictureId) && is_null($place->pictureFile)) {
        $picture = find_picture_by_id($place->pictureId);
        $extension = $picture ? ($EXTENSIONS[$picture->type] ?? NULL) : NULL;
        $file = $extension ? save_picture_file($picture->data, $place, $extension) : NULL;
        if (is_null($file)) {
            $ergebnis['fehler'][] = $place->name . ' (altes Bild)';
            continue;
        }

        $mysqli->begin_transaction();
        $oldPictureId = $place->pictureId;
        $place->pictureFile = $file;
        $place->pictureId = NULL;
        update_place($place);
        delete_picture_if_unused($oldPictureId);
        $mysqli->commit();

        $ergebnis['umgezogen'][] = $place->name . ' -> ' . $file;
        continue;
    }

    // 2. Datei mit anderem Namen -> einheitlicher Name
    if (!is_null($place->pictureFile) && !has_picture_file_name($place, $place->pictureFile)) {
        $oldFile = $place->pictureFile;
        $newFile = rename_picture_file($place);
        if (is_null($newFile)) {
            $ergebnis['fehler'][] = $place->name . ' (' . $oldFile . ' nicht gefunden)';
            continue;
        }
        $place->pictureFile = $newFile;
        try {
            update_place($place);
        } catch (Throwable $e) {
            // Datenbank nicht gespeichert: Datei wieder zurückbenennen
            rename(picture_dir() . '/' . $newFile, picture_dir() . '/' . $oldFile);
            $ergebnis['fehler'][] = $place->name . ' (Datenbank)';
            continue;
        }
        $ergebnis['umbenannt'][] = $oldFile . ' -> ' . $newFile;
    }
}

// 3. Nur anzeigen (nicht löschen): Dateien im Ordner, die zu keinem Ort gehören
$used = [];
foreach (find_all_places() as $place) {
    if (!is_null($place->pictureFile)) {
        $used[$place->pictureFile] = TRUE;
    }
}
$ergebnis['unbenutzt'] = array_values(array_filter(
    is_dir(picture_dir()) ? scandir(picture_dir()) : [],
    fn($file) => $file[0] !== '.' && !isset($used[$file])
));

close_db_connection($mysqli);
return_json($ergebnis);
?>
