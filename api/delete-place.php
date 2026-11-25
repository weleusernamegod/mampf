<?php
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

if (!isset($_GET["id"])) {
    http_response_code(400);
    exit();
}

$mysqli = create_db_connection();

$place = find_place_by_id(intval($_GET["id"]));

$allowed = $place && ($place->userId === $_SESSION['user_id'] || is_admin());
if (!$allowed) {
    http_response_code(404);
    exit();
}

$pictureIdToDelete = $place->pictureId;
$pictureFileToDelete = $place->pictureFile;
$place->pictureId = NULL;
$place->pictureFile = NULL;
$place = update_place($place);

if (!is_null($pictureIdToDelete)) {
    delete_picture_if_unused($pictureIdToDelete);
}
delete_place_by_id($place->id);

close_db_connection($mysqli);

if (!is_null($pictureFileToDelete)) {
    delete_picture_file($pictureFileToDelete);
}
?>