<?php
require_once('picture.php');

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