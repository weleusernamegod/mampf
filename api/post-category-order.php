<?php
// Reihenfolge einer Gruppe speichern: {group, ids: [id, id, …]}. Nur für Admins.
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

if (!is_array($data) || !isset($data['group']) || !in_array($data['group'], category_group_keys(), TRUE)
    || !isset($data['ids']) || !is_array($data['ids']) || count($data['ids']) > 500) {
    http_response_code(400);
    exit();
}
foreach ($data['ids'] as $id) {
    if (!is_int($id)) {
        http_response_code(400);
        exit();
    }
}

$mysqli = create_db_connection();

update_category_order($data['group'], array_values($data['ids']));

close_db_connection($mysqli);
?>
