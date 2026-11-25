<?php
// Einmalig: alte Bilder aus der Datenbank (tbl_picture) zu Dateien in
// /bilder/orte/ machen. Nur für Admins. Aufruf im Browser (angemeldet als Admin):
//   https://mampf.io/api/admin-bilder-umziehen.php
// Darf mehrmals laufen: Orte, die schon eine Bilddatei haben, werden übersprungen.
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
$ergebnis = ['umgezogen' => [], 'fehler' => []];

foreach (find_all_places() as $place) {
    if (is_null($place->pictureId) || !is_null($place->pictureFile)) {
        continue;
    }
    $picture = find_picture_by_id($place->pictureId);
    $extension = $picture ? ($EXTENSIONS[$picture->type] ?? NULL) : NULL;
    $file = $extension ? save_picture_file($picture->data, $extension) : NULL;
    if (is_null($file)) {
        $ergebnis['fehler'][] = $place->name;
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
}

close_db_connection($mysqli);
return_json($ergebnis);
?>
