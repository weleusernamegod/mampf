<?php
function return_json($data)
{
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data);
}

function get_post_body_as_json()
{
    return json_decode(file_get_contents('php://input'), TRUE);
}
?>