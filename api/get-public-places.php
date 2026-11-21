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
        'opening' => $place->opening,
        'locations' => array_map(fn($location) => [
            'weekday' => $location['weekday'],
            'position' => [
                'lat' => $location['lat'],
                'lng' => $location['lng']
            ],
            'label' => $location['label']
        ], $place->locations)
    ];
}
?>