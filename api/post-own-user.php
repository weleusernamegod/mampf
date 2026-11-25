<?php
include('config.php');
include('util/db-util.php');
include('util/api-util.php');
include('util/login-util.php');
include('user/user-repository.php');

require_once('user/user.php');

// Eigenes Profil ändern: vorerst nur der Anzeigename (erscheint bei Kommentaren).
assert_logged_in();

$data = get_post_body_as_json();
$name = normalize_user_name($data['name'] ?? NULL);
if (!is_valid_user_name($name)) {
    http_response_code(400);
    exit();
}

$mysqli = create_db_connection();

$user = find_user_by_id($_SESSION['user_id']);
if (!$user) {
    http_response_code(404);
    exit();
}
$user->name = $name;
update_user($user);

close_db_connection($mysqli);

return_json(['name' => $name]);
?>
