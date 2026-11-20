<?php
// Nur für die lokale Entwicklung (./dev.sh). Ahmt die .htaccess-Regeln nach,
// weil der eingebaute PHP-Server keine .htaccess-Dateien liest.
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$file = $_SERVER['DOCUMENT_ROOT'] . $path;

// /admin ohne Schrägstrich -> /admin/ (wie Apache)
if ($path === '/admin') {
    header('Location: /admin/', true, 301);
    exit;
}

// Unterseiten des Admin-Bereichs (z. B. /admin/place/new) -> admin/index.html
if (str_starts_with($path, '/admin/') && !is_file($file)) {
    header('Cache-Control: no-cache');
    readfile($_SERVER['DOCUMENT_ROOT'] . '/admin/index.html');
    exit;
}

// HTML-Seiten nicht cachen
if (str_ends_with($path, '/') || str_ends_with($path, '.html')) {
    header('Cache-Control: no-cache');
}

// Alles andere (Dateien, PHP-API) normal ausliefern
return false;
