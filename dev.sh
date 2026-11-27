#!/bin/bash
# Startet mampf lokal wie auf dem Server: http://localhost:8080
#   ./dev.sh          -> baut alles neu und startet den PHP-Server
#   ./dev.sh --no-build  -> startet nur den Server mit dem bestehenden ./dist
set -e
cd "$(dirname "$0")"
[ "$1" != "--no-build" ] && ./build.sh
# api/config.php (lokal, nicht im Git) immer frisch nach dist kopieren
cp ./api/config.php ./dist/api/config.php
echo "mampf läuft auf http://localhost:8080  (Stoppen mit Ctrl-C)"
# Auch im WLAN erreichbar (z.B. iPhone): http://<IP des Macs>:8080
IP=$(ipconfig getifaddr en0 2>/dev/null || true)
[ -n "$IP" ] && echo "Im WLAN (iPhone):  http://$IP:8080"
php -S 0.0.0.0:8080 -t ./dist ./dev-router.php
