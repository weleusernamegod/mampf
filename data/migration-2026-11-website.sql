-- Migration Nov. 2026 (Version 0.0.024):
--  Link zur Website oder zum Menü pro Ort (leer = keiner).
-- Einmal auf der Datenbank ausführen (lokal und live, z.B. in phpMyAdmin),
-- und zwar BEVOR die neue Version live geht.

ALTER TABLE `tbl_place`
  ADD COLUMN `website` varchar(255) DEFAULT NULL COMMENT 'Link zur Website oder zum Menü, leer = keiner' AFTER `price_max`;
