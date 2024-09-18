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

return_json(_map_place_to_dto($place));

close_db_connection($mysqli);

function _map_place_to_dto($place)
{
    return [
	    'id' => $place->id,
		'pictureId' => $place->pictureId,
        'name' => $place->name,
        'description' => $place->description,
        'lat' => $place->lat,
        'lng' => $place->lng,
        'openSunday' => $place->openSunday,
        'openMonday' => $place->openMonday,
        'openTuesday' => $place->openTuesday,
        'openWednesday' => $place->openWednesday,
        'openThursday' => $place->openThursday,
        'openFriday' => $place->openFriday,
        'openSaturday' => $place->openSaturday,
        'openMorning' => $place->openMorning,
        'openNoon' => $place->openNoon,
        'openEvening' => $place->openEvening,
        'openNight' => $place->openNight
    ];
}
?>