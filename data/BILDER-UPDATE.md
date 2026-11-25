# Umstellung: Bilder als Dateien (Version 0.0.017)

Ab dieser Version liegen die Bilder der Orte als Dateien im Ordner
`/bilder/orte/` auf dem Webserver. In der Datenbank steht pro Ort nur noch
der Dateiname (`tbl_place.picture_file`). Neue Bilder, die Benutzer im
Admin-Bereich hochladen, landen automatisch dort.

Im Ordner `/bilder/orte/` auf dem Server liegen ab jetzt Bilder, die es nur
dort gibt (nicht im Git). Das automatische Deployment lässt sie in Ruhe
(siehe `exclude` in `.github/workflows/deploy.yml`). Bei einem Upload von Hand
mit Cyberduck den Ordner nie löschen und nicht „Synchronisieren/Spiegeln“.

**Reihenfolge einhalten:** Die neue API liest die Spalte `picture_file`.
Darum zuerst die Datenbank anpassen, erst dann pushen (der Push lädt die
neue Website automatisch hoch).

## 1. Sicherung machen

Wie in `data/MIGRATION.md`, Schritt 1 (phpMyAdmin → Exportieren).

## 2. Datenbank anpassen (phpMyAdmin, Reiter „SQL“), VOR dem Push

1. Inhalt von `data/migration-2026-11-bilddateien.sql` einfügen, „OK“.
   (Neue Spalte `picture_file`. Die alte Website läuft damit weiter.)
2. Inhalt von `data/migration-2026-11-beschreibungen.sql` einfügen, „OK“.
   (Kürzt Beschreibungen auf höchstens 50 Zeichen, sonst lassen sich diese
   Orte im Admin nicht speichern.)

## 3. Pushen

Der Push auf `main` baut die Website und lädt sie hoch (GitHub Actions,
dauert ein paar Minuten). Dabei entsteht auch der Ordner `/bilder/orte/`
mit seiner `.htaccess`.

## 4. Logos aus der Recherche hochladen (Cyberduck)

1. Alle Dateien aus `data/kreis4-5/bilder-fuer-server/orte/` (nur lokal, nicht
   im Git) in den Server-Ordner `/bilder/orte/` hochladen.
2. In phpMyAdmin den Inhalt von `data/kreis4-5/bilder-zuordnen.sql` ausführen.
   (Ordnet die Logos den Orten zu, nur wo noch kein Bild ist.)

## 5. Alte Bilder umziehen und Namen vereinheitlichen

Als Admin auf mampf.io anmelden und dann diese Adresse öffnen:

    https://mampf.io/api/admin-bilder-umziehen.php

Das Skript macht die alten Bilder aus der Datenbank (`tbl_picture`) zu Dateien
und benennt alle Bilddateien einheitlich um:
`<Ort-ID>-<name>-<6 Zufallszeichen>.<endung>`, z.B. `112-banh-mi-136-a3f9c2.jpg`
(so heissen auch neu hochgeladene Bilder). Es zeigt eine Liste („umgezogen“,
„umbenannt“, „unbenutzt“). Unbenutzte Dateien gehören zu keinem Ort und
können in Cyberduck gelöscht werden. Darf mehrmals aufgerufen werden.

## 6. Testen

1. mampf.io neu laden, einen Ort mit Logo antippen: das Logo erscheint im Kreis.
2. Im Admin bei einem eigenen Ort ein Bild hochladen und speichern.
   Klappt das nicht (Fehler beim Speichern), darf PHP nicht in den Ordner
   schreiben: in Cyberduck Rechtsklick auf `/bilder/orte` → „Info“ →
   Berechtigungen auf 755 setzen (oder beim Hoster nachfragen).
