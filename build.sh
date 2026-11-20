#!/bin/bash
# Baut die komplette Website nach ./dist (so wie sie auf dem Server liegt):
#   dist/            -> Karte (map)
#   dist/admin/      -> Admin-App (mampf-admin)
#   dist/login/      -> Login-Seiten
#   dist/api/        -> PHP-API
set -e
cd "$(dirname "$0")"

# Angular 18 braucht Node <= 22. Lokal Homebrew-node@22 verwenden, falls vorhanden.
if [ -d "/opt/homebrew/opt/node@22/bin" ]; then
  export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
fi
echo "Node $(node --version)"

# Ausgabeordner neu anlegen
rm -rf ./dist
mkdir ./dist

# Karte
(cd ./map && npm ci && npm run build)
cp -R ./map/dist/map/browser/* ./dist
cp ./map/public/.htaccess ./dist/.htaccess   # Angular kopiert keine versteckten Dateien

# Admin
mkdir ./dist/admin
(cd ./mampf-admin && npm ci && npm run build)
cp -R ./mampf-admin/dist/mampf-admin/browser/* ./dist/admin
cp ./mampf-admin/public/.htaccess ./dist/admin/.htaccess

# Login & API (ohne Editor-/Systemdateien und ohne Vorlage)
rsync -a --exclude '.DS_Store' ./login/ ./dist/login/
rsync -a --exclude '.DS_Store' --exclude '.vscode' --exclude '.gitignore' \
  --exclude 'config.example.php' ./api/ ./dist/api/

echo "Fertig: ./dist"
