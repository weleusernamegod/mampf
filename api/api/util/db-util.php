<?php
function create_db_connection()
{
  $mysqli = new mysqli(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE);
  if (!$mysqli) {
    die('Could not connect to database');
  }
  return $mysqli;
}

function close_db_connection($mysqli)
{
  $mysqli->close();
}
?>