<?php
require_once('place.php');
require_once(__DIR__ . '/../category/category-repository.php');

const PLACE_COLUMNS = 'id, user_id, picture_id, name, description, lat, lng, create_time, last_update_time';

function create_place($place)
{
    global $mysqli;

    $statement = $mysqli->prepare("INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, create_time, last_update_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
    $statement->bind_param("iissddss", $place->userId, $place->pictureId, $place->name, $place->description, $place->lat, $place->lng, $place->createTime, $place->lastUpdateTime);
    $statement->execute();
    $statement->close();

    $place->id = $mysqli->insert_id;
    return $place;
}

function update_place($place)
{
    global $mysqli;

    $statement = $mysqli->prepare("UPDATE tbl_place SET user_id = ?, picture_id = ?, name = ?, description = ?, lat = ?, lng = ?, last_update_time = ?, create_time = ? WHERE id = ?");
    $statement->bind_param("iissddssi", $place->userId, $place->pictureId, $place->name, $place->description, $place->lat, $place->lng, $place->lastUpdateTime, $place->createTime, $place->id);
    $statement->execute();
    $statement->close();

    return $place;
}

/** Öffnungszeiten und Standorte eines Ortes komplett ersetzen. */
function save_place_schedule($place)
{
    global $mysqli;

    $statement = $mysqli->prepare("DELETE FROM tbl_place_opening WHERE place_id = ?");
    $statement->bind_param("i", $place->id);
    $statement->execute();
    $statement->close();

    $statement = $mysqli->prepare("INSERT INTO tbl_place_opening (place_id, weekday, slot) VALUES (?, ?, ?)");
    foreach ($place->opening as $opening) {
        $statement->bind_param("iis", $place->id, $opening['weekday'], $opening['slot']);
        $statement->execute();
    }
    $statement->close();

    $statement = $mysqli->prepare("DELETE FROM tbl_place_location WHERE place_id = ?");
    $statement->bind_param("i", $place->id);
    $statement->execute();
    $statement->close();

    $statement = $mysqli->prepare("INSERT INTO tbl_place_location (place_id, weekday, lat, lng, label) VALUES (?, ?, ?, ?, ?)");
    foreach ($place->locations as $location) {
        $statement->bind_param("iidds", $place->id, $location['weekday'], $location['lat'], $location['lng'], $location['label']);
        $statement->execute();
    }
    $statement->close();
}

function delete_place_by_id($id)
{
    global $mysqli;

    // Öffnungszeiten, Standorte und Kategorien zuerst (wären dank
    // ON DELETE CASCADE auch so weg, aber sicher ist sicher)
    foreach (['tbl_place_opening', 'tbl_place_location', 'tbl_place_category'] as $table) {
        $statement = $mysqli->prepare("DELETE FROM $table WHERE place_id = ?");
        $statement->bind_param("i", $id);
        $statement->execute();
        $statement->close();
    }

    $statement = $mysqli->prepare("DELETE FROM tbl_place WHERE id = ?");
    $statement->bind_param("i", $id);
    $statement->execute();
    $statement->close();
}

function find_all_places()
{
    global $mysqli;

    $places = array();

    $result = $mysqli->query('SELECT ' . PLACE_COLUMNS . ' FROM tbl_place');
    while ($row = $result->fetch_assoc()) {
        $place = _map_row_to_place($row);
        array_push($places, $place);
    }

    return _load_schedules($places);
}

function find_place_by_id($id)
{
    global $mysqli;

    $statement = $mysqli->prepare('SELECT ' . PLACE_COLUMNS . ' FROM tbl_place WHERE id = ? LIMIT 1');
    $statement->bind_param("i", $id);
    $statement->execute();

    $row = $statement->get_result()->fetch_assoc();
    $statement->close();
    if (!$row) {
        return NULL;
    }

    return _load_schedules([_map_row_to_place($row)])[0];
}

function find_places_by_user_id($user_id)
{
    global $mysqli;

    $places = array();

    $statement = $mysqli->prepare('SELECT ' . PLACE_COLUMNS . ' FROM tbl_place WHERE user_id = ?');
    $statement->bind_param("i", $user_id);
    $statement->execute();
    $result = $statement->get_result();

    while ($row = $result->fetch_assoc()) {
        $place = _map_row_to_place($row);
        array_push($places, $place);
    }

    $statement->close();

    return _load_schedules($places);
}

/** Öffnungszeiten, Standorte und Kategorien zu den Orten laden (je eine Abfrage für alle). */
function _load_schedules($places)
{
    global $mysqli;

    if (count($places) === 0) {
        return $places;
    }

    $byId = array();
    foreach ($places as $place) {
        $byId[$place->id] = $place;
    }
    $ids = implode(',', array_map('intval', array_keys($byId)));

    $result = $mysqli->query("SELECT place_id, weekday, slot FROM tbl_place_opening WHERE place_id IN ($ids) ORDER BY place_id, weekday, FIELD(slot, 'morning', 'noon', 'evening')");
    while ($row = $result->fetch_assoc()) {
        $byId[intval($row['place_id'])]->opening[] = [
            'weekday' => intval($row['weekday']),
            'slot' => $row['slot']
        ];
    }

    $result = $mysqli->query("SELECT place_id, weekday, lat, lng, label FROM tbl_place_location WHERE place_id IN ($ids) ORDER BY place_id, weekday, id");
    while ($row = $result->fetch_assoc()) {
        $byId[intval($row['place_id'])]->locations[] = [
            'weekday' => intval($row['weekday']),
            'lat' => floatval($row['lat']),
            'lng' => floatval($row['lng']),
            'label' => $row['label']
        ];
    }

    foreach (find_active_category_ids_by_place_ids(array_keys($byId)) as $placeId => $categoryIds) {
        $byId[$placeId]->categories = $categoryIds;
    }

    return $places;
}

function _map_row_to_place($row)
{
    $pictureId = $row["picture_id"] ? intval($row["picture_id"]) : NULL;
    return new Place(intval($row["id"]), intval($row["user_id"]), $pictureId, $row["name"], $row["description"], floatval($row["lat"]), floatval($row["lng"]), $row["create_time"], $row["last_update_time"]);
}
?>