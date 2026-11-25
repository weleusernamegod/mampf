<?php
include('config.php');
include('util/db-util.php');
include('util/api-util.php');
include('util/login-util.php');
include('user/user-repository.php');

require_once('user/user.php');

assert_logged_in();

$mysqli = create_db_connection();

$user = find_user_by_id($_SESSION['user_id']);
if (!$user) {
    http_response_code(404);
    exit();
}
return_json(_map_user_to_dto($user));

close_db_connection($mysqli);

function _map_user_to_dto($user)
{
    return [
        'id' => $user->id,
        'mail' => $user->mail,
        'name' => $user->name,
        'admin' => $user->admin
    ];
}
?>