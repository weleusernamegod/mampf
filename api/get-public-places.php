<?php
include('config.php');
include('util/db-util.php');
include('util/api-util.php');
include('place/place-repository.php');

require_once('place/place.php');

$mysqli = create_db_connection();

$dtos = array_map('_map_place_to_dto', find_all_places());
return_json($dtos);

close_db_connection($mysqli);

function _map_place_to_dto($place)
{
    return [
        'id' => $place->id,
        'pictureId' => $place->pictureId,
        'name' => $place->name,
        'description' => $place->description,
        'position' => [
            'lat' => $place->lat,
            'lng' => $place->lng
        ],
        'openDays' => [
            'sunday' => $place->openSunday,
            'monday' => $place->openMonday,
            'tuesday' => $place->openTuesday,
            'wednesday' => $place->openWednesday,
            'thursday' => $place->openThursday,
            'friday' => $place->openFriday,
            'saturday' => $place->openSaturday
        ],
        'openingHours' => [
            'morning' => $place->openMorning,
            'noon' => $place->openNoon,
            'evening' => $place->openEvening,
            'night' => $place->openNight
        ]
    ];
}
?>