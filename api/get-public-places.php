<?php
include('config.php');
include('util/db-util.php');
include('util/api-util.php');
include('place/place-repository.php');
include('picture/picture-files.php');

require_once('place/place.php');

// Wer angemeldet ist, bekommt bei eigenen Orten "bearbeiten" (Admins bei allen).
// Die Session nur öffnen, wenn schon eine besteht: Besucher ohne Anmeldung
// sollen kein Cookie bekommen. Die user_id selbst wird nie ausgeliefert.
$current_user_id = null;
$current_user_admin = false;
if (isset($_COOKIE[session_name()])) {
    session_start();
    $current_user_id = $_SESSION['user_id'] ?? null;
    $current_user_admin = !empty($_SESSION['admin']);
    session_write_close();
}

$mysqli = create_db_connection();

$dtos = array_map('_map_place_to_dto', find_all_places());
return_json($dtos);

close_db_connection($mysqli);

function _map_place_to_dto($place)
{
    global $current_user_id, $current_user_admin;
    $own = $current_user_id !== null && $place->userId === $current_user_id;
    return [
        'id' => $place->id,
        'pictureId' => $place->pictureId,
        'pictureUrl' => picture_url($place),
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
        ], $place->locations),
        'categories' => $place->categories,
        'priceMin' => $place->priceMin,
        'priceMax' => $place->priceMax,
        // Nur das Datum (JJJJ-MM-TT), ohne Uhrzeit
        'created' => substr($place->createTime ?? '', 0, 10),
        'own' => $own,
        'editable' => $own || ($current_user_id !== null && $current_user_admin)
    ];
}
?>