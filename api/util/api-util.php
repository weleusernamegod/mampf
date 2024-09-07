<?php
function return_json($data)
{
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data);
}
?>