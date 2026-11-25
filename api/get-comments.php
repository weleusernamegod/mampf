<?php
include('config.php');
include('util/db-util.php');
include('util/api-util.php');
include('comment/comment-repository.php');

// Kommentare zu einem Ort: für alle lesbar.
// Zusätzlich: ist jemand angemeldet (dann erscheint das Eingabefeld)?
// Die Session nur öffnen, wenn schon eine besteht (Besucher bekommen kein Cookie).
$current_user_id = null;
$current_user_admin = false;
if (isset($_COOKIE[session_name()])) {
    session_start();
    $current_user_id = $_SESSION['user_id'] ?? null;
    $current_user_admin = !empty($_SESSION['admin']);
    session_write_close();
}

if (!isset($_GET['place']) || !is_numeric($_GET['place'])) {
    http_response_code(400);
    exit();
}

$mysqli = create_db_connection();
$comments = find_comments_by_place(intval($_GET['place']));
close_db_connection($mysqli);

return_json([
    'loggedIn' => $current_user_id !== null,
    'maxLength' => COMMENT_MAX_LENGTH,
    // Die user_id wird nie ausgeliefert, nur ob man den Kommentar löschen darf.
    'comments' => array_map(fn($comment) => [
        'id' => $comment['id'],
        'author' => $comment['author'] ?? 'Ohne Namen',
        'text' => $comment['text'],
        // Mit Zeitzone (z.B. 2026-11-25T14:03:00+00:00), damit der Browser richtig rechnet
        'created' => date(DATE_ATOM, strtotime($comment['created'])),
        'deletable' => $current_user_id !== null
            && ($comment['userId'] === $current_user_id || $current_user_admin),
    ], $comments),
]);
?>
