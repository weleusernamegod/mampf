<?php
include('config.php');
include('util/db-util.php');
include('util/api-util.php');
include('util/login-util.php');
include('comment/comment-repository.php');

// Eigenen Kommentar löschen (Admins dürfen alle löschen).
assert_logged_in();

$data = get_post_body_as_json();
$id = $data['id'] ?? NULL;
if (!is_int($id)) {
    http_response_code(400);
    exit();
}

$mysqli = create_db_connection();

$comment = find_comment_by_id($id);
if (!$comment || ($comment['userId'] !== $_SESSION['user_id'] && !is_admin())) {
    http_response_code(404);
    exit();
}

delete_comment_by_id($id);
close_db_connection($mysqli);
?>
