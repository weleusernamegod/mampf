-- =====================================================================
-- mampf: Zu lange Beschreibungen kürzen (höchstens 50 Zeichen, wie im
-- Admin-Formular). Sonst lassen sich diese Orte im Admin nicht speichern.
-- Ändert nur Orte, deren Beschreibung noch länger als 50 Zeichen ist.
-- Live: phpMyAdmin, Reiter "SQL", Inhalt einfügen, "OK".
-- =====================================================================

SET NAMES utf8mb4;

UPDATE tbl_place SET description = 'Food Hall am HB: Banh Mi, Japanisch, Grill, Pasta' WHERE name = 'Bridge' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Vegetarisches Buffet, auch zum Mitnehmen' WHERE name = 'Hiltl Sihlpost' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Mensa an der Europaallee, wechselnde Menüs' WHERE name = 'SV Mensa' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Familienbetrieb an der Schmiede Wiedikon, Piadina' WHERE name = 'Famiglia Tremonte' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Mediterranes Bistro, Lieferung, bis spät offen' WHERE name = 'Bilo Bistro' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Malaysische Currys, bekannt für Rendang' WHERE name = 'Charlie''s Take Away' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Smash-Burger und frische Pommes, ohne Sitzplätze' WHERE name = 'Huncho' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Pizza-Slices, Zugang per Lift bei Hungry Duck' WHERE name = 'Kanton Slice' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Tibetische Momos, auch Curry und Bowls' WHERE name = 'Roots of Himalaya' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Grosszügige, frisch belegte Sandwiches' WHERE name = 'Rosita''s' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Drei frische Suppen täglich mit Brot und Frucht' WHERE name = 'Suppelade' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Veganes Fast Food: Pitas und Burger' WHERE name = 'Veganitas' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Kebab, Köfte, auch vegetarisch und vegan' WHERE name = 'Ada Lokma' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Döner, Lahmacun, Adana-Kebab, bis spät offen' WHERE name = 'Best Kebab' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Venezolanische Arepas, auch vegan' WHERE name = 'El Turpial' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Mexikanische Tacos und Burritos zum Mitnehmen' WHERE name = 'Frida' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Panini-Institution an der Josefstrasse' WHERE name = 'Il Pentagramma' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Food Hall: Sushi, Wok, Burger, Korean Chicken' WHERE name = 'Kitchen Republic' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Scharfe tamilische Currys mit Reis, auch vegan' WHERE name = 'Loving Lanka' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Mensa ZHdK/ZHAW: Menüs, Suppe, Salatbuffet' WHERE name = 'Mensa Molki (Toni-Areal)' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Täglich rund zehn frische Thai-Gerichte' WHERE name = 'Spoon' AND CHAR_LENGTH(description) > 50;
UPDATE tbl_place SET description = 'Foodtruck der Momo-Kette Tenz' WHERE name = 'Tenz Momo Foodtruck' AND CHAR_LENGTH(description) > 50;

-- Kontrolle: sollte keine Zeilen mehr liefern
SELECT id, name, description FROM tbl_place WHERE CHAR_LENGTH(description) > 50;
