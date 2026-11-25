<?php
// Ist jemand angemeldet? (Für die About-Seite der Karte: "Login / Anmelden"
// oder "meine Orte & Konto".) Die Session nur öffnen, wenn schon eine besteht:
// Besucher ohne Anmeldung sollen kein Cookie bekommen.
include('util/api-util.php');

$loggedIn = false;
if (isset($_COOKIE[session_name()])) {
    session_start();
    $loggedIn = isset($_SESSION['user_id']);
    session_write_close();
}

header('Cache-Control: no-store');
return_json(['loggedIn' => $loggedIn]);
?>
