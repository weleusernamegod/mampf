<?php
include('config.php');
include('util/db-util.php');
include('picture/picture-repository.php');

require_once('picture/picture.php');

if (!isset($_GET["id"])) {
    http_response_code(400);
    exit();
}

$mysqli = create_db_connection();

$picture = find_picture_by_id(intval($_GET["id"]));
if (!$picture) {
    http_response_code(404);
    exit();
}

header("Content-Type:" . $picture->type);
echo ($picture->data);

close_db_connection($mysqli);
?>