-- =====================================================================
-- mampf: "Art des Lokals" überarbeitet (Version 0.0.011)
-- Neue Namen, neue Reihenfolge (nach Relevanz), Deli und Personalrestaurant weg.
--
-- Live: in phpMyAdmin die mampf-Datenbank anklicken, Reiter "SQL",
-- den Inhalt dieser Datei einfügen, "OK". Vorher eine Sicherung machen
-- (siehe data/MIGRATION.md, Schritt 1).
--
-- Darf auch zweimal laufen: beim zweiten Mal passiert einfach nichts mehr.
-- Umbenennen statt neu anlegen, damit die Zuordnungen der Orte bleiben.
-- =====================================================================

SET NAMES utf8mb4;

UPDATE tbl_category SET name = 'Take-away-Stand' WHERE gruppe = 'art' AND name = 'Take-away';
UPDATE tbl_category SET name = 'Imbiss-Stand'    WHERE gruppe = 'art' AND name = 'Imbiss';
-- Markthalle ersetzt Food Court
UPDATE tbl_category SET name = 'Markthalle'      WHERE gruppe = 'art' AND name = 'Food Court';

UPDATE tbl_category SET reihenfolge = CASE name
    WHEN 'Take-away-Stand'          THEN 10
    WHEN 'Restaurant mit Take-away' THEN 20
    WHEN 'Imbiss-Stand'             THEN 30
    WHEN 'Markthalle'               THEN 40
    WHEN 'Food Truck'               THEN 50
    WHEN 'Marktstand'               THEN 60
    WHEN 'Bäckerei'                 THEN 70
    WHEN 'Café'                     THEN 80
    WHEN 'Mensa'                    THEN 90
    WHEN 'Metzgerei'                THEN 100
    WHEN 'Supermarkt'               THEN 110
    ELSE reihenfolge
  END
WHERE gruppe = 'art';

-- Zuordnungen zu diesen Kategorien werden automatisch mitgelöscht (ON DELETE CASCADE).
DELETE FROM tbl_category WHERE gruppe = 'art' AND name IN ('Deli', 'Personalrestaurant');
