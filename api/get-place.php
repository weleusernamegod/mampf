<?php
include('config.php');
include('util/db-util.php');
include('util/api-util.php');
include('util/login-util.php');
include('place/place-repository.php');

require_once('place/place.php');

assert_logged_in();

if (!isset($_GET["id"])) {
    http_response_code(400);
    exit();
}

$mysqli = create_db_connection();

$place = find_place_by_id(intval($_GET["id"]));

$allowed = $place->userId === $_SESSION['user_id'] || is_admin();
if (!$place || !$allowed) {
    http_response_code(404);
    exit();
}

return_json($place);

close_db_connection($mysqli);
?>