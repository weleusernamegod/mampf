<?php
// Vorlage für api/config.php
// Kopiere diese Datei nach api/config.php und trage die Zugangsdaten ein.
// api/config.php ist in .gitignore und wird NIE ins Git-Repo eingecheckt.
//
// Lokal (MariaDB via Homebrew):  Host 127.0.0.1, DB mampf, User mampf, Passwort mampf-dev
// Live: liegt nur auf dem Server und wird beim Deployment nicht überschrieben.

define('MYSQL_HOST', '127.0.0.1');
define('MYSQL_DATABASE', 'mampf');
define('MYSQL_USER', 'mampf');
define('MYSQL_PASSWORD', 'mampf-dev');
?>
