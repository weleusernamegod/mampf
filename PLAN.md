# Geplante Änderungen

Gesammelte Vorschläge (Stand 21.11.2026). Umsetzung, sobald der Besitzer wieder am Laptop ist.
Reihenfolge der Umsetzung: 1. Öffnungszeiten + Standorte, 2. Kategorien. Jeweils eigener Commit.

**Stand:** Öffnungszeiten (2) und Standorte (3) umgesetzt in Version 0.0.004,
Kategorien (1) in Version 0.0.005. Sicherheit (5) erledigt. Live-Datenbank (4):
Migrationsdatei und Anleitung bereit, noch nicht live ausgeführt.

## 1. Kategorien ✅ erledigt (0.0.005)

- Neue Tabellen:
  - `tbl_category` (id, gruppe, name, reihenfolge, aktiv)
  - `tbl_place_category` (place_id, category_id)
- `api/get-categories.php` liefert die Liste; Karte und Admin laden sie von dort,
  Änderungen wirken also überall automatisch (kein neuer Build nötig).
- Verwaltung über eine Admin-Seite (nur für `tbl_user.admin = 1`):
  hinzufügen, umbenennen, Reihenfolge ändern, ausblenden (statt löschen).
- Admin beim Erfassen eines Ortes:
  - **Art des Lokals**: genau eine Auswahl
  - **Küchen, Gerichte, Zusätze**: mehrere Chips
- Filter auf der Karte:
  - Abschnitte pro Gruppe, mit Anzahl Orte; Kategorien ohne Orte ausblenden.
  - Innerhalb einer Gruppe **oder**, zwischen Gruppen **und**
    (z.B. „Italienisch oder Griechisch“ und „Vegan“).
- Ersetzt die heutige Stichwort-Testversion `map/src/app/util/cuisine-filter.ts`.
  Einmaliges Skript ordnet bestehenden Orten anhand der Stichworte Kategorien vor.
- „Bäckerei“ nur unter „Art des Lokals“ (nicht auch unter „Gerichte“).

### Kategorien-Liste

**Küchen:** Schweizer, Italienisch, Französisch, Spanisch, Griechisch, Balkan, Georgisch,
Türkisch, Libanesisch, Persisch, Israelisch, Eritreisch, Indisch, Sri Lankisch, Tibetisch,
Chinesisch, Japanisch, Koreanisch, Thailändisch, Vietnamesisch, Indonesisch, Mexikanisch,
Peruanisch, Brasilianisch, Amerikanisch, Hawaiianisch

**Gerichte:** Pizza, Pasta, Burger, Kebab, Falafel, Sushi, Ramen, Poke, Bowls, Salate,
Suppen, Sandwiches, Wraps, Hot Dogs, Momos, Banh Mi, Tacos, Curry

**Präferenzen** (früher „Zusätze“): Vegan, Vegetarisch, Glutenfrei, Laktosefrei, Halal, Koscher, Bio, Regional,
Eigenes Geschirr willkommen, reCIRCLE, Mehrwegtopf, Mittagsmenü, Unter CHF 15, Mit Sitzplatz,
Vorbestellung möglich, Gesund, Proteinreich, Frisch

**Wartezeit** (genau eine Auswahl, in der Infobox als Info, filterbar):
Unter 5 Minuten, 5–15 Minuten, Über 15 Minuten

### Entscheid Besitzer (21.11.2026)

- Zusätze **nicht** aufteilen: eine Gruppe, umbenannt in **Präferenzen**.
- **Alle** Kandidaten aus dem Brainstorming übernommen, ebenfalls unter Präferenzen
  (Schreibweise mit Schrägstrich: „Nussfrei / allergikerfreundlich“, „Bier / Wein“ usw.):
  - Ernährung: Low Carb, Zuckerfrei, Nussfrei/allergikerfreundlich, artgerechte Haltung,
    nachhaltiger Fisch, Hausgemacht, Scharf, Kinderfreundliche Gerichte
  - Nachhaltigkeit: Saisonal, Zero Waste, Too Good To Go, Tagesreste vergünstigt, Elektrisch betrieben
  - Service: Online bestellen, Lieferung, Kartenzahlung, TWINT, Nur Bargeld, Grosse Portionen, Catering
  - Ort & Ambiente: Gedeckt/wettergeschützt, Draussen sitzen, Mit Aussicht, Rollstuhlgängig,
    Hunde willkommen, Kinderfreundlich, WC vorhanden, Gratis-Wasser, Ruhig, Treffpunkt
  - Preis & Angebot: Unter CHF 10, Studentenrabatt, Happy Hour, Kaffee, Bier/Wein, Smoothies,
    Dessert/Süsses, Frühstück

**Art des Lokals:** Food Truck, Imbiss, Marktstand, Take-away, Mensa, Personalrestaurant,
Bäckerei, Café, Deli, Metzgerei, Supermarkt, Food Court, Restaurant mit Take-away

## 2. Öffnungszeiten ✅ erledigt (0.0.004)

- Matrix: 7 Wochentage × **Morgen, Mittag, Abend** (keine Nacht).
- Neue Tabelle `tbl_place_opening` (place_id, weekday 0–6, slot `morning|noon|evening`),
  eine Zeile pro Kreuz.
- Die alten Spalten `open_monday` … `open_sunday`, `open_morning` … `open_night` fallen weg.
  Einmalige Übernahme: heutige Tage × Tageszeiten → Kreuze (Nacht entfällt).
- Admin: Matrix als Gitter zum Anklicken.
- Karte: Tages-Slider bleibt, dazu Schalter **Mittag / Abend** (Standard: Mittag).
  Morgen wird nur gespeichert und in der Infobox gezeigt, nicht gefiltert.
- Infobox: Öffnungszeiten als kleine Matrix.

## 3. Mehrere Standorte (Foodtrucks) ✅ erledigt (0.0.004)

- Checkbox **„Mehrere Standorte“** im Admin. Aus = ein Standort wie bisher (`tbl_place.lat/lng`).
- An = pro angekreuztem Wochentag eine eigene kleine Karte („Standort Montag“ …),
  mit Knopf „wie Montag“ zum Übernehmen, optional Bezeichnung (z.B. „Helvetiaplatz“).
- **Ein Standort pro Tag** (Mittag und Abend am gleichen Ort).
  Sonderfall zwei Orte am gleichen Tag → zweiter Eintrag.
- Neue Tabelle `tbl_place_location` (place_id, weekday, lat, lng, label).
  Leer = normaler Standort gilt; bestehende Orte bleiben unverändert.
- Karte: Truck erscheint am Standort des im Slider gewählten Tages.
  Infobox: „Mo Helvetiaplatz · Fr Bahnhof Altstetten“.

## 4. Datenbank-Umstellung live ⏳ vorbereitet, noch nicht ausgeführt

- Migrationsdatei: `data/migration-2026-11.sql`, Anleitung: `data/MIGRATION.md`.

- Eine SQL-Migrationsdatei: neue Tabellen, alle Kategorien, Übernahme der Öffnungszeiten.
- Vorher Sicherung (Export in phpMyAdmin), dann im phpMyAdmin beim Hoster ausführen.
  Anleitung Schritt für Schritt.

## 5. Sicherheit (GitGuardian-Meldung vom 21.11.2026) ✅ erledigt

- Passwort beim Hoster geändert, `config.php` auf dem Server angepasst,
  `api/config.example.php` enthält nur noch einen leeren Platzhalter.

- Das Live-DB-Passwort steht in alten Commits (`api/config.php` von 2024).
- Passwort beim Hoster ändern, danach sofort `config.php` auf dem Server anpassen,
  in GitGuardian als „Revoked“ markieren.
