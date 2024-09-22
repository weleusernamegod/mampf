<?php
require_once('picture.php');

function create_picture($picture)
{
    global $mysqli;

    $statement = $mysqli->prepare("INSERT INTO tbl_picture (data, type, width, height) VALUES (?, ?, ?, ?)");
    $statement->bind_param("ssii", $picture->data, $picture->type, $picture->width, $picture->height);
    $statement->execute();
    $statement->close();

    $picture->id = $mysqli->insert_id;
    return $picture;
}

function update_picture($picture)
{
    global $mysqli;

    $statement = $mysqli->prepare("UPDATE tbl_picture SET data = ?, type = ?, width = ?, height = ? WHERE id = ?");
    $statement->bind_param("ssiii", $picture->data, $picture->type, $picture->width, $picture->height, $picture->id);
    $statement->execute();
    $statement->close();

    return $picture;
}

function delete_picture_by_id($id) {
	global $mysqli;

    $statement = $mysqli->prepare("DELETE FROM tbl_picture WHERE id = ?");
    $statement->bind_param("i", $id);
    $statement->execute();
    $statement->close();
}

function find_picture_by_id($id) {
    global $mysqli;

    $statement = $mysqli->prepare("SELECT id, data, type, width, height FROM tbl_picture WHERE id = ? LIMIT 1");
    $statement->bind_param("i", $id);
    $statement->execute();

    $row = $statement->get_result()->fetch_assoc();
    if (!$row) {
        return null;
    }

    $picture = _map_row_to_picture($row);

    $statement->close();

    return $picture;
}

function _map_row_to_picture($row) {
    return new Picture(intval($row["id"]), $row["data"], $row["type"], intval($row["width"]), intval($row["height"]));
}
?>