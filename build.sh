#!/bin/bash
# Baut die komplette Website nach ./dist (so wie sie auf dem Server liegt):
#   dist/            -> Karte (map), mit dem Admin-Bereich (/meine-orte, /ort/...)
#   dist/admin/      -> nur Weiterleitungen der alten Admin-Adressen
#   dist/login/      -> Login-Seiten
#   dist/api/        -> PHP-API
set -e
cd "$(dirname "$0")"

# Angular 18 braucht Node <= 22. Lokal Homebrew-node@22 verwenden, falls vorhanden.
if [ -d "/opt/homebrew/opt/node@22/bin" ]; then
  export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
fi
echo "Node $(node --version)"

# Lokal hochgeladene Bilder (dist/bilder/orte) beim Neubauen behalten
BILDER_TMP=""
if [ -d ./dist/bilder/orte ]; then
  BILDER_TMP="$(mktemp -d)"
  cp -R ./dist/bilder/orte/. "$BILDER_TMP"/
fi

# Ausgabeordner neu anlegen
rm -rf ./dist
mkdir ./dist

# Karte
(cd ./map && npm ci && npm run build)
cp -R ./map/dist/map/browser/* ./dist
cp ./map/public/.htaccess ./dist/.htaccess   # Angular kopiert keine versteckten Dateien

# Alte Admin-Adressen (/admin/...) -> neue Adressen in der Karte
mkdir -p ./dist/admin
cp ./map/public/admin/.htaccess ./dist/admin/.htaccess

# Login & API (ohne Editor-/Systemdateien und ohne Vorlage)
rsync -a --exclude '.DS_Store' ./login/ ./dist/login/
rsync -a --exclude '.DS_Store' --exclude '.vscode' --exclude '.gitignore' \
  --exclude 'config.example.php' ./api/ ./dist/api/

# Bilder der Orte: Ordner mit Schutz-.htaccess (die Bilder selbst liegen nur auf dem Server)
mkdir -p ./dist/bilder/orte
if [ -n "$BILDER_TMP" ]; then
  cp -R "$BILDER_TMP"/. ./dist/bilder/orte/
  rm -rf "$BILDER_TMP"
fi
cp ./bilder/orte/.htaccess ./dist/bilder/orte/.htaccess

echo "Fertig: ./dist"
