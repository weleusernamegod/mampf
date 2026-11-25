<?php
include('config.php');
include('util/db-util.php');
include('util/api-util.php');
include('util/login-util.php');
include('comment/comment-repository.php');

// Neuer Kommentar: nur mit Login.
assert_logged_in();

$data = get_post_body_as_json();
$placeId = $data['placeId'] ?? NULL;
$text = is_string($data['text'] ?? NULL) ? trim($data['text']) : NULL;

// mb_strlen zählt Zeichen (ä oder 🌮 = 1), nicht Bytes
if (
    !is_int($placeId)
    || $text === NULL || mb_strlen($text) < 1 || mb_strlen($text) > COMMENT_MAX_LENGTH
) {
    http_response_code(400);
    exit();
}

$mysqli = create_db_connection();

if (!place_exists($placeId)) {
    http_response_code(404);
    exit();
}
if (commented_recently($_SESSION['user_id'])) {
    http_response_code(429); // zu schnell hintereinander
    exit();
}

$id = create_comment($placeId, $_SESSION['user_id'], $text);
close_db_connection($mysqli);

return_json(['id' => $id]);
?>
