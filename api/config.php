<?php
$isDev = str_contains($_SERVER['SCRIPT_FILENAME'], 'xampp');

if ($isDev) {
	define('MYSQL_HOST', '127.0.0.1');
	define('MYSQL_DATABASE', 'mampf');
	define('MYSQL_USER', 'root');
	define('MYSQL_PASSWORD', '');
} else {
	define('MYSQL_HOST', 'geiseryv.mysql.db.internal');
	define('MYSQL_DATABASE', 'geiseryv_mampf');
	define('MYSQL_USER', 'geiseryv_mampf');
	define('MYSQL_PASSWORD', 'KLF7CqW7H?4gwDP9aVn5');
}
?>