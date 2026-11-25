# Erzeugt aus orte-kreis4-5.csv eine SQL-Datei für phpMyAdmin (aktuelles Schema mit
# Öffnungszeiten-Matrix, Kategorien und Preisen).
#  - Neue Orte: nur Zeilen mit vorschlag = "ja", die noch nicht in mampf sind.
#  - Bestehende Orte (gleicher Name, fast gleiche Position): nur Preis setzen, falls leer.
# Aufruf: python3 data/kreis4-5/csv-zu-sql.py data/kreis4-5/orte-kreis4-5.csv data/kreis4-5/import-kreis4-5.sql
import csv, sys

def q(s):
    return "'" + str(s).replace("\\", "\\\\").replace("'", "''") + "'"

src, out = sys.argv[1], sys.argv[2]
rows = [r for r in csv.DictReader(open(src, encoding="utf-8")) if r["vorschlag"] == "ja" and r["lat"] and r["lng"]]
TAGE = [("so", 0), ("mo", 1), ("di", 2), ("mi", 3), ("do", 4), ("fr", 5), ("sa", 6)]
SLOTS = [("morgen", "morning"), ("mittag", "noon"), ("abend", "evening")]
GRUPPEN = [("art", "art"), ("kueche", "kueche"), ("gerichte", "gericht"), ("praeferenzen", "praeferenz")]
L = [
    "-- =====================================================================",
    f"-- mampf: Import Kreis 4 und 5 aus {src.split('/')[-1]}",
    "-- Quellen: OpenStreetMap (© OpenStreetMap-Mitwirkende, ODbL), Websuche, Websites der Orte.",
    "-- Preise sind Schätzungen (siehe Spalte preis_quelle in der CSV).",
    "--",
    "-- Live: in phpMyAdmin die mampf-Datenbank anklicken, Reiter \"Importieren\",",
    "-- diese Datei hochladen, \"OK\". Vorher eine Sicherung machen (data/MIGRATION.md, Schritt 1).",
    "-- Darf auch zweimal laufen: Orte, die es schon gibt (gleicher Name, fast gleiche",
    "-- Position), werden übersprungen. Braucht migration-2026-11-kategorien.sql.",
    "-- =====================================================================",
    "",
    "SET NAMES utf8mb4;",
    "START TRANSACTION;",
    "-- Besitzer der neuen Orte: der Admin (live = Yves)",
    "SET @user_id = (SELECT id FROM tbl_user ORDER BY admin DESC, id LIMIT 1);",
    "",
]
neu = upd = 0
for r in rows:
    name, lat, lng = r["name"], float(r["lat"]), float(r["lng"])
    # gleicher Name in der Nähe, oder gleiches erstes Wort sehr nah (z.B. "Simply Soup" = "Simply Soup Kalkbreite")
    erstes = name.split(" ")[0].replace("%", "").replace("_", "")
    near = (f"((name = {q(name)} AND ABS(lat - {lat}) < 0.002 AND ABS(lng - {lng}) < 0.002)"
            f" OR (name LIKE {q(erstes + '%')} AND ABS(lat - {lat}) < 0.0006 AND ABS(lng - {lng}) < 0.0008))")
    pmin = r["preis_min"] or "NULL"; pmax = r["preis_max"] or "NULL"
    if pmin != "NULL":  # Ort gibt es schon, hat aber keinen Preis: Preis ergänzen
        L.append(f"UPDATE tbl_place SET price_min = {pmin}, price_max = {pmax} WHERE {near} AND price_min IS NULL;")
        upd += 1
    desc = r["beschreibung"] or ", ".join(x for x in [r["art"], r["kueche"].replace("; ", ", ")] if x)
    if len(desc) > 50:  # Admin-Formular erlaubt höchstens 50 Zeichen
        desc = desc[:49].rsplit(" ", 1)[0].rstrip(",;:") + "…"
    L.append(f"-- {r['nr']}: {name} ({r['adresse']})")
    L.append(f"SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE {near});")
    L.append("INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)\n"
             f"  SELECT @user_id, NULL, {q(name)}, {q(desc)}, {lat}, {lng}, {pmin}, {pmax}, NOW() FROM DUAL WHERE @neu;")
    L.append("SET @p = IF(@neu, LAST_INSERT_ID(), NULL);")
    zeiten = [f"SELECT {w} w, '{s}' s" for t, w in TAGE if r[t] == "1" for c, s in SLOTS if r[c] == "1"]
    if zeiten:
        L.append("INSERT INTO tbl_place_opening (place_id, weekday, slot)\n"
                 f"  SELECT @p, w, s FROM ({' UNION ALL '.join(zeiten)}) t WHERE @p IS NOT NULL;")
    kat = []
    for col, g in GRUPPEN:
        for v in [x.strip() for x in r[col].split(";") if x.strip()]:
            kat.append(f"(gruppe = {q(g)} AND name = {q(v)})")
    if kat:
        L.append("INSERT IGNORE INTO tbl_place_category (place_id, category_id)\n"
                 f"  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ({' OR '.join(kat)});")
    L.append("")
    neu += 1
L += ["COMMIT;", ""]
open(out, "w", encoding="utf-8").write("\n".join(L))
print(f"{neu} Orte (neu oder Preis ergänzt), {upd} mit Preis -> {out}")
