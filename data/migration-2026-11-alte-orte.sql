-- =====================================================================
-- mampf: Die drei ältesten Orte (nur live, von 2024) auf Deutsch.
-- Ergänzt migration-2026-11-take-away.sql (Version 0.0.021).
--
-- Live: in phpMyAdmin die mampf-Datenbank anklicken, Reiter "SQL",
-- den Inhalt dieser Datei einfügen, "OK".
-- Darf auch zweimal laufen: geändert wird nur, wenn der alte Text noch da ist.
-- =====================================================================

SET NAMES utf8mb4;

UPDATE tbl_place SET description = 'Currys mit Reis'
  WHERE name = 'The Thai' AND description = 'Takeaway für Thai Curry';
UPDATE tbl_place SET description = 'Sushi to go, auch Platten zum Teilen'
  WHERE name = 'Tiny Fish' AND description = 'Tasty and inexpensive takeaway sushi';
UPDATE tbl_place SET description = 'Wechselnde Suppen und Bowls aus der Region'
  WHERE name = 'Simply Soup' AND description = 'Good and affordable soups';
