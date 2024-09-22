<?php
include('config.php');
include('util/db-util.php');
include('util/api-util.php');
include('util/login-util.php');
include('user/user-repository.php');

require_once('user/user.php');

$data = get_post_body_as_json();
if (!_validate_payload($data)) {
    http_response_code(400);
    exit();
}

$mysqli = create_db_connection();

$user = find_user_by_mail($data['mail']);
if (!$user) {
    http_response_code(400);
    exit();
}

$passwordHash = hash_password($data['password']);
if ($passwordHash !== $user->passwordHash) {
    http_response_code(400);
    exit();
}

$user->lastLoginTime = date("Y-m-d H:i:s");
update_user($user);

session_start();
$_SESSION['user_id'] = $user->id;
$_SESSION['admin'] = $user->admin;

close_db_connection($mysqli);

function _validate_payload($data)
{
    if (!isset($data['mail']) || !is_string($data['mail']) || strlen($data['mail']) < 5 || strlen($data['mail']) > 128) {
        return FALSE;
    }
    if (!isset($data['password']) || !is_string($data['password']) || strlen($data['password']) < 5 || strlen($data['password']) > 128) {
        return FALSE;
    }
    return TRUE;
}
?>