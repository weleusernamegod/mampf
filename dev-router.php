<?php
// Nur für die lokale Entwicklung (./dev.sh). Ahmt die .htaccess-Regeln nach,
// weil der eingebaute PHP-Server keine .htaccess-Dateien liest.
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$file = $_SERVER['DOCUMENT_ROOT'] . $path;

// Unterseiten der Karte (z.B. /meine-orte) -> index.html (wie map/public/.htaccess)
if (!file_exists($file) && !preg_match('#^/(api|bilder)(/|$)#', $path)) {
    header('Cache-Control: no-cache');
    readfile($_SERVER['DOCUMENT_ROOT'] . '/index.html');
    exit;
}

// HTML-Seiten nicht cachen
if (str_ends_with($path, '/') || str_ends_with($path, '.html')) {
    header('Cache-Control: no-cache');
}

// Alles andere (Dateien, PHP-API) normal ausliefern
return false;
