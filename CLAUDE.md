# mampf

Web-App mit einer Karte von Foodtrucks/Imbissständen. Live unter https://mampf.io.

## Aufbau

| Ordner | Was | Technik |
|---|---|---|
| `map/` | Öffentliche Karte (Startseite `/`) | Angular 18, @angular/google-maps |
| `mampf-admin/` | Admin-Bereich (`/admin`, auf der Karte "meine Orte & Konto"): eigene Orte, Profil (Name) | Angular 18, Bootstrap |
| `login/` | Login & Registrierung (`/login`) | Plain HTML + fetch |
| `api/` | Backend (`/api/*.php`) | PHP (mysqli), Sessions |
| `mampf.sql` | Datenbankschema (tbl_user, tbl_place, tbl_place_opening, tbl_place_location, tbl_category, tbl_place_category, tbl_picture, tbl_comment) | MySQL/MariaDB |
| `bilder/orte/` | Nur `.htaccess` (Bilder selbst liegen nur auf dem Server) | Apache |

| `design/font/` | Mampf-Schrift (vom Logo abgeleitet), Generator `mampf_font.py`, Testseite `testen.html` | Python (fonttools, shapely) |

Sprüche unter dem Logo: `map/public/assets/slogans.txt` (einer pro Zeile). `map/public/assets/slogan.js`
wählt bei jedem Anzeigen des Logos zufällig einen (Splashscreen, About-Seite, Login, Registrierung).
Schrift dafür: `map/public/assets/fonts/Mampf-Light.woff2` (dünne Variante) (wird von `mampf_font.py` dorthin kopiert).

Farben: Alles hängt am Farbton `--hue` in `map/src/vars.scss` (`--primary` = mampf-Grün,
`--primary-light`, `--accent` = Gegenfarbe/Weinrot). Keine Farbwerte direkt in SCSS schreiben.
Der Farbregler auf der About-Seite setzt `--hue` über `map/public/assets/theme.js` (auch in `login/`);
der Kartenstil (`map/src/app/util/map-styles.ts`) dreht seine Farbtöne mit.

`build.sh` baut alles nach `dist/`. Diese Struktur entspricht 1:1 dem Webroot auf dem Server.

Bilder der Orte: Dateien in `/bilder/orte/` auf dem Webserver (`tbl_place.picture_file` = Dateiname,
Code in `api/picture/picture-files.php`). Benutzer laden sie im Admin hoch (quadratisches JPEG).
Dateinamen einheitlich `<Ort-ID sechsstellig>-<name>-<6 Zufallszeichen>.<endung>`, z.B. `000112-banh-mi-136-a3f9c2.jpg`.
Die Bilder gibt es **nur auf dem Server** (nicht im Git, Repo ist öffentlich); das Deployment darf
den Ordner nie löschen. Im Git liegt nur `bilder/orte/.htaccess` (sperrt alles ausser Bildern).
`tbl_picture`/`picture_id` ist das alte System (nur noch für den Umzug, siehe `data/BILDER-UPDATE.md`).

## Lokal entwickeln

- `./dev.sh` baut alles und startet den PHP-Server auf http://localhost:8080 (wie live).
- `./dev.sh --no-build` startet nur den Server mit dem bestehenden `dist/`.
- Für schnelles Frontend-Arbeiten mit Live-Reload: in `map/` oder `mampf-admin/` `npm start`
  (Port 4200, Proxy für `/api`, `/login`, `/admin`, `/bilder` → localhost:8080, PHP-Server muss laufen).
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

- Repo: **öffentlich** auf GitHub unter dem Account des Besitzers (`origin`). `jan` = altes Repo von Jan Ebbe (nur lesen).
- Hosting: Hostpoint. Datenbank `geiseryv_mampf`, verwalten über phpMyAdmin im Hostpoint Control Panel.
- **Deployment läuft automatisch:** Jeder Push auf `main` baut und lädt per FTPS auf mampf.io hoch
  (`.github/workflows/deploy.yml`, lässt `api/config.php` aus). Kein manueller Upload nötig.
  Status: `gh run list -R weleusernamegod/mampf`.
- Datenbank-Migrationen (`data/migration-*.sql`) laufen **nicht** automatisch: vor dem Push in
  phpMyAdmin ausführen (der Besitzer meldet sich im Browser-Fenster an).
- Geplant: `staging` → Test-Subdomain.

## Arbeitsweise

- Der Besitzer ist kein Profi-Entwickler: Schritte auf Deutsch und einfach erklären.
- Änderungen erst lokal testen (localhost:8080), dann committen.
- Commit-Nachrichten auf Deutsch, kurz und beschreibend.
- Versionsnummer in `map/src/app/version.ts` bei **jedem Commit** um 1 hochzählen
  (0.0.001 → 0.0.002 → …, immer dreistellig). Sie erscheint auf der About-Seite.

## Bekannte Baustellen

- Passwörter werden mit ungesalzenem SHA-256 gehasht (`api/util/login-util.php`), sollte `password_hash()` werden.
- Angular 18 ist veraltet, `npm audit` meldet viele Schwachstellen in den Dev-Dependencies. Upgrade lohnt sich.
- Das alte Live-DB-Passwort steht in der öffentlichen Git-History, wurde aber im Nov. 2026 beim Hoster geändert (ist also ungültig).
