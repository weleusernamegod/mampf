# mampf

Web-App mit einer Karte von Foodtrucks/Imbissständen. Live unter https://mampf.io.

## Aufbau

| Ordner | Was | Technik |
|---|---|---|
| `map/` | Öffentliche Karte (Startseite `/`) | Angular 18, @angular/google-maps |
| `mampf-admin/` | Admin-Bereich (`/admin`), eigene Orte verwalten | Angular 18, Bootstrap |
| `login/` | Login & Registrierung (`/login`) | Plain HTML + fetch |
| `api/` | Backend (`/api/*.php`) | PHP (mysqli), Sessions |
| `mampf.sql` | Datenbankschema (tbl_user, tbl_place, tbl_picture) | MySQL/MariaDB |

`build.sh` baut alles nach `dist/`. Diese Struktur entspricht 1:1 dem Webroot auf dem Server.

## Lokal entwickeln

- `./dev.sh` baut alles und startet den PHP-Server auf http://localhost:8080 (wie live).
- `./dev.sh --no-build` startet nur den Server mit dem bestehenden `dist/`.
- Für schnelles Frontend-Arbeiten mit Live-Reload: in `map/` oder `mampf-admin/` `npm start`
  (Port 4200, Proxy für `/api`, `/login`, `/admin` → localhost:8080, PHP-Server muss laufen).
- Angular 18 braucht **Node 22**: `export PATH="/opt/homebrew/opt/node@22/bin:$PATH"`
  (build.sh macht das automatisch). Node 26 ist global installiert, aber nicht kompatibel.
- Lokale DB: MariaDB via Homebrew (`brew services start mariadb`),
  DB `mampf`, User `mampf`, Passwort `mampf-dev`, Host 127.0.0.1.
- Lokaler Test-User: `test@mampf.local` / `test1234` (kein Admin).

## Zugangsdaten

- `api/config.php` ist **nicht** im Git (siehe `.gitignore`). Vorlage: `api/config.example.php`.
- Auf dem Server liegt eine eigene `config.php` mit den Live-Zugangsdaten. Das Deployment darf sie nie überschreiben oder löschen.
- Niemals Passwörter, FTP-Daten oder API-Keys committen.

## Git & Deployment

- Repo: privat auf GitHub unter dem Account des Besitzers (`origin`). `jan` = altes Repo von Jan Ebbe (nur lesen).
- Hosting: wahrscheinlich Hostpoint, Upload per FTP (bisher manuell mit Cyberduck).
- Geplant: GitHub Actions deployt `dist/` automatisch (`staging` → Test-Subdomain, `main` → mampf.io).

## Arbeitsweise

- Der Besitzer ist kein Profi-Entwickler: Schritte auf Deutsch und einfach erklären.
- Änderungen erst lokal testen (localhost:8080), dann committen.
- Commit-Nachrichten auf Deutsch, kurz und beschreibend.

## Bekannte Baustellen

- Passwörter werden mit ungesalzenem SHA-256 gehasht (`api/util/login-util.php`), sollte `password_hash()` werden.
- Angular 18 ist veraltet, `npm audit` meldet viele Schwachstellen in den Dev-Dependencies. Upgrade lohnt sich.
- Das Live-DB-Passwort steht in der alten Git-History (config.php war früher eingecheckt). Es sollte beim Hoster geändert werden.
