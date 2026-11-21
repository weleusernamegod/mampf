<?php
// Vorlage für api/config.php
// Kopiere diese Datei nach api/config.php und trage die Zugangsdaten ein.
// api/config.php ist in .gitignore und wird NIE ins Git-Repo eingecheckt.
//
// Lokal (MariaDB via Homebrew): Zugangsdaten siehe CLAUDE.md, Abschnitt "Lokal entwickeln".
// Live: liegt nur auf dem Server und wird beim Deployment nicht überschrieben.
//
// Hier bitte KEINE echten Passwörter eintragen, diese Datei ist öffentlich im Git.

define('MYSQL_HOST', '127.0.0.1');
define('MYSQL_DATABASE', 'mampf');
define('MYSQL_USER', 'mampf');
define('MYSQL_PASSWORD', '');
?>
