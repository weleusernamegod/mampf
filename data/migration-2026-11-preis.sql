-- Migration Nov. 2026 (Version 0.0.013):
--  1. Wartezeit kürzer ("Min" statt "Minuten"), damit alles auf eine Zeile passt
--  2. Preisspanne pro Ort in CHF (price_min / price_max, 10–30, leer = unbekannt)
-- Einmal auf der Datenbank ausführen (lokal und live, z.B. in phpMyAdmin).

SET NAMES utf8mb4;
START TRANSACTION;

UPDATE tbl_category SET name = 'Unter 5 Min' WHERE gruppe = 'wartezeit' AND name = 'Unter 5 Minuten';
UPDATE tbl_category SET name = '5–15 Min'    WHERE gruppe = 'wartezeit' AND name = '5–15 Minuten';
UPDATE tbl_category SET name = 'Über 15 Min' WHERE gruppe = 'wartezeit' AND name = 'Über 15 Minuten';


COMMIT;

ALTER TABLE `tbl_place`
  ADD COLUMN `price_min` tinyint(4) DEFAULT NULL AFTER `lng`,
  ADD COLUMN `price_max` tinyint(4) DEFAULT NULL AFTER `price_min`;
