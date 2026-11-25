-- Test-Foodtruck mit einem anderen Standort pro Wochentag (rund um die Langstrasse).
-- Zum Ausprobieren der Funktion "Mehrere Standorte".
--
-- Braucht die neue Datenbank (data/MIGRATION.md, live schon umgestellt).
-- In phpMyAdmin: Reiter "SQL", alles einfügen, "OK". Nur einmal ausführen.
--
-- Der Truck gehört dem ersten Admin (oder, falls es keinen gibt, dem ersten User).
-- Achtung: Er ist für alle Besucher der Karte sichtbar.
--
-- Wieder entfernen (löscht auch Standorte, Öffnungszeiten und Kategorien):
--   DELETE FROM tbl_place_location WHERE place_id IN (SELECT id FROM tbl_place WHERE name = 'Test-Truck Wanderlust');
--   DELETE FROM tbl_place_opening  WHERE place_id IN (SELECT id FROM tbl_place WHERE name = 'Test-Truck Wanderlust');
--   DELETE FROM tbl_place_category WHERE place_id IN (SELECT id FROM tbl_place WHERE name = 'Test-Truck Wanderlust');
--   DELETE FROM tbl_place WHERE name = 'Test-Truck Wanderlust';

START TRANSACTION;

SET @user_id = (SELECT id FROM tbl_user ORDER BY admin DESC, id LIMIT 1);

INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, create_time)
VALUES (@user_id, NULL, 'Test-Truck Wanderlust', 'Testdaten: Foodtruck mit Standort pro Tag',
        47.37615, 8.52520, NOW());
SET @p = LAST_INSERT_ID();

-- weekday wie in JavaScript: 0 = Sonntag, 1 = Montag, ... 6 = Samstag
INSERT INTO tbl_place_location (place_id, weekday, lat, lng, label) VALUES
  (@p, 1, 47.37615, 8.52520, 'Helvetiaplatz'),
  (@p, 2, 47.37790, 8.52440, 'Bäckeranlage'),
  (@p, 3, 47.37510, 8.52310, 'Kanzleiareal'),
  (@p, 4, 47.37650, 8.52190, 'Ankerstrasse'),
  (@p, 5, 47.37800, 8.52780, 'Langstrasse'),
  (@p, 6, 47.37800, 8.53180, 'Kasernenareal'),
  (@p, 0, 47.37950, 8.52950, 'Lagerstrasse');

INSERT INTO tbl_place_opening (place_id, weekday, slot) VALUES
  (@p, 1, 'noon'), (@p, 2, 'noon'), (@p, 3, 'noon'), (@p, 4, 'noon'),
  (@p, 5, 'noon'), (@p, 5, 'evening'),
  (@p, 6, 'noon'), (@p, 6, 'evening'),
  (@p, 0, 'morning'), (@p, 0, 'noon');

INSERT INTO tbl_place_category (place_id, category_id)
SELECT @p, id FROM tbl_category
WHERE (gruppe = 'art' AND name = 'Food Truck')
   OR (gruppe = 'kueche' AND name = 'Mexikanisch')
   OR (gruppe = 'gericht' AND name = 'Tacos')
   OR (gruppe = 'praeferenz' AND name = 'Vegetarisch')
   OR (gruppe = 'wartezeit' AND name = 'Unter 5 Min');

COMMIT;
