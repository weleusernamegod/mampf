<?php
/** Höchstlänge eines Kommentars in Zeichen (kurz, ähnlich wie Twitter). */
const COMMENT_MAX_LENGTH = 130;
/** So viele Sekunden muss man zwischen zwei Kommentaren warten (gegen Spam). */
const COMMENT_MIN_INTERVAL = 20;

/** Alle Kommentare zu einem Ort, neueste zuerst, mit dem aktuellen Namen der Person. */
function find_comments_by_place($placeId)
{
    global $mysqli;

    $statement = $mysqli->prepare("SELECT c.id, c.user_id, u.name, c.text, c.create_time FROM tbl_comment c JOIN tbl_user u ON u.id = c.user_id WHERE c.place_id = ? ORDER BY c.create_time DESC, c.id DESC LIMIT 200");
    $statement->bind_param("i", $placeId);
    $statement->execute();
    $result = $statement->get_result();

    $comments = array();
    while ($row = $result->fetch_assoc()) {
        $comments[] = [
            'id' => intval($row['id']),
            'userId' => intval($row['user_id']),
            'author' => $row['name'], // NULL = noch kein Name gewählt
            'text' => $row['text'],
            'created' => $row['create_time'],
        ];
    }
    $statement->close();
    return $comments;
}

function find_comment_by_id($id)
{
    global $mysqli;

    $statement = $mysqli->prepare("SELECT id, user_id FROM tbl_comment WHERE id = ? LIMIT 1");
    $statement->bind_param("i", $id);
    $statement->execute();
    $row = $statement->get_result()->fetch_assoc();
    $statement->close();
    return $row ? ['id' => intval($row['id']), 'userId' => intval($row['user_id'])] : NULL;
}

function create_comment($placeId, $userId, $text)
{
    global $mysqli;

    $now = date("Y-m-d H:i:s");
    $statement = $mysqli->prepare("INSERT INTO tbl_comment (place_id, user_id, text, create_time) VALUES (?, ?, ?, ?)");
    $statement->bind_param("iiss", $placeId, $userId, $text, $now);
    $statement->execute();
    $statement->close();
    return $mysqli->insert_id;
}

function delete_comment_by_id($id)
{
    global $mysqli;

    $statement = $mysqli->prepare("DELETE FROM tbl_comment WHERE id = ?");
    $statement->bind_param("i", $id);
    $statement->execute();
    $statement->close();
}

/** Hat dieser Nutzer in den letzten Sekunden schon kommentiert? */
function commented_recently($userId)
{
    global $mysqli;

    $since = date("Y-m-d H:i:s", time() - COMMENT_MIN_INTERVAL);
    $statement = $mysqli->prepare("SELECT 1 FROM tbl_comment WHERE user_id = ? AND create_time > ? LIMIT 1");
    $statement->bind_param("is", $userId, $since);
    $statement->execute();
    $found = $statement->get_result()->fetch_assoc() !== NULL;
    $statement->close();
    return $found;
}

function place_exists($placeId)
{
    global $mysqli;

    $statement = $mysqli->prepare("SELECT 1 FROM tbl_place WHERE id = ? LIMIT 1");
    $statement->bind_param("i", $placeId);
    $statement->execute();
    $found = $statement->get_result()->fetch_assoc() !== NULL;
    $statement->close();
    return $found;
}
?>
