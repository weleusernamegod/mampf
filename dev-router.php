<?php
// Nur für die lokale Entwicklung (./dev.sh). Ahmt die .htaccess-Regeln nach,
// weil der eingebaute PHP-Server keine .htaccess-Dateien liest.
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$file = $_SERVER['DOCUMENT_ROOT'] . $path;

// /login ohne Schrägstrich -> mit Schrägstrich (wie Apache)
if ($path === '/login') {
    header('Location: /login/', true, 301);
    exit;
}

// Alte Admin-Adressen -> neue Adressen in der Karte (wie map/public/admin/.htaccess)
if ($path === '/admin' || str_starts_with($path, '/admin/')) {
    $target = '/meine-orte';
    if (preg_match('#^/admin/place/new/?$#', $path)) $target = '/ort/neu';
    elseif (preg_match('#^/admin/place/([0-9]+)/?$#', $path, $m)) $target = '/ort/' . $m[1];
    elseif (preg_match('#^/admin/profile/?$#', $path)) $target = '/profil';
    elseif (preg_match('#^/admin/categories/?$#', $path)) $target = '/kategorien';
    header('Location: ' . $target, true, 301);
    exit;
}

// Unterseiten der Karte (z.B. /meine-orte) -> index.html (wie map/public/.htaccess)
if (!file_exists($file) && !preg_match('#^/(api|admin|login|bilder)(/|$)#', $path)) {
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
