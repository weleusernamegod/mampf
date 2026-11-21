# Datenbank-Umstellung live (November 2026)

Diese Anleitung stellt die Live-Datenbank auf die neue Version um:
Öffnungszeiten als Matrix und mehrere Standorte für Foodtrucks.
Die Änderungen stehen in der Datei `data/migration-2026-11.sql`.

**Wichtig:** Die neue Website-Version und die neue Datenbank gehören zusammen.
Die alte Website funktioniert mit der neuen Datenbank nicht mehr, und umgekehrt.
Darum Schritt 4 und 5 direkt nacheinander machen. Dazwischen zeigt die
Karte ein paar Minuten lang keine Orte. Das ist normal.

---

## 1. Sicherung machen (nicht überspringen!)

1. Beim Hoster einloggen und **phpMyAdmin** öffnen.
2. Links die Datenbank von mampf anklicken.
3. Oben auf **Exportieren** klicken.
4. Methode „Schnell“, Format „SQL“ lassen, auf **Exportieren** klicken.
5. Die heruntergeladene Datei gut aufbewahren, z.B. als
   `mampf-sicherung-2026-11-XX.sql` auf dem Laptop.
   Sie enthält alle Daten von mampf. **Nicht ins Git legen** (das Repo ist öffentlich).

## 2. Prüfen, ob der Kreis-4-Import schon gemacht ist

Die Datei `data/import-kreis4.sql` funktioniert nur mit der **alten** Datenbank.
Falls die 29 Orte aus Kreis 4 live noch fehlen, den Import **jetzt** machen,
also vor der Umstellung (in phpMyAdmin: Reiter **SQL**, Inhalt der Datei
einfügen, **OK**). Wenn die Orte schon da sind, diesen Schritt überspringen.

## 3. Kurz nachschauen, ob etwas verloren gehen würde

„Nachts“ gibt es nach der Umstellung nicht mehr. Ein Ort, der **nur** nachts
offen ist, hätte danach keine Öffnungszeiten mehr. Im Reiter **SQL** ausführen:

```sql
SELECT id, name FROM tbl_place
WHERE open_night = 1 AND open_morning = 0 AND open_noon = 0 AND open_evening = 0;
```

- Keine Zeilen: alles gut, weiter mit Schritt 4.
- Es kommen Zeilen: Namen notieren. Diese Orte nach der Umstellung im
  Admin-Bereich von Hand mit Öffnungszeiten versehen.

## 4. Umstellung ausführen

1. In phpMyAdmin links die Datenbank von mampf anklicken.
2. Oben auf **Importieren** klicken.
3. Bei „Datei auswählen“ die Datei `data/migration-2026-11.sql` wählen.
4. Unten auf **Importieren** klicken.
5. Es sollte eine grüne Meldung kommen („Import wurde erfolgreich abgeschlossen“).

**Nur einmal ausführen!** Ein zweites Mal gibt eine Fehlermeldung
(z.B. „Table already exists“). Das macht nichts kaputt, ist aber unnötig.

## 5. Neue Website hochladen

Gleich danach den neuen Inhalt von `dist/` auf den Server laden
(bisher mit Cyberduck). Die `config.php` auf dem Server dabei **nicht**
überschreiben und nicht löschen.

## 6. Kontrolle

Im Reiter **SQL**:

```sql
-- So viele Kreuze gibt es jetzt (sollte deutlich mehr als 0 sein)
SELECT COUNT(*) FROM tbl_place_opening;

-- Orte ohne Öffnungszeiten (sollte leer sein, ausser den Orten aus Schritt 3)
SELECT p.id, p.name FROM tbl_place p
LEFT JOIN tbl_place_opening o ON o.place_id = p.id
WHERE o.place_id IS NULL;
```

Dann https://mampf.io öffnen:
- Erscheinen die Orte? Mit dem Tages-Slider und dem Schalter Mittag/Abend
  ändern sich die grünen Punkte?
- Einen Ort antippen und aufklappen: Ist die Öffnungszeiten-Matrix richtig?
- Im Admin-Bereich einen Ort öffnen, Öffnungszeiten ändern, speichern.

## Falls etwas schiefgeht

1. In phpMyAdmin alle Tabellen der mampf-Datenbank auswählen und löschen
   (Reiter **Struktur**, „Alle auswählen“, „Löschen“). Im Bestätigungsfenster
   das Häkchen bei „Fremdschlüsselüberprüfung aktivieren“ wegnehmen,
   sonst lassen sich nicht alle Tabellen löschen.
2. Reiter **Importieren**, die Sicherung aus Schritt 1 wählen, **Importieren**.
3. Die alte Website-Version wieder hochladen.

Danach ist alles wieder wie vorher.
