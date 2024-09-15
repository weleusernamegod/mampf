<?php
require_once('user.php');

function create_user($user)
{
    global $mysqli;

    $statement = $mysqli->prepare("INSERT INTO tbl_user (mail, password_hash, admin, registration_time, last_login_time) VALUES (?, ?, ?, ?, ?)");
    $statement->bind_param("ssis", $user->mail, $user->passwordHash, $user->admin, $user->registrationTime, $user->lastLoginTime);
    $statement->execute();
    $statement->close();

    $user->id = $mysqli->insert_id;
    return $user;
}

function update_user($user)
{
    global $mysqli;

    $statement = $mysqli->prepare("UPDATE tbl_user SET mail= ?, password_hash = ?, admin = ?, last_login_time = ?, registration_time = ? WHERE id = ?");
    $statement->bind_param("ssisi", $user->mail, $user->passwordHash, $user->admin, $user->lastLoginTime, $user->registrationTime, $user->id);
    $statement->execute();
    $statement->close();

    return $user;
}

function find_all_users()
{
    global $mysqli;

    $users = array();

    $result = $mysqli->query('SELECT id, mail, password_hash, admin, registration_time, last_login_time FROM tbl_user');
    while ($row = $result->fetch_assoc()) {
        $user = _map_row_to_user($row);
        array_push($users, $user);
    }

    return $users;
}

function find_user_by_id($id) {
    global $mysqli;

    $statement = $mysqli->prepare("SELECT id, mail, password_hash, admin, registration_time, last_login_time FROM tbl_user WHERE id = ? LIMIT 1");
    $statement->bind_param("i", $id);
    $statement->execute();

    $row = $statement->get_result()->fetch_assoc();
    if (!$row) {
        return null;
    }

    $user = _map_row_to_user($row);

    $statement->close();

    return $user;
}

function find_user_by_mail($mail) {
    global $mysqli;

    $statement = $mysqli->prepare("SELECT id, mail, password_hash, admin, registration_time, last_login_time FROM tbl_user WHERE mail = ? LIMIT 1");
    $statement->bind_param("s", $mail);
    $statement->execute();

    $row = $statement->get_result()->fetch_assoc();
    if (!$row) {
        return null;
    }

    $user = _map_row_to_user($row);

    $statement->close();

    return $user;
}


function _map_row_to_user($row) {
    return new User($row["id"], $row["mail"], $row["password_hash"], boolval($row["admin"]), $row["registration_time"], $row["last_login_time"]);
}
?>