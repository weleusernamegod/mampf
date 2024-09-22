<?php
include('config.php');
include('util/db-util.php');
include('util/api-util.php');
include('util/login-util.php');
include('place/place-repository.php');

require_once('place/place.php');

assert_logged_in();

$mysqli = create_db_connection();

$places = find_places_by_user_id($_SESSION['user_id']);
$dtos = array_map('_map_place_to_dto', $places);
return_json($dtos);

close_db_connection($mysqli);

function _map_place_to_dto($place)
{
    return [
        'id' => $place->id,
        'pictureId' => $place->pictureId,
        'name' => $place->name,
        'description' => $place->description
    ];
}
?>