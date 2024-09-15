<?php
require_once('place.php');

function create_place($place)
{
    global $mysqli;

    $statement = $mysqli->prepare("INSERT INTO tbl_place (user_id, name, description, lat, lng, logo_filename, open_sunday, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_morning, open_noon, open_evening, open_night, create_time, last_update_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    $statement->bind_param("issddsiiiiiiiiiiis", $place->userId, $place->name, $place->description, $place->lat, $place->lng, $place->logoFilename, $place->openSunday, $place->openMonday, $place->openTuesday, $place->openWednesday, $place->openThursday, $place->openFriday, $place->openSaturday, $place->openMorning, $place->openNoon, $place->openEvening, $place->openNight, $place->createTime, $place->lastUpdateTime);
    $statement->execute();
    $statement->close();

    $place->id = $mysqli->insert_id;
    return $place;
}

function update_place($place)
{
    global $mysqli;

    $statement = $mysqli->prepare("UPDATE tbl_place SET user_id = ?, name = ?, description = ?, lat = ?, lng = ?, logo_filename = ?, open_sunday = ?, open_monday = ?, open_tuesday = ?, open_wednesday = ?, open_thursday = ?, open_friday = ?, open_saturday = ?, open_morning = ?, open_noon = ?, open_evening = ?, open_night = ?, last_update_time = ?, create_time = ? WHERE id = ?");
    $statement->bind_param("issddsiiiiiiiiiiisi", $place->userId, $place->name, $place->description, $place->lat, $place->lng, $place->logoFilename, $place->openSunday, $place->openMonday, $place->openTuesday, $place->openWednesday, $place->openThursday, $place->openFriday, $place->openSaturday, $place->openMorning, $place->openNoon, $place->openEvening, $place->openNight, $place->lastUpdateTime, $place->createTime, $place->id);
    $statement->execute();
    $statement->close();

    return $place;
}

function find_all_places()
{
    global $mysqli;

    $places = array();

    $result = $mysqli->query('SELECT id, user_id, name, description, lat, lng, logo_filename, open_sunday, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_morning, open_noon, open_evening, open_night, create_time, last_update_time FROM tbl_place');
    while ($row = $result->fetch_assoc()) {
        $place = _map_row_to_place($row);
        array_push($places, $place);
    }

    return $places;
}

function find_place_by_id($id) {
    global $mysqli;

    $statement = $mysqli->prepare("SELECT id, user_id, name, description, lat, lng, logo_filename, open_sunday, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_morning, open_noon, open_evening, open_night, create_time, last_update_time FROM tbl_place WHERE id = ? LIMIT 1");
    $statement->bind_param("i", $id);
    $statement->execute();

    $row = $statement->get_result()->fetch_assoc();
    if (!$row) {
        return null;
    }
    
    $place = _map_row_to_place($row);

    $statement->close();

    return $place;
}

function find_places_by_user_id($user_id) {
    global $mysqli;

    $places = array();

    $statement = $mysqli->prepare("SELECT id, user_id, name, description, lat, lng, logo_filename, open_sunday, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_morning, open_noon, open_evening, open_night, create_time, last_update_time FROM tbl_place WHERE user_id = ?");
    $statement->bind_param("i", $user_id);
    $statement->execute();
    $result = $statement->get_result();

    while ($row = $result->fetch_assoc()) {
        $place = _map_row_to_place($row);
        array_push($places, $place);
    }

    $statement->close();

    return $places;
}

function _map_row_to_place($row) {
    return new Place($row["id"], $row["user_id"], $row["name"], $row["description"], $row["lat"], $row["lng"], $row["logo_filename"], boolval($row["open_sunday"]), boolval($row["open_monday"]), boolval($row["open_tuesday"]), boolval($row["open_wednesday"]), boolval($row["open_thursday"]), boolval($row["open_friday"]), boolval($row["open_saturday"]), boolval($row["open_morning"]), boolval($row["open_noon"]), boolval($row["open_evening"]), boolval($row["open_night"]), $row["create_time"], $row["last_update_time"]);
}
?>