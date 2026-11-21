<?php
// Kategorie anlegen ({id: -1, group, name}) oder ändern ({id, name, active}).
// Nur für Admins.
include('config.php');
include('util/db-util.php');
include('util/api-util.php');
include('util/login-util.php');
include('category/category-repository.php');

assert_logged_in();
if (!is_admin()) {
    http_response_code(403);
    exit();
}

$data = get_post_body_as_json();

if (!is_array($data) || !isset($data['id']) || !is_int($data['id'])
    || !isset($data['name']) || !is_string($data['name'])
    || !isset($data['active']) || !is_bool($data['active'])) {
    http_response_code(400);
    exit();
}
$name = trim($data['name']);
if (mb_strlen($name) < 1 || mb_strlen($name) > 50) {
    http_response_code(400);
    exit();
}

$mysqli = create_db_connection();

if ($data['id'] === -1) {
    if (!isset($data['group']) || !in_array($data['group'], category_group_keys(), TRUE)) {
        http_response_code(400);
        exit();
    }
    $group = $data['group'];
    $existing = NULL;
} else {
    $existing = find_category_by_id($data['id']);
    if (!$existing) {
        http_response_code(404);
        exit();
    }
    $group = $existing['group'];
}

// Gleicher Name in der gleichen Gruppe gibt es schon
if (category_name_taken($group, $name, $data['id'])) {
    http_response_code(409);
    exit();
}

$category = $existing
    ? update_category($data['id'], $name, $data['active'])
    : create_category($group, $name, $data['active']);

return_json($category);

close_db_connection($mysqli);
?>
