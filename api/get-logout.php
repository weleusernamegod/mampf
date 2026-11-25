<?php
session_start();
$_SESSION = array();
session_destroy();

// Nach dem Abmelden zurück zur Karte
header('Location: ../');
?>