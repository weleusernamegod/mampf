<?php
include('config.php');
include('util/db-util.php');

require_once('user/user.php');

$mysqli = create_db_connection();


close_db_connection($mysqli);
?>