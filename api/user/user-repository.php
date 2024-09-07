<?php
require_once('user.php');

function create_user($user)
{
    global $mysqli;

    $user->registrationTime = date("Y-m-d H:i:s");

    $statement = $mysqli->prepare("INSERT INTO tbl_user (mail, password_hash, admin, registration_time) VALUES (?, ?, ?, ?)");
    $statement->bind_param("ssis", $user->mail, $user->passwordHash, $user->admin, $user->registrationTime);
    $statement->execute();
    $statement->close();

    $user->id = $mysqli->insert_id;
    return $user;
}
?>