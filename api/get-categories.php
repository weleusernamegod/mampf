<?php
// Liste der Kategorien für Karte und Admin.
//   get-categories.php        -> nur sichtbare (öffentlich)
//   get-categories.php?all=1  -> auch ausgeblendete (nur für Admins)
include('config.php');
include('util/db-util.php');
include('util/api-util.php');
include('util/login-util.php');
include('category/category-repository.php');

$all = isset($_GET['all']);
if ($all) {
    assert_logged_in();
    if (!is_admin()) {
        http_response_code(403);
        exit();
    }
}

$mysqli = create_db_connection();

$categories = find_categories(!$all);
if (!$all) {
    // Öffentlich braucht es "active" nicht (ist immer true)
    $categories = array_map(function ($category) {
        unset($category['active']);
        return $category;
    }, $categories);
}

return_json([
    'groups' => category_groups(),
    'categories' => $categories
]);

close_db_connection($mysqli);
?>
