# Erzeugt aus einer Kandidaten-CSV eine SQL-Datei für phpMyAdmin.
# Übernommen werden nur Zeilen mit vorschlag = "ja".
# Aufruf: python3 data/csv-zu-sql.py data/kandidaten-kreis4.csv data/import-kreis4.sql
import csv, sys

def q(s):
    return "'" + s.replace("\\", "\\\\").replace("'", "''") + "'"

src, out = sys.argv[1], sys.argv[2]
rows = [r for r in csv.DictReader(open(src, encoding='utf-8')) if r['vorschlag'].strip() == 'ja']
lines = [
    f"-- Import aus {src}: {len(rows)} Orte",
    "-- Quelle: OpenStreetMap (© OpenStreetMap-Mitwirkende, ODbL)",
    "-- Besitzer der Einträge: @user_id (live = 2). Orte, die schon existieren",
    "-- (gleicher Name, fast gleiche Position), werden übersprungen.",
    "SET NAMES utf8mb4;",
    "SET @user_id = 2;",
    "",
]
cols = "user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time"
for r in rows:
    b = lambda k: str(int(r[k] or 0))
    vals = ", ".join(["@user_id", "NULL", q(r['name']), q(r['beschreibung'][:255]), r['lat'], r['lng'],
        b('mo'), b('tu'), b('we'), b('th'), b('fr'), b('sa'), b('su'),
        b('morgen'), b('mittag'), b('abend'), b('nacht'), "NOW()"])
    lines.append(f"INSERT INTO tbl_place ({cols})\n  SELECT {vals}\n  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = {q(r['name'])} AND ABS(lat - {r['lat']}) < 0.0005 AND ABS(lng - {r['lng']}) < 0.0005);")
open(out, 'w', encoding='utf-8').write("\n".join(lines) + "\n")
print(f"{len(rows)} Orte -> {out}")
