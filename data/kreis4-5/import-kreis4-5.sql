-- =====================================================================
-- mampf: Import Kreis 4 und 5 aus orte-kreis4-5.csv
-- Quellen: OpenStreetMap (© OpenStreetMap-Mitwirkende, ODbL), Websuche, Websites der Orte.
-- Preise sind Schätzungen (siehe Spalte preis_quelle in der CSV).
--
-- Live: in phpMyAdmin die mampf-Datenbank anklicken, Reiter "Importieren",
-- diese Datei hochladen, "OK". Vorher eine Sicherung machen (data/MIGRATION.md, Schritt 1).
-- Darf auch zweimal laufen: Orte, die es schon gibt (gleicher Name, fast gleiche
-- Position), werden übersprungen. Braucht migration-2026-11-kategorien.sql.
-- =====================================================================

SET NAMES utf8mb4;
START TRANSACTION;
-- Besitzer der neuen Orte: der Admin (live = Yves)
SET @user_id = (SELECT id FROM tbl_user ORDER BY admin DESC, id LIMIT 1);

UPDATE tbl_place SET price_min = 10, price_max = 15 WHERE ((name = 'Famiglia Tremonte' AND ABS(lat - 47.3699) < 0.002 AND ABS(lng - 8.518) < 0.002) OR (name LIKE 'Famiglia%' AND ABS(lat - 47.3699) < 0.0006 AND ABS(lng - 8.518) < 0.0008)) AND price_min IS NULL;
-- 1: Famiglia Tremonte (Birmensdorferstrasse 129, 8003 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Famiglia Tremonte' AND ABS(lat - 47.3699) < 0.002 AND ABS(lng - 8.518) < 0.002) OR (name LIKE 'Famiglia%' AND ABS(lat - 47.3699) < 0.0006 AND ABS(lng - 8.518) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Famiglia Tremonte', 'Familienbetrieb an der Schmiede Wiedikon, Piadina', 47.3699, 8.518, 10, 15, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Take-away-Stand') OR (gruppe = 'kueche' AND name = 'Italienisch') OR (gruppe = 'gericht' AND name = 'Piadina') OR (gruppe = 'gericht' AND name = 'Pasta') OR (gruppe = 'gericht' AND name = 'Sandwiches') OR (gruppe = 'gericht' AND name = 'Focaccia') OR (gruppe = 'praeferenz' AND name = 'Hausgemacht') OR (gruppe = 'praeferenz' AND name = 'Mittagsmenü'));

UPDATE tbl_place SET price_min = 19, price_max = 26 WHERE ((name = 'Addis Ababa' AND ABS(lat - 47.3728883) < 0.002 AND ABS(lng - 8.5280453) < 0.002) OR (name LIKE 'Addis%' AND ABS(lat - 47.3728883) < 0.0006 AND ABS(lng - 8.5280453) < 0.0008)) AND price_min IS NULL;
-- 2: Addis Ababa (Strassburgstrasse 17, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Addis Ababa' AND ABS(lat - 47.3728883) < 0.002 AND ABS(lng - 8.5280453) < 0.002) OR (name LIKE 'Addis%' AND ABS(lat - 47.3728883) < 0.0006 AND ABS(lng - 8.5280453) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Addis Ababa', 'Imbiss-Stand, Äthiopisch', 47.3728883, 8.5280453, 19, 26, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Äthiopisch'));

UPDATE tbl_place SET price_min = 12, price_max = 17 WHERE ((name = 'Allegrotto' AND ABS(lat - 47.3776837) < 0.002 AND ABS(lng - 8.5264) < 0.002) OR (name LIKE 'Allegrotto%' AND ABS(lat - 47.3776837) < 0.0006 AND ABS(lng - 8.5264) < 0.0008)) AND price_min IS NULL;
-- 3: Allegrotto (Langstrasse 81, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Allegrotto' AND ABS(lat - 47.3776837) < 0.002 AND ABS(lng - 8.5264) < 0.002) OR (name LIKE 'Allegrotto%' AND ABS(lat - 47.3776837) < 0.0006 AND ABS(lng - 8.5264) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Allegrotto', 'Imbiss-Stand, Amerikanisch, Indisch…', 47.3776837, 8.5264, 12, 17, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'morning' s UNION ALL SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'morning' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Amerikanisch') OR (gruppe = 'kueche' AND name = 'Indisch') OR (gruppe = 'kueche' AND name = 'Italienisch') OR (gruppe = 'kueche' AND name = 'Sri Lankisch') OR (gruppe = 'kueche' AND name = 'Türkisch') OR (gruppe = 'gericht' AND name = 'Burger') OR (gruppe = 'gericht' AND name = 'Kebab') OR (gruppe = 'gericht' AND name = 'Pizza') OR (gruppe = 'gericht' AND name = 'Poulet / Fried Chicken') OR (gruppe = 'gericht' AND name = 'Salate') OR (gruppe = 'praeferenz' AND name = 'Lieferung'));

UPDATE tbl_place SET price_min = 11, price_max = 15 WHERE ((name = 'Banh Mi 136' AND ABS(lat - 47.378255) < 0.002 AND ABS(lng - 8.528575) < 0.002) OR (name LIKE 'Banh%' AND ABS(lat - 47.378255) < 0.0006 AND ABS(lng - 8.528575) < 0.0008)) AND price_min IS NULL;
-- 4: Banh Mi 136 (Tellstrasse 10, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Banh Mi 136' AND ABS(lat - 47.378255) < 0.002 AND ABS(lng - 8.528575) < 0.002) OR (name LIKE 'Banh%' AND ABS(lat - 47.378255) < 0.0006 AND ABS(lng - 8.528575) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Banh Mi 136', 'Vietnamesische Banh Mi', 47.378255, 8.528575, 11, 15, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Take-away-Stand') OR (gruppe = 'kueche' AND name = 'Vietnamesisch') OR (gruppe = 'gericht' AND name = 'Banh Mi'));

UPDATE tbl_place SET price_min = 10, price_max = 15 WHERE ((name = 'Banh Mi 136 @ bridge' AND ABS(lat - 47.3788434) < 0.002 AND ABS(lng - 8.5341553) < 0.002) OR (name LIKE 'Banh%' AND ABS(lat - 47.3788434) < 0.0006 AND ABS(lng - 8.5341553) < 0.0008)) AND price_min IS NULL;
-- 5: Banh Mi 136 @ bridge (Robert-Stephenson-Weg, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Banh Mi 136 @ bridge' AND ABS(lat - 47.3788434) < 0.002 AND ABS(lng - 8.5341553) < 0.002) OR (name LIKE 'Banh%' AND ABS(lat - 47.3788434) < 0.0006 AND ABS(lng - 8.5341553) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Banh Mi 136 @ bridge', 'menu: https://menu.tablesnappr.com/bridgezurich/#/', 47.3788434, 8.5341553, 10, 15, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'gericht' AND name = 'Sandwiches') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen'));

UPDATE tbl_place SET price_min = 16, price_max = 23 WHERE ((name = 'Bilo Bistro' AND ABS(lat - 47.3764202) < 0.002 AND ABS(lng - 8.5283268) < 0.002) OR (name LIKE 'Bilo%' AND ABS(lat - 47.3764202) < 0.0006 AND ABS(lng - 8.5283268) < 0.0008)) AND price_min IS NULL;
-- 6: Bilo Bistro (Ankerstrasse 116, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Bilo Bistro' AND ABS(lat - 47.3764202) < 0.002 AND ABS(lng - 8.5283268) < 0.002) OR (name LIKE 'Bilo%' AND ABS(lat - 47.3764202) < 0.0006 AND ABS(lng - 8.5283268) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Bilo Bistro', 'Mediterranes Bistro, Lieferung, bis spät offen', 47.3764202, 8.5283268, 16, 23, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Mediterran') OR (gruppe = 'praeferenz' AND name = 'Lieferung'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'Bistro ALADIN' AND ABS(lat - 47.3782181) < 0.002 AND ABS(lng - 8.5267329) < 0.002) OR (name LIKE 'Bistro%' AND ABS(lat - 47.3782181) < 0.0006 AND ABS(lng - 8.5267329) < 0.0008)) AND price_min IS NULL;
-- 7: Bistro ALADIN (Langstrasse, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Bistro ALADIN' AND ABS(lat - 47.3782181) < 0.002 AND ABS(lng - 8.5267329) < 0.002) OR (name LIKE 'Bistro%' AND ABS(lat - 47.3782181) < 0.0006 AND ABS(lng - 8.5267329) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Bistro ALADIN', 'Imbiss-Stand', 47.3782181, 8.5267329, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand'));

UPDATE tbl_place SET price_min = 16, price_max = 25 WHERE ((name = 'Bridge' AND ABS(lat - 47.3788455) < 0.002 AND ABS(lng - 8.5338299) < 0.002) OR (name LIKE 'Bridge%' AND ABS(lat - 47.3788455) < 0.0006 AND ABS(lng - 8.5338299) < 0.0008)) AND price_min IS NULL;
-- 8: Bridge (Eisgasse 20, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Bridge' AND ABS(lat - 47.3788455) < 0.002 AND ABS(lng - 8.5338299) < 0.002) OR (name LIKE 'Bridge%' AND ABS(lat - 47.3788455) < 0.0006 AND ABS(lng - 8.5338299) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Bridge', 'Markthalle', 47.3788455, 8.5338299, 16, 25, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'morning' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Markthalle') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'Cartel - Crazy Burrito Shack' AND ABS(lat - 47.3764035) < 0.002 AND ABS(lng - 8.5332122) < 0.002) OR (name LIKE 'Cartel%' AND ABS(lat - 47.3764035) < 0.0006 AND ABS(lng - 8.5332122) < 0.0008)) AND price_min IS NULL;
-- 9: Cartel - Crazy Burrito Shack (Militärstrasse 14, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Cartel - Crazy Burrito Shack' AND ABS(lat - 47.3764035) < 0.002 AND ABS(lng - 8.5332122) < 0.002) OR (name LIKE 'Cartel%' AND ABS(lat - 47.3764035) < 0.0006 AND ABS(lng - 8.5332122) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Cartel - Crazy Burrito Shack', 'Imbiss-Stand', 47.3764035, 8.5332122, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'praeferenz' AND name = 'Vegan') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch'));

UPDATE tbl_place SET price_min = 17, price_max = 25 WHERE ((name = 'Centro Pizza' AND ABS(lat - 47.3765089) < 0.002 AND ABS(lng - 8.5146024) < 0.002) OR (name LIKE 'Centro%' AND ABS(lat - 47.3765089) < 0.0006 AND ABS(lng - 8.5146024) < 0.0008)) AND price_min IS NULL;
-- 10: Centro Pizza (Badenerstrasse 276, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Centro Pizza' AND ABS(lat - 47.3765089) < 0.002 AND ABS(lng - 8.5146024) < 0.002) OR (name LIKE 'Centro%' AND ABS(lat - 47.3765089) < 0.0006 AND ABS(lng - 8.5146024) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Centro Pizza', 'Imbiss-Stand, Italienisch', 47.3765089, 8.5146024, 17, 25, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Italienisch') OR (gruppe = 'gericht' AND name = 'Pizza'));

UPDATE tbl_place SET price_min = 17, price_max = 24 WHERE ((name = 'Charlie''s Take Away' AND ABS(lat - 47.3726372) < 0.002 AND ABS(lng - 8.5277578) < 0.002) OR (name LIKE 'Charlie''s%' AND ABS(lat - 47.3726372) < 0.0006 AND ABS(lng - 8.5277578) < 0.0008)) AND price_min IS NULL;
-- 11: Charlie's Take Away (Werdstrasse 60, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Charlie''s Take Away' AND ABS(lat - 47.3726372) < 0.002 AND ABS(lng - 8.5277578) < 0.002) OR (name LIKE 'Charlie''s%' AND ABS(lat - 47.3726372) < 0.0006 AND ABS(lng - 8.5277578) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Charlie''s Take Away', 'Malaysische Currys, bekannt für Rendang', 47.3726372, 8.5277578, 17, 24, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Take-away-Stand') OR (gruppe = 'kueche' AND name = 'Malaysisch') OR (gruppe = 'gericht' AND name = 'Curry') OR (gruppe = 'gericht' AND name = 'Rendang'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'Cheesecake Love' AND ABS(lat - 47.3764926) < 0.002 AND ABS(lng - 8.5331162) < 0.002) OR (name LIKE 'Cheesecake%' AND ABS(lat - 47.3764926) < 0.0006 AND ABS(lng - 8.5331162) < 0.0008)) AND price_min IS NULL;
-- 12: Cheesecake Love (Militärstrasse 16, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Cheesecake Love' AND ABS(lat - 47.3764926) < 0.002 AND ABS(lng - 8.5331162) < 0.002) OR (name LIKE 'Cheesecake%' AND ABS(lat - 47.3764926) < 0.0006 AND ABS(lng - 8.5331162) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Cheesecake Love', 'Imbiss-Stand', 47.3764926, 8.5331162, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 6 w, 'morning' s UNION ALL SELECT 6 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'Da Antonietta' AND ABS(lat - 47.3708157) < 0.002 AND ABS(lng - 8.5278481) < 0.002) OR (name LIKE 'Da%' AND ABS(lat - 47.3708157) < 0.0006 AND ABS(lng - 8.5278481) < 0.0008)) AND price_min IS NULL;
-- 13: Da Antonietta (Hallwylstrasse 56, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Da Antonietta' AND ABS(lat - 47.3708157) < 0.002 AND ABS(lng - 8.5278481) < 0.002) OR (name LIKE 'Da%' AND ABS(lat - 47.3708157) < 0.0006 AND ABS(lng - 8.5278481) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Da Antonietta', 'Imbiss-Stand', 47.3708157, 8.5278481, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand'));

UPDATE tbl_place SET price_min = 15, price_max = 26 WHERE ((name = 'Delhi House' AND ABS(lat - 47.3774466) < 0.002 AND ABS(lng - 8.5131703) < 0.002) OR (name LIKE 'Delhi%' AND ABS(lat - 47.3774466) < 0.0006 AND ABS(lng - 8.5131703) < 0.0008)) AND price_min IS NULL;
-- 14: Delhi House (Zypressenstrasse 52, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Delhi House' AND ABS(lat - 47.3774466) < 0.002 AND ABS(lng - 8.5131703) < 0.002) OR (name LIKE 'Delhi%' AND ABS(lat - 47.3774466) < 0.0006 AND ABS(lng - 8.5131703) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Delhi House', 'Imbiss-Stand, Indisch', 47.3774466, 8.5131703, 15, 26, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Indisch'));

UPDATE tbl_place SET price_min = 17, price_max = 24 WHERE ((name = 'Delhi-Bistro' AND ABS(lat - 47.3773927) < 0.002 AND ABS(lng - 8.513108) < 0.002) OR (name LIKE 'Delhi-Bistro%' AND ABS(lat - 47.3773927) < 0.0006 AND ABS(lng - 8.513108) < 0.0008)) AND price_min IS NULL;
-- 15: Delhi-Bistro (Zypressenstrasse 50, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Delhi-Bistro' AND ABS(lat - 47.3773927) < 0.002 AND ABS(lng - 8.513108) < 0.002) OR (name LIKE 'Delhi-Bistro%' AND ABS(lat - 47.3773927) < 0.0006 AND ABS(lng - 8.513108) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Delhi-Bistro', 'Indisches Bistro mit Buffet, sehr vegan-freundlich', 47.3773927, 8.513108, 17, 24, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Indisch') OR (gruppe = 'gericht' AND name = 'Curry') OR (gruppe = 'praeferenz' AND name = 'Vegan') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch'));

UPDATE tbl_place SET price_min = 12, price_max = 17 WHERE ((name = 'Edy''s' AND ABS(lat - 47.3737038) < 0.002 AND ABS(lng - 8.5300022) < 0.002) OR (name LIKE 'Edy''s%' AND ABS(lat - 47.3737038) < 0.0006 AND ABS(lng - 8.5300022) < 0.0008)) AND price_min IS NULL;
-- 16: Edy's (Lutherstrasse 2, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Edy''s' AND ABS(lat - 47.3737038) < 0.002 AND ABS(lng - 8.5300022) < 0.002) OR (name LIKE 'Edy''s%' AND ABS(lat - 47.3737038) < 0.0006 AND ABS(lng - 8.5300022) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Edy''s', 'Gemüse-Kebab am Stauffacher, auch vegan mit…', 47.3737038, 8.5300022, 12, 17, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Türkisch') OR (gruppe = 'gericht' AND name = 'Kebab') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen') OR (gruppe = 'praeferenz' AND name = 'Vegan') OR (gruppe = 'praeferenz' AND name = 'Frisch'));

UPDATE tbl_place SET price_min = 18, price_max = 27 WHERE ((name = 'Fattoush' AND ABS(lat - 47.3715683) < 0.002 AND ABS(lng - 8.5255105) < 0.002) OR (name LIKE 'Fattoush%' AND ABS(lat - 47.3715683) < 0.0006 AND ABS(lng - 8.5255105) < 0.0008)) AND price_min IS NULL;
-- 17: Fattoush (Birmensdorferstrasse 51, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Fattoush' AND ABS(lat - 47.3715683) < 0.002 AND ABS(lng - 8.5255105) < 0.002) OR (name LIKE 'Fattoush%' AND ABS(lat - 47.3715683) < 0.0006 AND ABS(lng - 8.5255105) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Fattoush', 'Restaurant mit Take-away, Syrisch', 47.3715683, 8.5255105, 18, 27, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Restaurant mit Take-away') OR (gruppe = 'kueche' AND name = 'Syrisch') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig') OR (gruppe = 'praeferenz' AND name = 'Lieferung'));

UPDATE tbl_place SET price_min = 10, price_max = 15 WHERE ((name = 'Helvetiaplatz' AND ABS(lat - 47.3760634) < 0.002 AND ABS(lng - 8.5268416) < 0.002) OR (name LIKE 'Helvetiaplatz%' AND ABS(lat - 47.3760634) < 0.0006 AND ABS(lng - 8.5268416) < 0.0008)) AND price_min IS NULL;
-- 18: Helvetiaplatz (Stauffacherstrasse, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Helvetiaplatz' AND ABS(lat - 47.3760634) < 0.002 AND ABS(lng - 8.5268416) < 0.002) OR (name LIKE 'Helvetiaplatz%' AND ABS(lat - 47.3760634) < 0.0006 AND ABS(lng - 8.5268416) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Helvetiaplatz', 'Marktstand', 47.3760634, 8.5268416, 10, 15, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 2 w, 'morning' s UNION ALL SELECT 5 w, 'morning' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Marktstand'));

UPDATE tbl_place SET price_min = 14, price_max = 18 WHERE ((name = 'House of Momos' AND ABS(lat - 47.3749982) < 0.002 AND ABS(lng - 8.5258144) < 0.002) OR (name LIKE 'House%' AND ABS(lat - 47.3749982) < 0.0006 AND ABS(lng - 8.5258144) < 0.0008)) AND price_min IS NULL;
-- 19: House of Momos (Ankerstrasse 65, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'House of Momos' AND ABS(lat - 47.3749982) < 0.002 AND ABS(lng - 8.5258144) < 0.002) OR (name LIKE 'House%' AND ABS(lat - 47.3749982) < 0.0006 AND ABS(lng - 8.5258144) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'House of Momos', 'Imbiss-Stand, Tibetisch', 47.3749982, 8.5258144, 14, 18, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Tibetisch') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig'));

UPDATE tbl_place SET price_min = 16, price_max = 22 WHERE ((name = 'Huncho' AND ABS(lat - 47.3771779) < 0.002 AND ABS(lng - 8.5290073) < 0.002) OR (name LIKE 'Huncho%' AND ABS(lat - 47.3771779) < 0.0006 AND ABS(lng - 8.5290073) < 0.0008)) AND price_min IS NULL;
-- 20: Huncho (Kanonengasse 7, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Huncho' AND ABS(lat - 47.3771779) < 0.002 AND ABS(lng - 8.5290073) < 0.002) OR (name LIKE 'Huncho%' AND ABS(lat - 47.3771779) < 0.0006 AND ABS(lng - 8.5290073) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Huncho', 'Smash-Burger und frische Pommes, ohne Sitzplätze', 47.3771779, 8.5290073, 16, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Take-away-Stand') OR (gruppe = 'kueche' AND name = 'Amerikanisch') OR (gruppe = 'gericht' AND name = 'Burger') OR (gruppe = 'gericht' AND name = 'Smash Burger'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'Infocafé' AND ABS(lat - 47.376219) < 0.002 AND ABS(lng - 8.5334566) < 0.002) OR (name LIKE 'Infocafé%' AND ABS(lat - 47.376219) < 0.0006 AND ABS(lng - 8.5334566) < 0.0008)) AND price_min IS NULL;
-- 21: Infocafé (Militärstrasse 8, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Infocafé' AND ABS(lat - 47.376219) < 0.002 AND ABS(lng - 8.5334566) < 0.002) OR (name LIKE 'Infocafé%' AND ABS(lat - 47.376219) < 0.0006 AND ABS(lng - 8.5334566) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Infocafé', 'Imbiss-Stand', 47.376219, 8.5334566, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'jung @ bridge' AND ABS(lat - 47.3788415) < 0.002 AND ABS(lng - 8.5335123) < 0.002) OR (name LIKE 'jung%' AND ABS(lat - 47.3788415) < 0.0006 AND ABS(lng - 8.5335123) < 0.0008)) AND price_min IS NULL;
-- 22: jung @ bridge (Europaallee, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'jung @ bridge' AND ABS(lat - 47.3788415) < 0.002 AND ABS(lng - 8.5335123) < 0.002) OR (name LIKE 'jung%' AND ABS(lat - 47.3788415) < 0.0006 AND ABS(lng - 8.5335123) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'jung @ bridge', 'Imbiss-Stand', 47.3788415, 8.5335123, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'morning' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen'));

UPDATE tbl_place SET price_min = 17, price_max = 25 WHERE ((name = 'Kanton Slice' AND ABS(lat - 47.3778013) < 0.002 AND ABS(lng - 8.5268763) < 0.002) OR (name LIKE 'Kanton%' AND ABS(lat - 47.3778013) < 0.0006 AND ABS(lng - 8.5268763) < 0.0008)) AND price_min IS NULL;
-- 23: Kanton Slice (Brauerstrasse, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Kanton Slice' AND ABS(lat - 47.3778013) < 0.002 AND ABS(lng - 8.5268763) < 0.002) OR (name LIKE 'Kanton%' AND ABS(lat - 47.3778013) < 0.0006 AND ABS(lng - 8.5268763) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Kanton Slice', 'Pizza-Slices, Zugang per Lift bei Hungry Duck', 47.3778013, 8.5268763, 17, 25, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'evening' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Italienisch') OR (gruppe = 'gericht' AND name = 'Pizza') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig') OR (gruppe = 'praeferenz' AND name = 'Lieferung'));

UPDATE tbl_place SET price_min = 17, price_max = 25 WHERE ((name = 'La Capricciosa' AND ABS(lat - 47.3794128) < 0.002 AND ABS(lng - 8.5280071) < 0.002) OR (name LIKE 'La%' AND ABS(lat - 47.3794128) < 0.0006 AND ABS(lng - 8.5280071) < 0.0008)) AND price_min IS NULL;
-- 24: La Capricciosa (Militärstrasse 117, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'La Capricciosa' AND ABS(lat - 47.3794128) < 0.002 AND ABS(lng - 8.5280071) < 0.002) OR (name LIKE 'La%' AND ABS(lat - 47.3794128) < 0.0006 AND ABS(lng - 8.5280071) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'La Capricciosa', 'Imbiss-Stand, Italienisch', 47.3794128, 8.5280071, 17, 25, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'morning' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Italienisch'));

UPDATE tbl_place SET price_min = 15, price_max = 21 WHERE ((name = 'La Isla Bonita' AND ABS(lat - 47.3797897) < 0.002 AND ABS(lng - 8.5286284) < 0.002) OR (name LIKE 'La%' AND ABS(lat - 47.3797897) < 0.0006 AND ABS(lng - 8.5286284) < 0.0008)) AND price_min IS NULL;
-- 25: La Isla Bonita (Lagerstrasse, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'La Isla Bonita' AND ABS(lat - 47.3797897) < 0.002 AND ABS(lng - 8.5286284) < 0.002) OR (name LIKE 'La%' AND ABS(lat - 47.3797897) < 0.0006 AND ABS(lng - 8.5286284) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'La Isla Bonita', 'Imbiss-Stand, Mexikanisch', 47.3797897, 8.5286284, 15, 21, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Mexikanisch') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'La Penisola' AND ABS(lat - 47.3739605) < 0.002 AND ABS(lng - 8.5249794) < 0.002) OR (name LIKE 'La%' AND ABS(lat - 47.3739605) < 0.0006 AND ABS(lng - 8.5249794) < 0.0008)) AND price_min IS NULL;
-- 26: La Penisola (Ankerstrasse 38, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'La Penisola' AND ABS(lat - 47.3739605) < 0.002 AND ABS(lng - 8.5249794) < 0.002) OR (name LIKE 'La%' AND ABS(lat - 47.3739605) < 0.0006 AND ABS(lng - 8.5249794) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'La Penisola', 'Imbiss-Stand, Italienisch', 47.3739605, 8.5249794, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Italienisch'));

UPDATE tbl_place SET price_min = 17, price_max = 25 WHERE ((name = 'La Perla' AND ABS(lat - 47.3711862) < 0.002 AND ABS(lng - 8.528815) < 0.002) OR (name LIKE 'La%' AND ABS(lat - 47.3711862) < 0.0006 AND ABS(lng - 8.528815) < 0.0008)) AND price_min IS NULL;
-- 27: La Perla (Morgartenstrasse, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'La Perla' AND ABS(lat - 47.3711862) < 0.002 AND ABS(lng - 8.528815) < 0.002) OR (name LIKE 'La%' AND ABS(lat - 47.3711862) < 0.0006 AND ABS(lng - 8.528815) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'La Perla', 'Kurier & Takeaway', 47.3711862, 8.528815, 17, 25, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'morning' s UNION ALL SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'morning' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Italienisch') OR (gruppe = 'gericht' AND name = 'Pizza') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen'));

UPDATE tbl_place SET price_min = 17, price_max = 24 WHERE ((name = 'Loasia' AND ABS(lat - 47.3696972) < 0.002 AND ABS(lng - 8.5259942) < 0.002) OR (name LIKE 'Loasia%' AND ABS(lat - 47.3696972) < 0.0006 AND ABS(lng - 8.5259942) < 0.0008)) AND price_min IS NULL;
-- 28: Loasia (Schimmelstrasse 2, 8003 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Loasia' AND ABS(lat - 47.3696972) < 0.002 AND ABS(lng - 8.5259942) < 0.002) OR (name LIKE 'Loasia%' AND ABS(lat - 47.3696972) < 0.0006 AND ABS(lng - 8.5259942) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Loasia', 'Imbiss-Stand, Asiatisch', 47.3696972, 8.5259942, 17, 24, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Asiatisch'));

UPDATE tbl_place SET price_min = 10, price_max = 12 WHERE ((name = 'Marronistand' AND ABS(lat - 47.3735633) < 0.002 AND ABS(lng - 8.5292099) < 0.002) OR (name LIKE 'Marronistand%' AND ABS(lat - 47.3735633) < 0.0006 AND ABS(lng - 8.5292099) < 0.0008)) AND price_min IS NULL;
-- 29: Marronistand (Stauffacher, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Marronistand' AND ABS(lat - 47.3735633) < 0.002 AND ABS(lng - 8.5292099) < 0.002) OR (name LIKE 'Marronistand%' AND ABS(lat - 47.3735633) < 0.0006 AND ABS(lng - 8.5292099) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Marronistand', 'Heisse Marroni (Saison Herbst/Winter)', 47.3735633, 8.5292099, 10, 12, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Marktstand') OR (gruppe = 'kueche' AND name = 'Schweizer') OR (gruppe = 'gericht' AND name = 'Marroni') OR (gruppe = 'praeferenz' AND name = 'Vegan') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig'));

UPDATE tbl_place SET price_min = 12, price_max = 17 WHERE ((name = 'Oder Wat' AND ABS(lat - 47.3783341) < 0.002 AND ABS(lng - 8.5286082) < 0.002) OR (name LIKE 'Oder%' AND ABS(lat - 47.3783341) < 0.0006 AND ABS(lng - 8.5286082) < 0.0008)) AND price_min IS NULL;
-- 30: Oder Wat (Tellstrasse 10, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Oder Wat' AND ABS(lat - 47.3783341) < 0.002 AND ABS(lng - 8.5286082) < 0.002) OR (name LIKE 'Oder%' AND ABS(lat - 47.3783341) < 0.0006 AND ABS(lng - 8.5286082) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Oder Wat', 'Ruhrpott-Imbiss: Currywurst mit Pommes, auch…', 47.3783341, 8.5286082, 12, 17, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Deutsch') OR (gruppe = 'gericht' AND name = 'Wurst / Currywurst') OR (gruppe = 'gericht' AND name = 'Pommes'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'Officina dos Sabores' AND ABS(lat - 47.3791641) < 0.002 AND ABS(lng - 8.527304) < 0.002) OR (name LIKE 'Officina%' AND ABS(lat - 47.3791641) < 0.0006 AND ABS(lng - 8.527304) < 0.0008)) AND price_min IS NULL;
-- 31: Officina dos Sabores (Langstrasse, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Officina dos Sabores' AND ABS(lat - 47.3791641) < 0.002 AND ABS(lng - 8.527304) < 0.002) OR (name LIKE 'Officina%' AND ABS(lat - 47.3791641) < 0.0006 AND ABS(lng - 8.527304) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Officina dos Sabores', 'Imbiss-Stand', 47.3791641, 8.527304, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'Oh My Greek' AND ABS(lat - 47.3742338) < 0.002 AND ABS(lng - 8.5214527) < 0.002) OR (name LIKE 'Oh%' AND ABS(lat - 47.3742338) < 0.0006 AND ABS(lng - 8.5214527) < 0.0008)) AND price_min IS NULL;
-- 32: Oh My Greek (Kalkbreitestrasse 1, 8003 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Oh My Greek' AND ABS(lat - 47.3742338) < 0.002 AND ABS(lng - 8.5214527) < 0.002) OR (name LIKE 'Oh%' AND ABS(lat - 47.3742338) < 0.0006 AND ABS(lng - 8.5214527) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Oh My Greek', 'Imbiss-Stand, Griechisch', 47.3742338, 8.5214527, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Griechisch') OR (gruppe = 'praeferenz' AND name = 'Vegan') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch'));

UPDATE tbl_place SET price_min = 13, price_max = 22 WHERE ((name = 'Oh My Greek!' AND ABS(lat - 47.379737) < 0.002 AND ABS(lng - 8.5363362) < 0.002) OR (name LIKE 'Oh%' AND ABS(lat - 47.379737) < 0.0006 AND ABS(lng - 8.5363362) < 0.0008)) AND price_min IS NULL;
-- 33: Oh My Greek! (Zollstrasse, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Oh My Greek!' AND ABS(lat - 47.379737) < 0.002 AND ABS(lng - 8.5363362) < 0.002) OR (name LIKE 'Oh%' AND ABS(lat - 47.379737) < 0.0006 AND ABS(lng - 8.5363362) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Oh My Greek!', 'Imbiss-Stand, Griechisch', 47.379737, 8.5363362, 13, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'morning' s UNION ALL SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'morning' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Griechisch') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen'));

UPDATE tbl_place SET price_min = 12, price_max = 17 WHERE ((name = 'Palestine Grill' AND ABS(lat - 47.3781481) < 0.002 AND ABS(lng - 8.5269898) < 0.002) OR (name LIKE 'Palestine%' AND ABS(lat - 47.3781481) < 0.0006 AND ABS(lng - 8.5269898) < 0.0008)) AND price_min IS NULL;
-- 34: Palestine Grill (Langstrasse 92, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Palestine Grill' AND ABS(lat - 47.3781481) < 0.002 AND ABS(lng - 8.5269898) < 0.002) OR (name LIKE 'Palestine%' AND ABS(lat - 47.3781481) < 0.0006 AND ABS(lng - 8.5269898) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Palestine Grill', 'Imbiss-Stand', 47.3781481, 8.5269898, 12, 17, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'gericht' AND name = 'Falafel') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig'));

UPDATE tbl_place SET price_min = 20, price_max = 26 WHERE ((name = 'Phuket Thai Food' AND ABS(lat - 47.3802073) < 0.002 AND ABS(lng - 8.5263721) < 0.002) OR (name LIKE 'Phuket%' AND ABS(lat - 47.3802073) < 0.0006 AND ABS(lng - 8.5263721) < 0.0008)) AND price_min IS NULL;
-- 35: Phuket Thai Food (Schöneggstrasse 21, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Phuket Thai Food' AND ABS(lat - 47.3802073) < 0.002 AND ABS(lng - 8.5263721) < 0.002) OR (name LIKE 'Phuket%' AND ABS(lat - 47.3802073) < 0.0006 AND ABS(lng - 8.5263721) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Phuket Thai Food', 'Imbiss-Stand, Thailändisch', 47.3802073, 8.5263721, 20, 26, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'morning' s UNION ALL SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'morning' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Thailändisch') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'Piro' AND ABS(lat - 47.3779438) < 0.002 AND ABS(lng - 8.5265762) < 0.002) OR (name LIKE 'Piro%' AND ABS(lat - 47.3779438) < 0.0006 AND ABS(lng - 8.5265762) < 0.0008)) AND price_min IS NULL;
-- 36: Piro (Brauerstrasse, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Piro' AND ABS(lat - 47.3779438) < 0.002 AND ABS(lng - 8.5265762) < 0.002) OR (name LIKE 'Piro%' AND ABS(lat - 47.3779438) < 0.0006 AND ABS(lng - 8.5265762) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Piro', 'Imbiss-Stand', 47.3779438, 8.5265762, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig'));

UPDATE tbl_place SET price_min = 17, price_max = 24 WHERE ((name = 'PUTPU Takeaway' AND ABS(lat - 47.3764992) < 0.002 AND ABS(lng - 8.5252048) < 0.002) OR (name LIKE 'PUTPU%' AND ABS(lat - 47.3764992) < 0.0006 AND ABS(lng - 8.5252048) < 0.0008)) AND price_min IS NULL;
-- 37: PUTPU Takeaway (Stauffacherstrasse 101, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'PUTPU Takeaway' AND ABS(lat - 47.3764992) < 0.002 AND ABS(lng - 8.5252048) < 0.002) OR (name LIKE 'PUTPU%' AND ABS(lat - 47.3764992) < 0.0006 AND ABS(lng - 8.5252048) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'PUTPU Takeaway', 'Japanisches Chicken Curry', 47.3764992, 8.5252048, 17, 24, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Restaurant mit Take-away') OR (gruppe = 'kueche' AND name = 'Japanisch') OR (gruppe = 'gericht' AND name = 'Curry') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig') OR (gruppe = 'praeferenz' AND name = 'Online bestellen'));

UPDATE tbl_place SET price_min = 14, price_max = 20 WHERE ((name = 'Roots of Himalaya' AND ABS(lat - 47.3742749) < 0.002 AND ABS(lng - 8.5219557) < 0.002) OR (name LIKE 'Roots%' AND ABS(lat - 47.3742749) < 0.0006 AND ABS(lng - 8.5219557) < 0.0008)) AND price_min IS NULL;
-- 38: Roots of Himalaya (Badenerstrasse 155, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Roots of Himalaya' AND ABS(lat - 47.3742749) < 0.002 AND ABS(lng - 8.5219557) < 0.002) OR (name LIKE 'Roots%' AND ABS(lat - 47.3742749) < 0.0006 AND ABS(lng - 8.5219557) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Roots of Himalaya', 'Tibetische Momos, auch Curry und Bowls', 47.3742749, 8.5219557, 14, 20, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Tibetisch') OR (gruppe = 'gericht' AND name = 'Momos') OR (gruppe = 'gericht' AND name = 'Curry') OR (gruppe = 'gericht' AND name = 'Bowls') OR (gruppe = 'praeferenz' AND name = 'Vegan') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch'));

UPDATE tbl_place SET price_min = 10, price_max = 15 WHERE ((name = 'Rosita''s' AND ABS(lat - 47.3793553) < 0.002 AND ABS(lng - 8.5297102) < 0.002) OR (name LIKE 'Rosita''s%' AND ABS(lat - 47.3793553) < 0.0006 AND ABS(lng - 8.5297102) < 0.0008)) AND price_min IS NULL;
-- 39: Rosita's (Lagerstrasse 95, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Rosita''s' AND ABS(lat - 47.3793553) < 0.002 AND ABS(lng - 8.5297102) < 0.002) OR (name LIKE 'Rosita''s%' AND ABS(lat - 47.3793553) < 0.0006 AND ABS(lng - 8.5297102) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Rosita''s', 'Grosszügige, frisch belegte Sandwiches', 47.3793553, 8.5297102, 10, 15, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Take-away-Stand') OR (gruppe = 'gericht' AND name = 'Sandwiches') OR (gruppe = 'praeferenz' AND name = 'Frisch'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'Rotana' AND ABS(lat - 47.3787145) < 0.002 AND ABS(lng - 8.5267193) < 0.002) OR (name LIKE 'Rotana%' AND ABS(lat - 47.3787145) < 0.0006 AND ABS(lng - 8.5267193) < 0.0008)) AND price_min IS NULL;
-- 40: Rotana (Dienerstrasse, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Rotana' AND ABS(lat - 47.3787145) < 0.002 AND ABS(lng - 8.5267193) < 0.002) OR (name LIKE 'Rotana%' AND ABS(lat - 47.3787145) < 0.0006 AND ABS(lng - 8.5267193) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Rotana', 'Imbiss-Stand', 47.3787145, 8.5267193, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig'));

UPDATE tbl_place SET price_min = 13, price_max = 20 WHERE ((name = 'Simply Soup' AND ABS(lat - 47.3718091) < 0.002 AND ABS(lng - 8.5290154) < 0.002) OR (name LIKE 'Simply%' AND ABS(lat - 47.3718091) < 0.0006 AND ABS(lng - 8.5290154) < 0.0008)) AND price_min IS NULL;
-- 41: Simply Soup (Hallwylstrasse 24, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Simply Soup' AND ABS(lat - 47.3718091) < 0.002 AND ABS(lng - 8.5290154) < 0.002) OR (name LIKE 'Simply%' AND ABS(lat - 47.3718091) < 0.0006 AND ABS(lng - 8.5290154) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Simply Soup', 'Imbiss-Stand', 47.3718091, 8.5290154, 13, 20, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'gericht' AND name = 'Suppen') OR (gruppe = 'praeferenz' AND name = 'Vegan'));

UPDATE tbl_place SET price_min = 13, price_max = 20 WHERE ((name = 'Simply Soup Kalkbreite' AND ABS(lat - 47.3740794) < 0.002 AND ABS(lng - 8.5204972) < 0.002) OR (name LIKE 'Simply%' AND ABS(lat - 47.3740794) < 0.0006 AND ABS(lng - 8.5204972) < 0.0008)) AND price_min IS NULL;
-- 42: Simply Soup Kalkbreite (Kalkbreitestrasse 10, 8003 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Simply Soup Kalkbreite' AND ABS(lat - 47.3740794) < 0.002 AND ABS(lng - 8.5204972) < 0.002) OR (name LIKE 'Simply%' AND ABS(lat - 47.3740794) < 0.0006 AND ABS(lng - 8.5204972) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Simply Soup Kalkbreite', 'Imbiss-Stand', 47.3740794, 8.5204972, 13, 20, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'gericht' AND name = 'Suppen') OR (gruppe = 'praeferenz' AND name = 'Vegan') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen'));

UPDATE tbl_place SET price_min = 17, price_max = 25 WHERE ((name = 'Spaccio' AND ABS(lat - 47.376758) < 0.002 AND ABS(lng - 8.5257606) < 0.002) OR (name LIKE 'Spaccio%' AND ABS(lat - 47.376758) < 0.0006 AND ABS(lng - 8.5257606) < 0.0008)) AND price_min IS NULL;
-- 43: Spaccio (Langstrasse 61, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Spaccio' AND ABS(lat - 47.376758) < 0.002 AND ABS(lng - 8.5257606) < 0.002) OR (name LIKE 'Spaccio%' AND ABS(lat - 47.376758) < 0.0006 AND ABS(lng - 8.5257606) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Spaccio', 'Imbiss-Stand, Italienisch', 47.376758, 8.5257606, 17, 25, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Italienisch') OR (gruppe = 'gericht' AND name = 'Pizza'));

UPDATE tbl_place SET price_min = 16, price_max = 23 WHERE ((name = 'Street' AND ABS(lat - 47.3738096) < 0.002 AND ABS(lng - 8.526028) < 0.002) OR (name LIKE 'Street%' AND ABS(lat - 47.3738096) < 0.0006 AND ABS(lng - 8.526028) < 0.0008)) AND price_min IS NULL;
-- 44: Street (Badenerstrasse 85, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Street' AND ABS(lat - 47.3738096) < 0.002 AND ABS(lng - 8.526028) < 0.002) OR (name LIKE 'Street%' AND ABS(lat - 47.3738096) < 0.0006 AND ABS(lng - 8.526028) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Street', 'Imbiss-Stand, Amerikanisch', 47.3738096, 8.526028, 16, 23, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Amerikanisch') OR (gruppe = 'gericht' AND name = 'Burger'));

UPDATE tbl_place SET price_min = 12, price_max = 15 WHERE ((name = 'Suppelade' AND ABS(lat - 47.379811) < 0.002 AND ABS(lng - 8.52851) < 0.002) OR (name LIKE 'Suppelade%' AND ABS(lat - 47.379811) < 0.0006 AND ABS(lng - 8.52851) < 0.0008)) AND price_min IS NULL;
-- 45: Suppelade (Lagerstrasse 119, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Suppelade' AND ABS(lat - 47.379811) < 0.002 AND ABS(lng - 8.52851) < 0.002) OR (name LIKE 'Suppelade%' AND ABS(lat - 47.379811) < 0.0006 AND ABS(lng - 8.52851) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Suppelade', 'Drei frische Suppen täglich mit Brot und Frucht', 47.379811, 8.52851, 12, 15, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Take-away-Stand') OR (gruppe = 'gericht' AND name = 'Suppen') OR (gruppe = 'praeferenz' AND name = 'Vegan') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch') OR (gruppe = 'praeferenz' AND name = 'Hausgemacht'));

UPDATE tbl_place SET price_min = 10, price_max = 15 WHERE ((name = 'SV Mensa' AND ABS(lat - 47.3783663) < 0.002 AND ABS(lng - 8.5327943) < 0.002) OR (name LIKE 'SV%' AND ABS(lat - 47.3783663) < 0.0006 AND ABS(lng - 8.5327943) < 0.0008)) AND price_min IS NULL;
-- 46: SV Mensa (Eisgasse, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'SV Mensa' AND ABS(lat - 47.3783663) < 0.002 AND ABS(lng - 8.5327943) < 0.002) OR (name LIKE 'SV%' AND ABS(lat - 47.3783663) < 0.0006 AND ABS(lng - 8.5327943) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'SV Mensa', 'Mensa', 47.3783663, 8.5327943, 10, 15, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Mensa'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'Swiss Fried Chicken' AND ABS(lat - 47.3788213) < 0.002 AND ABS(lng - 8.5276299) < 0.002) OR (name LIKE 'Swiss%' AND ABS(lat - 47.3788213) < 0.0006 AND ABS(lng - 8.5276299) < 0.0008)) AND price_min IS NULL;
-- 47: Swiss Fried Chicken (Zwinglistrasse 43, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Swiss Fried Chicken' AND ABS(lat - 47.3788213) < 0.002 AND ABS(lng - 8.5276299) < 0.002) OR (name LIKE 'Swiss%' AND ABS(lat - 47.3788213) < 0.0006 AND ABS(lng - 8.5276299) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Swiss Fried Chicken', 'Imbiss-Stand', 47.3788213, 8.5276299, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig'));

UPDATE tbl_place SET price_min = 15, price_max = 21 WHERE ((name = 'Tacos Ramiro y Macario' AND ABS(lat - 47.3790661) < 0.002 AND ABS(lng - 8.5108789) < 0.002) OR (name LIKE 'Tacos%' AND ABS(lat - 47.3790661) < 0.0006 AND ABS(lng - 8.5108789) < 0.0008)) AND price_min IS NULL;
-- 48: Tacos Ramiro y Macario (Hardstrasse 9, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Tacos Ramiro y Macario' AND ABS(lat - 47.3790661) < 0.002 AND ABS(lng - 8.5108789) < 0.002) OR (name LIKE 'Tacos%' AND ABS(lat - 47.3790661) < 0.0006 AND ABS(lng - 8.5108789) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Tacos Ramiro y Macario', 'Imbiss-Stand, Mexikanisch', 47.3790661, 8.5108789, 15, 21, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Mexikanisch'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'Taste of Africa' AND ABS(lat - 47.379434) < 0.002 AND ABS(lng - 8.5279472) < 0.002) OR (name LIKE 'Taste%' AND ABS(lat - 47.379434) < 0.0006 AND ABS(lng - 8.5279472) < 0.0008)) AND price_min IS NULL;
-- 49: Taste of Africa (Militärstrasse, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Taste of Africa' AND ABS(lat - 47.379434) < 0.002 AND ABS(lng - 8.5279472) < 0.002) OR (name LIKE 'Taste%' AND ABS(lat - 47.379434) < 0.0006 AND ABS(lng - 8.5279472) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Taste of Africa', 'Restaurant/Take-away/Catering', 47.379434, 8.5279472, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand'));

UPDATE tbl_place SET price_min = 18, price_max = 24 WHERE ((name = 'Thai Take-Away' AND ABS(lat - 47.3726302) < 0.002 AND ABS(lng - 8.5276556) < 0.002) OR (name LIKE 'Thai%' AND ABS(lat - 47.3726302) < 0.0006 AND ABS(lng - 8.5276556) < 0.0008)) AND price_min IS NULL;
-- 50: Thai Take-Away (Werdstrasse 62, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Thai Take-Away' AND ABS(lat - 47.3726302) < 0.002 AND ABS(lng - 8.5276556) < 0.002) OR (name LIKE 'Thai%' AND ABS(lat - 47.3726302) < 0.0006 AND ABS(lng - 8.5276556) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Thai Take-Away', 'Take-away-Stand, Thailändisch', 47.3726302, 8.5276556, 18, 24, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Take-away-Stand') OR (gruppe = 'kueche' AND name = 'Thailändisch'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'The Barn' AND ABS(lat - 47.3791284) < 0.002 AND ABS(lng - 8.5365479) < 0.002) OR (name LIKE 'The%' AND ABS(lat - 47.3791284) < 0.0006 AND ABS(lng - 8.5365479) < 0.0008)) AND price_min IS NULL;
-- 51: The Barn (, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'The Barn' AND ABS(lat - 47.3791284) < 0.002 AND ABS(lng - 8.5365479) < 0.002) OR (name LIKE 'The%' AND ABS(lat - 47.3791284) < 0.0006 AND ABS(lng - 8.5365479) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'The Barn', 'Imbiss-Stand', 47.3791284, 8.5365479, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'morning' s UNION ALL SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'morning' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch') OR (gruppe = 'praeferenz' AND name = 'Glutenfrei') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig'));

UPDATE tbl_place SET price_min = 13, price_max = 22 WHERE ((name = 'Three Men''s Kebab' AND ABS(lat - 47.3770319) < 0.002 AND ABS(lng - 8.5323997) < 0.002) OR (name LIKE 'Three%' AND ABS(lat - 47.3770319) < 0.0006 AND ABS(lng - 8.5323997) < 0.0008)) AND price_min IS NULL;
-- 52: Three Men's Kebab (Freischützgasse 1, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Three Men''s Kebab' AND ABS(lat - 47.3770319) < 0.002 AND ABS(lng - 8.5323997) < 0.002) OR (name LIKE 'Three%' AND ABS(lat - 47.3770319) < 0.0006 AND ABS(lng - 8.5323997) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Three Men''s Kebab', 'Imbiss-Stand', 47.3770319, 8.5323997, 13, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand'));

UPDATE tbl_place SET price_min = 13, price_max = 22 WHERE ((name = 'Tiny Fish' AND ABS(lat - 47.3743132) < 0.002 AND ABS(lng - 8.521665) < 0.002) OR (name LIKE 'Tiny%' AND ABS(lat - 47.3743132) < 0.0006 AND ABS(lng - 8.521665) < 0.0008)) AND price_min IS NULL;
-- 53: Tiny Fish (Badenerstrasse 157, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Tiny Fish' AND ABS(lat - 47.3743132) < 0.002 AND ABS(lng - 8.521665) < 0.002) OR (name LIKE 'Tiny%' AND ABS(lat - 47.3743132) < 0.0006 AND ABS(lng - 8.521665) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Tiny Fish', 'Imbiss-Stand, Japanisch', 47.3743132, 8.521665, 13, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Japanisch') OR (gruppe = 'gericht' AND name = 'Sushi'));

UPDATE tbl_place SET price_min = 16, price_max = 26 WHERE ((name = 'Umami House' AND ABS(lat - 47.3743601) < 0.002 AND ABS(lng - 8.5321403) < 0.002) OR (name LIKE 'Umami%' AND ABS(lat - 47.3743601) < 0.0006 AND ABS(lng - 8.5321403) < 0.0008)) AND price_min IS NULL;
-- 54: Umami House (Kasernenstrasse 21, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Umami House' AND ABS(lat - 47.3743601) < 0.002 AND ABS(lng - 8.5321403) < 0.002) OR (name LIKE 'Umami%' AND ABS(lat - 47.3743601) < 0.0006 AND ABS(lng - 8.5321403) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Umami House', 'Imbiss-Stand, Japanisch', 47.3743601, 8.5321403, 16, 26, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Japanisch') OR (gruppe = 'gericht' AND name = 'Sushi'));

UPDATE tbl_place SET price_min = 13, price_max = 18 WHERE ((name = 'Veganitas' AND ABS(lat - 47.3775824) < 0.002 AND ABS(lng - 8.5276791) < 0.002) OR (name LIKE 'Veganitas%' AND ABS(lat - 47.3775824) < 0.0006 AND ABS(lng - 8.5276791) < 0.0008)) AND price_min IS NULL;
-- 55: Veganitas (Brauerstrasse 30, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Veganitas' AND ABS(lat - 47.3775824) < 0.002 AND ABS(lng - 8.5276791) < 0.002) OR (name LIKE 'Veganitas%' AND ABS(lat - 47.3775824) < 0.0006 AND ABS(lng - 8.5276791) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Veganitas', 'Veganes Fast Food: Pitas und Burger', 47.3775824, 8.5276791, 13, 18, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Restaurant mit Take-away') OR (gruppe = 'gericht' AND name = 'Pita') OR (gruppe = 'gericht' AND name = 'Burger') OR (gruppe = 'praeferenz' AND name = 'Vegan') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen') OR (gruppe = 'praeferenz' AND name = 'Online bestellen'));

UPDATE tbl_place SET price_min = 10, price_max = 15 WHERE ((name = 'Via del gusto 28' AND ABS(lat - 47.3782124) < 0.002 AND ABS(lng - 8.5325262) < 0.002) OR (name LIKE 'Via%' AND ABS(lat - 47.3782124) < 0.0006 AND ABS(lng - 8.5325262) < 0.0008)) AND price_min IS NULL;
-- 56: Via del gusto 28 (Lagerstrasse 28, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Via del gusto 28' AND ABS(lat - 47.3782124) < 0.002 AND ABS(lng - 8.5325262) < 0.002) OR (name LIKE 'Via%' AND ABS(lat - 47.3782124) < 0.0006 AND ABS(lng - 8.5325262) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Via del gusto 28', 'Imbiss-Stand, Italienisch', 47.3782124, 8.5325262, 10, 15, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'morning' s UNION ALL SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'morning' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Italienisch') OR (gruppe = 'gericht' AND name = 'Sandwiches') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen'));

UPDATE tbl_place SET price_min = 17, price_max = 24 WHERE ((name = 'Weera Pura' AND ABS(lat - 47.3746797) < 0.002 AND ABS(lng - 8.5198775) < 0.002) OR (name LIKE 'Weera%' AND ABS(lat - 47.3746797) < 0.0006 AND ABS(lng - 8.5198775) < 0.0008)) AND price_min IS NULL;
-- 57: Weera Pura (Badenerstrasse 177, 8003 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Weera Pura' AND ABS(lat - 47.3746797) < 0.002 AND ABS(lng - 8.5198775) < 0.002) OR (name LIKE 'Weera%' AND ABS(lat - 47.3746797) < 0.0006 AND ABS(lng - 8.5198775) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Weera Pura', 'Imbiss-Stand', 47.3746797, 8.5198775, 17, 24, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'gericht' AND name = 'Curry') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig'));

UPDATE tbl_place SET price_min = 13, price_max = 22 WHERE ((name = 'Wesley''s Kitchen' AND ABS(lat - 47.3794641) < 0.002 AND ABS(lng - 8.5372186) < 0.002) OR (name LIKE 'Wesley''s%' AND ABS(lat - 47.3794641) < 0.0006 AND ABS(lng - 8.5372186) < 0.0008)) AND price_min IS NULL;
-- 58: Wesley's Kitchen (Zollstrasse, 8021 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Wesley''s Kitchen' AND ABS(lat - 47.3794641) < 0.002 AND ABS(lng - 8.5372186) < 0.002) OR (name LIKE 'Wesley''s%' AND ABS(lat - 47.3794641) < 0.0006 AND ABS(lng - 8.5372186) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Wesley''s Kitchen', 'Dim Sum und Wok-Nudeln', 47.3794641, 8.5372186, 13, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Asiatisch') OR (gruppe = 'kueche' AND name = 'Chinesisch') OR (gruppe = 'gericht' AND name = 'Dim Sum') OR (gruppe = 'gericht' AND name = 'Nudeln') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'Zuki''s' AND ABS(lat - 47.3713686) < 0.002 AND ABS(lng - 8.5290453) < 0.002) OR (name LIKE 'Zuki''s%' AND ABS(lat - 47.3713686) < 0.0006 AND ABS(lng - 8.5290453) < 0.0008)) AND price_min IS NULL;
-- 59: Zuki's (Morgartenstrasse 12, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Zuki''s' AND ABS(lat - 47.3713686) < 0.002 AND ABS(lng - 8.5290453) < 0.002) OR (name LIKE 'Zuki''s%' AND ABS(lat - 47.3713686) < 0.0006 AND ABS(lng - 8.5290453) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Zuki''s', 'Imbiss-Stand', 47.3713686, 8.5290453, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand'));

UPDATE tbl_place SET price_min = 12, price_max = 17 WHERE ((name = 'Zum goldenen Taschenbrot' AND ABS(lat - 47.3788366) < 0.002 AND ABS(lng - 8.5291393) < 0.002) OR (name LIKE 'Zum%' AND ABS(lat - 47.3788366) < 0.0006 AND ABS(lng - 8.5291393) < 0.0008)) AND price_min IS NULL;
-- 60: Zum goldenen Taschenbrot (Militärstrasse 91, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Zum goldenen Taschenbrot' AND ABS(lat - 47.3788366) < 0.002 AND ABS(lng - 8.5291393) < 0.002) OR (name LIKE 'Zum%' AND ABS(lat - 47.3788366) < 0.0006 AND ABS(lng - 8.5291393) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Zum goldenen Taschenbrot', 'Imbiss-Stand, Türkisch', 47.3788366, 8.5291393, 12, 17, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Türkisch') OR (gruppe = 'gericht' AND name = 'Kebab') OR (gruppe = 'praeferenz' AND name = 'Vegan'));

UPDATE tbl_place SET price_min = 16, price_max = 23 WHERE ((name = 'Zürich Fried Chicken' AND ABS(lat - 47.3751013) < 0.002 AND ABS(lng - 8.5285248) < 0.002) OR (name LIKE 'Zürich%' AND ABS(lat - 47.3751013) < 0.0006 AND ABS(lng - 8.5285248) < 0.0008)) AND price_min IS NULL;
-- 61: Zürich Fried Chicken (Bäckerstrasse 43, 8004 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Zürich Fried Chicken' AND ABS(lat - 47.3751013) < 0.002 AND ABS(lng - 8.5285248) < 0.002) OR (name LIKE 'Zürich%' AND ABS(lat - 47.3751013) < 0.0006 AND ABS(lng - 8.5285248) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Zürich Fried Chicken', 'Imbiss-Stand, Amerikanisch', 47.3751013, 8.5285248, 16, 23, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Amerikanisch') OR (gruppe = 'gericht' AND name = 'Burger') OR (gruppe = 'gericht' AND name = 'Poulet / Fried Chicken'));

UPDATE tbl_place SET price_min = 12, price_max = 17 WHERE ((name = 'Ada Lokma' AND ABS(lat - 47.390504) < 0.002 AND ABS(lng - 8.512049) < 0.002) OR (name LIKE 'Ada%' AND ABS(lat - 47.390504) < 0.0006 AND ABS(lng - 8.512049) < 0.0008)) AND price_min IS NULL;
-- 62: Ada Lokma (Toni-Areal, Pfingstweidstrasse 96, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Ada Lokma' AND ABS(lat - 47.390504) < 0.002 AND ABS(lng - 8.512049) < 0.002) OR (name LIKE 'Ada%' AND ABS(lat - 47.390504) < 0.0006 AND ABS(lng - 8.512049) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Ada Lokma', 'Kebab, Köfte, auch vegetarisch und vegan', 47.390504, 8.512049, 12, 17, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Food Truck') OR (gruppe = 'kueche' AND name = 'Türkisch') OR (gruppe = 'gericht' AND name = 'Kebab') OR (gruppe = 'gericht' AND name = 'Köfte') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch') OR (gruppe = 'praeferenz' AND name = 'Vegan'));

UPDATE tbl_place SET price_min = 17, price_max = 23 WHERE ((name = 'Banh Mi' AND ABS(lat - 47.3883286) < 0.002 AND ABS(lng - 8.5259591) < 0.002) OR (name LIKE 'Banh%' AND ABS(lat - 47.3883286) < 0.0006 AND ABS(lng - 8.5259591) < 0.0008)) AND price_min IS NULL;
-- 63: Banh Mi (Limmatstrasse, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Banh Mi' AND ABS(lat - 47.3883286) < 0.002 AND ABS(lng - 8.5259591) < 0.002) OR (name LIKE 'Banh%' AND ABS(lat - 47.3883286) < 0.0006 AND ABS(lng - 8.5259591) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Banh Mi', 'Imbiss-Stand, Vietnamesisch', 47.3883286, 8.5259591, 17, 23, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Vietnamesisch') OR (gruppe = 'praeferenz' AND name = 'Vegan') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch'));

UPDATE tbl_place SET price_min = 12, price_max = 17 WHERE ((name = 'Bebos Beef & Chicken' AND ABS(lat - 47.3897523) < 0.002 AND ABS(lng - 8.5219083) < 0.002) OR (name LIKE 'Bebos%' AND ABS(lat - 47.3897523) < 0.0006 AND ABS(lng - 8.5219083) < 0.0008)) AND price_min IS NULL;
-- 64: Bebos Beef & Chicken (Hardstrasse 310, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Bebos Beef & Chicken' AND ABS(lat - 47.3897523) < 0.002 AND ABS(lng - 8.5219083) < 0.002) OR (name LIKE 'Bebos%' AND ABS(lat - 47.3897523) < 0.0006 AND ABS(lng - 8.5219083) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Bebos Beef & Chicken', 'Imbiss-Stand, Amerikanisch, Türkisch', 47.3897523, 8.5219083, 12, 17, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'morning' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Amerikanisch') OR (gruppe = 'kueche' AND name = 'Türkisch') OR (gruppe = 'gericht' AND name = 'Burger') OR (gruppe = 'gericht' AND name = 'Kebab') OR (gruppe = 'gericht' AND name = 'Poulet / Fried Chicken') OR (gruppe = 'praeferenz' AND name = 'Online bestellen'));

UPDATE tbl_place SET price_min = 12, price_max = 17 WHERE ((name = 'Best Kebab' AND ABS(lat - 47.3827549) < 0.002 AND ABS(lng - 8.5300757) < 0.002) OR (name LIKE 'Best%' AND ABS(lat - 47.3827549) < 0.0006 AND ABS(lng - 8.5300757) < 0.0008)) AND price_min IS NULL;
-- 65: Best Kebab (Langstrasse 206, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Best Kebab' AND ABS(lat - 47.3827549) < 0.002 AND ABS(lng - 8.5300757) < 0.002) OR (name LIKE 'Best%' AND ABS(lat - 47.3827549) < 0.0006 AND ABS(lng - 8.5300757) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Best Kebab', 'Döner, Lahmacun, Adana-Kebab, bis spät offen', 47.3827549, 8.5300757, 12, 17, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'morning' s UNION ALL SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'morning' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Türkisch') OR (gruppe = 'gericht' AND name = 'Kebab') OR (gruppe = 'gericht' AND name = 'Pide / Lahmacun') OR (gruppe = 'gericht' AND name = 'Burger') OR (gruppe = 'gericht' AND name = 'Wraps') OR (gruppe = 'praeferenz' AND name = 'Halal') OR (gruppe = 'praeferenz' AND name = 'Grosse Portionen'));

UPDATE tbl_place SET price_min = 18, price_max = 26 WHERE ((name = 'Bibim Shack' AND ABS(lat - 47.3903038) < 0.002 AND ABS(lng - 8.5226208) < 0.002) OR (name LIKE 'Bibim%' AND ABS(lat - 47.3903038) < 0.0006 AND ABS(lng - 8.5226208) < 0.0008)) AND price_min IS NULL;
-- 66: Bibim Shack (Hardstrasse 320, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Bibim Shack' AND ABS(lat - 47.3903038) < 0.002 AND ABS(lng - 8.5226208) < 0.002) OR (name LIKE 'Bibim%' AND ABS(lat - 47.3903038) < 0.0006 AND ABS(lng - 8.5226208) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Bibim Shack', 'Imbiss-Stand, Koreanisch', 47.3903038, 8.5226208, 18, 26, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Koreanisch') OR (gruppe = 'praeferenz' AND name = 'Vegan') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen'));

UPDATE tbl_place SET price_min = 18, price_max = 24 WHERE ((name = 'Bunzai Popup' AND ABS(lat - 47.390263) < 0.002 AND ABS(lng - 8.5225461) < 0.002) OR (name LIKE 'Bunzai%' AND ABS(lat - 47.390263) < 0.0006 AND ABS(lng - 8.5225461) < 0.0008)) AND price_min IS NULL;
-- 67: Bunzai Popup (Sihlquai-Südrampe, 8037 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Bunzai Popup' AND ABS(lat - 47.390263) < 0.002 AND ABS(lng - 8.5225461) < 0.002) OR (name LIKE 'Bunzai%' AND ABS(lat - 47.390263) < 0.0006 AND ABS(lng - 8.5225461) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Bunzai Popup', 'Imbiss-Stand, Thailändisch', 47.390263, 8.5225461, 18, 24, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Thailändisch'));

UPDATE tbl_place SET price_min = 15, price_max = 29 WHERE ((name = 'Con Gusto' AND ABS(lat - 47.3907695) < 0.002 AND ABS(lng - 8.5093071) < 0.002) OR (name LIKE 'Con%' AND ABS(lat - 47.3907695) < 0.0006 AND ABS(lng - 8.5093071) < 0.0008)) AND price_min IS NULL;
-- 68: Con Gusto (Pfingstweidstrasse, 8010 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Con Gusto' AND ABS(lat - 47.3907695) < 0.002 AND ABS(lng - 8.5093071) < 0.002) OR (name LIKE 'Con%' AND ABS(lat - 47.3907695) < 0.0006 AND ABS(lng - 8.5093071) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Con Gusto', 'Imbiss-Stand, Italienisch', 47.3907695, 8.5093071, 15, 29, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Italienisch') OR (gruppe = 'gericht' AND name = 'Pizza') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen'));

UPDATE tbl_place SET price_min = 17, price_max = 23 WHERE ((name = 'Cô Ba Canteen' AND ABS(lat - 47.3839455) < 0.002 AND ABS(lng - 8.5307226) < 0.002) OR (name LIKE 'Cô%' AND ABS(lat - 47.3839455) < 0.0006 AND ABS(lng - 8.5307226) < 0.0008)) AND price_min IS NULL;
-- 69: Cô Ba Canteen (Heinrichstrasse 65, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Cô Ba Canteen' AND ABS(lat - 47.3839455) < 0.002 AND ABS(lng - 8.5307226) < 0.002) OR (name LIKE 'Cô%' AND ABS(lat - 47.3839455) < 0.0006 AND ABS(lng - 8.5307226) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Cô Ba Canteen', 'Imbiss-Stand, Vietnamesisch', 47.3839455, 8.5307226, 17, 23, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'morning' s UNION ALL SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'morning' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Vietnamesisch'));

UPDATE tbl_place SET price_min = 10, price_max = 15 WHERE ((name = 'Da Marco am Limmatplatz' AND ABS(lat - 47.3844835) < 0.002 AND ABS(lng - 8.5322947) < 0.002) OR (name LIKE 'Da%' AND ABS(lat - 47.3844835) < 0.0006 AND ABS(lng - 8.5322947) < 0.0008)) AND price_min IS NULL;
-- 70: Da Marco am Limmatplatz (Ausstellungsstrasse 114, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Da Marco am Limmatplatz' AND ABS(lat - 47.3844835) < 0.002 AND ABS(lng - 8.5322947) < 0.002) OR (name LIKE 'Da%' AND ABS(lat - 47.3844835) < 0.0006 AND ABS(lng - 8.5322947) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Da Marco am Limmatplatz', 'Frische Panini und Pizza am Limmatplatz', 47.3844835, 8.5322947, 10, 15, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Italienisch') OR (gruppe = 'gericht' AND name = 'Sandwiches') OR (gruppe = 'gericht' AND name = 'Panini') OR (gruppe = 'gericht' AND name = 'Pizza') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch'));

UPDATE tbl_place SET price_min = 15, price_max = 20 WHERE ((name = 'Deliz Asia' AND ABS(lat - 47.391572) < 0.002 AND ABS(lng - 8.517016) < 0.002) OR (name LIKE 'Deliz%' AND ABS(lat - 47.391572) < 0.0006 AND ABS(lng - 8.517016) < 0.0008)) AND price_min IS NULL;
-- 71: Deliz Asia (Toni-Areal, Förrlibuckstrasse 149, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Deliz Asia' AND ABS(lat - 47.391572) < 0.002 AND ABS(lng - 8.517016) < 0.002) OR (name LIKE 'Deliz%' AND ABS(lat - 47.391572) < 0.0006 AND ABS(lng - 8.517016) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Deliz Asia', 'Butter Chicken, Kottu Rotti, Naan, Samosa', 47.391572, 8.517016, 15, 20, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Food Truck') OR (gruppe = 'kueche' AND name = 'Indisch') OR (gruppe = 'kueche' AND name = 'Sri Lankisch') OR (gruppe = 'gericht' AND name = 'Curry') OR (gruppe = 'gericht' AND name = 'Kottu Roti'));

UPDATE tbl_place SET price_min = 14, price_max = 19 WHERE ((name = 'El Turpial' AND ABS(lat - 47.390504) < 0.002 AND ABS(lng - 8.512049) < 0.002) OR (name LIKE 'El%' AND ABS(lat - 47.390504) < 0.0006 AND ABS(lng - 8.512049) < 0.0008)) AND price_min IS NULL;
-- 72: El Turpial (Toni-Areal, Pfingstweidstrasse 96, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'El Turpial' AND ABS(lat - 47.390504) < 0.002 AND ABS(lng - 8.512049) < 0.002) OR (name LIKE 'El%' AND ABS(lat - 47.390504) < 0.0006 AND ABS(lng - 8.512049) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'El Turpial', 'Venezolanische Arepas, auch vegan', 47.390504, 8.512049, 14, 19, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 3 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Food Truck') OR (gruppe = 'kueche' AND name = 'Venezolanisch') OR (gruppe = 'gericht' AND name = 'Arepas') OR (gruppe = 'praeferenz' AND name = 'Glutenfrei') OR (gruppe = 'praeferenz' AND name = 'Vegan'));

UPDATE tbl_place SET price_min = 14, price_max = 20 WHERE ((name = 'Frida' AND ABS(lat - 47.3811243) < 0.002 AND ABS(lng - 8.5361272) < 0.002) OR (name LIKE 'Frida%' AND ABS(lat - 47.3811243) < 0.0006 AND ABS(lng - 8.5361272) < 0.0008)) AND price_min IS NULL;
-- 73: Frida (Limmatstrasse 31, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Frida' AND ABS(lat - 47.3811243) < 0.002 AND ABS(lng - 8.5361272) < 0.002) OR (name LIKE 'Frida%' AND ABS(lat - 47.3811243) < 0.0006 AND ABS(lng - 8.5361272) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Frida', 'Mexikanische Tacos und Burritos zum Mitnehmen', 47.3811243, 8.5361272, 14, 20, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Take-away-Stand') OR (gruppe = 'kueche' AND name = 'Mexikanisch') OR (gruppe = 'gericht' AND name = 'Tacos') OR (gruppe = 'gericht' AND name = 'Burritos') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig') OR (gruppe = 'praeferenz' AND name = 'Lieferung') OR (gruppe = 'praeferenz' AND name = 'Kartenzahlung'));

UPDATE tbl_place SET price_min = 18, price_max = 27 WHERE ((name = 'Gyoza Yokocho' AND ABS(lat - 47.3876919) < 0.002 AND ABS(lng - 8.5264887) < 0.002) OR (name LIKE 'Gyoza%' AND ABS(lat - 47.3876919) < 0.0006 AND ABS(lng - 8.5264887) < 0.0008)) AND price_min IS NULL;
-- 74: Gyoza Yokocho (Limmatstrasse 231, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Gyoza Yokocho' AND ABS(lat - 47.3876919) < 0.002 AND ABS(lng - 8.5264887) < 0.002) OR (name LIKE 'Gyoza%' AND ABS(lat - 47.3876919) < 0.0006 AND ABS(lng - 8.5264887) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Gyoza Yokocho', 'Imbiss-Stand, Japanisch', 47.3876919, 8.5264887, 18, 27, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Japanisch') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig'));

UPDATE tbl_place SET price_min = 16, price_max = 25 WHERE ((name = 'Haus am Fluss' AND ABS(lat - 47.388962) < 0.002 AND ABS(lng - 8.527827) < 0.002) OR (name LIKE 'Haus%' AND ABS(lat - 47.388962) < 0.0006 AND ABS(lng - 8.527827) < 0.0008)) AND price_min IS NULL;
-- 75: Haus am Fluss (Sihlquai, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Haus am Fluss' AND ABS(lat - 47.388962) < 0.002 AND ABS(lng - 8.527827) < 0.002) OR (name LIKE 'Haus%' AND ABS(lat - 47.388962) < 0.0006 AND ABS(lng - 8.527827) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Haus am Fluss', 'Asiatische Food Hall am Sihlquai', 47.388962, 8.527827, 16, 25, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Markthalle') OR (gruppe = 'kueche' AND name = 'Chinesisch') OR (gruppe = 'kueche' AND name = 'Japanisch') OR (gruppe = 'kueche' AND name = 'Vietnamesisch') OR (gruppe = 'praeferenz' AND name = 'Mit Sitzplatz'));

UPDATE tbl_place SET price_min = 13, price_max = 18 WHERE ((name = 'Hungry Pita' AND ABS(lat - 47.391572) < 0.002 AND ABS(lng - 8.517016) < 0.002) OR (name LIKE 'Hungry%' AND ABS(lat - 47.391572) < 0.0006 AND ABS(lng - 8.517016) < 0.0008)) AND price_min IS NULL;
-- 76: Hungry Pita (Toni-Areal, Förrlibuckstrasse 149, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Hungry Pita' AND ABS(lat - 47.391572) < 0.002 AND ABS(lng - 8.517016) < 0.002) OR (name LIKE 'Hungry%' AND ABS(lat - 47.391572) < 0.0006 AND ABS(lng - 8.517016) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Hungry Pita', 'Pitas mit Fleisch, Poulet, Falafel, veganem Seitan', 47.391572, 8.517016, 13, 18, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 2 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Food Truck') OR (gruppe = 'kueche' AND name = 'Israelisch') OR (gruppe = 'gericht' AND name = 'Pita') OR (gruppe = 'gericht' AND name = 'Bowls') OR (gruppe = 'gericht' AND name = 'Falafel') OR (gruppe = 'praeferenz' AND name = 'Vegan'));

UPDATE tbl_place SET price_min = 10, price_max = 15 WHERE ((name = 'Il Pentagramma' AND ABS(lat - 47.3811064) < 0.002 AND ABS(lng - 8.5336844) < 0.002) OR (name LIKE 'Il%' AND ABS(lat - 47.3811064) < 0.0006 AND ABS(lng - 8.5336844) < 0.0008)) AND price_min IS NULL;
-- 77: Il Pentagramma (Josefstrasse 28, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Il Pentagramma' AND ABS(lat - 47.3811064) < 0.002 AND ABS(lng - 8.5336844) < 0.002) OR (name LIKE 'Il%' AND ABS(lat - 47.3811064) < 0.0006 AND ABS(lng - 8.5336844) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Il Pentagramma', 'Panini-Institution an der Josefstrasse', 47.3811064, 8.5336844, 10, 15, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Italienisch') OR (gruppe = 'gericht' AND name = 'Sandwiches') OR (gruppe = 'gericht' AND name = 'Panini') OR (gruppe = 'praeferenz' AND name = 'Online bestellen') OR (gruppe = 'praeferenz' AND name = 'Frisch') OR (gruppe = 'praeferenz' AND name = 'Kartenzahlung') OR (gruppe = 'praeferenz' AND name = 'Unter CHF 15'));

UPDATE tbl_place SET price_min = 15, price_max = 20 WHERE ((name = 'India Street Food' AND ABS(lat - 47.3831518) < 0.002 AND ABS(lng - 8.530162) < 0.002) OR (name LIKE 'India%' AND ABS(lat - 47.3831518) < 0.0006 AND ABS(lng - 8.530162) < 0.0008)) AND price_min IS NULL;
-- 78: India Street Food (Langstrasse, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'India Street Food' AND ABS(lat - 47.3831518) < 0.002 AND ABS(lng - 8.530162) < 0.002) OR (name LIKE 'India%' AND ABS(lat - 47.3831518) < 0.0006 AND ABS(lng - 8.530162) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'India Street Food', 'Samosas, Kottu Roti, Currys', 47.3831518, 8.530162, 15, 20, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Indisch') OR (gruppe = 'kueche' AND name = 'Sri Lankisch') OR (gruppe = 'gericht' AND name = 'Curry') OR (gruppe = 'gericht' AND name = 'Kottu Roti') OR (gruppe = 'gericht' AND name = 'Samosa') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'Juicery21' AND ABS(lat - 47.3852864) < 0.002 AND ABS(lng - 8.5192736) < 0.002) OR (name LIKE 'Juicery21%' AND ABS(lat - 47.3852864) < 0.0006 AND ABS(lng - 8.5192736) < 0.0008)) AND price_min IS NULL;
-- 79: Juicery21 (Geroldstrasse 23, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Juicery21' AND ABS(lat - 47.3852864) < 0.002 AND ABS(lng - 8.5192736) < 0.002) OR (name LIKE 'Juicery21%' AND ABS(lat - 47.3852864) < 0.0006 AND ABS(lng - 8.5192736) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Juicery21', 'Imbiss-Stand', 47.3852864, 8.5192736, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand'));

UPDATE tbl_place SET price_min = 19, price_max = 23 WHERE ((name = 'kaisin' AND ABS(lat - 47.3875609) < 0.002 AND ABS(lng - 8.5190573) < 0.002) OR (name LIKE 'kaisin%' AND ABS(lat - 47.3875609) < 0.0006 AND ABS(lng - 8.5190573) < 0.0008)) AND price_min IS NULL;
-- 80: kaisin (Hardstrasse 235, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'kaisin' AND ABS(lat - 47.3875609) < 0.002 AND ABS(lng - 8.5190573) < 0.002) OR (name LIKE 'kaisin%' AND ABS(lat - 47.3875609) < 0.0006 AND ABS(lng - 8.5190573) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'kaisin', 'Imbiss-Stand', 47.3875609, 8.5190573, 19, 23, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'praeferenz' AND name = 'Vegan') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'Kantine im 5i' AND ABS(lat - 47.3867746) < 0.002 AND ABS(lng - 8.5207474) < 0.002) OR (name LIKE 'Kantine%' AND ABS(lat - 47.3867746) < 0.0006 AND ABS(lng - 8.5207474) < 0.0008)) AND price_min IS NULL;
-- 81: Kantine im 5i (Neue Hard, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Kantine im 5i' AND ABS(lat - 47.3867746) < 0.002 AND ABS(lng - 8.5207474) < 0.002) OR (name LIKE 'Kantine%' AND ABS(lat - 47.3867746) < 0.0006 AND ABS(lng - 8.5207474) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Kantine im 5i', 'Imbiss-Stand', 47.3867746, 8.5207474, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen'));

UPDATE tbl_place SET price_min = 16, price_max = 23 WHERE ((name = 'Kitchen Republic' AND ABS(lat - 47.3889173) < 0.002 AND ABS(lng - 8.5222924) < 0.002) OR (name LIKE 'Kitchen%' AND ABS(lat - 47.3889173) < 0.0006 AND ABS(lng - 8.5222924) < 0.0008)) AND price_min IS NULL;
-- 82: Kitchen Republic (Heinrichstrasse 239, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Kitchen Republic' AND ABS(lat - 47.3889173) < 0.002 AND ABS(lng - 8.5222924) < 0.002) OR (name LIKE 'Kitchen%' AND ABS(lat - 47.3889173) < 0.0006 AND ABS(lng - 8.5222924) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Kitchen Republic', 'Food Hall: Sushi, Wok, Burger, Korean Chicken', 47.3889173, 8.5222924, 16, 23, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Markthalle') OR (gruppe = 'kueche' AND name = 'Amerikanisch') OR (gruppe = 'kueche' AND name = 'Asiatisch') OR (gruppe = 'kueche' AND name = 'Hawaiianisch') OR (gruppe = 'kueche' AND name = 'Japanisch') OR (gruppe = 'kueche' AND name = 'Koreanisch') OR (gruppe = 'gericht' AND name = 'Burger') OR (gruppe = 'gericht' AND name = 'Dim Sum') OR (gruppe = 'gericht' AND name = 'Poke') OR (gruppe = 'gericht' AND name = 'Sushi') OR (gruppe = 'gericht' AND name = 'Nudeln') OR (gruppe = 'gericht' AND name = 'Poulet / Fried Chicken') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen') OR (gruppe = 'praeferenz' AND name = 'Lieferung') OR (gruppe = 'praeferenz' AND name = 'Online bestellen') OR (gruppe = 'praeferenz' AND name = 'Mit Sitzplatz'));

UPDATE tbl_place SET price_min = 15, price_max = 20 WHERE ((name = 'Kottu Roti by Loving Lanka' AND ABS(lat - 47.390229) < 0.002 AND ABS(lng - 8.512069) < 0.002) OR (name LIKE 'Kottu%' AND ABS(lat - 47.390229) < 0.0006 AND ABS(lng - 8.512069) < 0.0008)) AND price_min IS NULL;
-- 83: Kottu Roti by Loving Lanka (ZHdK, Pfingstweidstrasse 94, 8005 Zürich / Schiffbau, Hardstrasse 243)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Kottu Roti by Loving Lanka' AND ABS(lat - 47.390229) < 0.002 AND ABS(lng - 8.512069) < 0.002) OR (name LIKE 'Kottu%' AND ABS(lat - 47.390229) < 0.0006 AND ABS(lng - 8.512069) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Kottu Roti by Loving Lanka', 'Kottu Roti, Samosa, Mango-Lassi', 47.390229, 8.512069, 15, 20, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Food Truck') OR (gruppe = 'kueche' AND name = 'Sri Lankisch') OR (gruppe = 'gericht' AND name = 'Kottu Roti') OR (gruppe = 'gericht' AND name = 'Curry') OR (gruppe = 'praeferenz' AND name = 'Scharf'));

UPDATE tbl_place SET price_min = 12, price_max = 17 WHERE ((name = 'La Penisola' AND ABS(lat - 47.3909632) < 0.002 AND ABS(lng - 8.5184954) < 0.002) OR (name LIKE 'La%' AND ABS(lat - 47.3909632) < 0.0006 AND ABS(lng - 8.5184954) < 0.0008)) AND price_min IS NULL;
-- 84: La Penisola (Hardturmstrasse, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'La Penisola' AND ABS(lat - 47.3909632) < 0.002 AND ABS(lng - 8.5184954) < 0.002) OR (name LIKE 'La%' AND ABS(lat - 47.3909632) < 0.0006 AND ABS(lng - 8.5184954) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'La Penisola', 'Imbiss-Stand, Italienisch', 47.3909632, 8.5184954, 12, 17, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Italienisch') OR (gruppe = 'gericht' AND name = 'Piadina') OR (gruppe = 'gericht' AND name = 'Pizza') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig'));

UPDATE tbl_place SET price_min = 18, price_max = 24 WHERE ((name = 'Lemon Grass' AND ABS(lat - 47.3868062) < 0.002 AND ABS(lng - 8.5284121) < 0.002) OR (name LIKE 'Lemon%' AND ABS(lat - 47.3868062) < 0.0006 AND ABS(lng - 8.5284121) < 0.0008)) AND price_min IS NULL;
-- 85: Lemon Grass (Limmatstrasse, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Lemon Grass' AND ABS(lat - 47.3868062) < 0.002 AND ABS(lng - 8.5284121) < 0.002) OR (name LIKE 'Lemon%' AND ABS(lat - 47.3868062) < 0.0006 AND ABS(lng - 8.5284121) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Lemon Grass', 'Imbiss-Stand, Thailändisch', 47.3868062, 8.5284121, 18, 24, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Thailändisch') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch'));

UPDATE tbl_place SET price_min = 15, price_max = 22 WHERE ((name = 'Libanon il-Achdar' AND ABS(lat - 47.380844) < 0.002 AND ABS(lng - 8.5347582) < 0.002) OR (name LIKE 'Libanon%' AND ABS(lat - 47.380844) < 0.0006 AND ABS(lng - 8.5347582) < 0.0008)) AND price_min IS NULL;
-- 86: Libanon il-Achdar ()
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Libanon il-Achdar' AND ABS(lat - 47.380844) < 0.002 AND ABS(lng - 8.5347582) < 0.002) OR (name LIKE 'Libanon%' AND ABS(lat - 47.380844) < 0.0006 AND ABS(lng - 8.5347582) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Libanon il-Achdar', 'Imbiss-Stand, Libanesisch', 47.380844, 8.5347582, 15, 22, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Libanesisch'));

UPDATE tbl_place SET price_min = 17, price_max = 24 WHERE ((name = 'Loving Lanka' AND ABS(lat - 47.390229) < 0.002 AND ABS(lng - 8.512069) < 0.002) OR (name LIKE 'Loving%' AND ABS(lat - 47.390229) < 0.0006 AND ABS(lng - 8.512069) < 0.0008)) AND price_min IS NULL;
-- 87: Loving Lanka (ZHdK, Pfingstweidstrasse 94, 8005 Zürich / Schiffbau, Hardstrasse 243)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Loving Lanka' AND ABS(lat - 47.390229) < 0.002 AND ABS(lng - 8.512069) < 0.002) OR (name LIKE 'Loving%' AND ABS(lat - 47.390229) < 0.0006 AND ABS(lng - 8.512069) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Loving Lanka', 'Scharfe tamilische Currys mit Reis, auch vegan', 47.390229, 8.512069, 17, 24, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 2 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Food Truck') OR (gruppe = 'kueche' AND name = 'Sri Lankisch') OR (gruppe = 'gericht' AND name = 'Curry') OR (gruppe = 'praeferenz' AND name = 'Scharf') OR (gruppe = 'praeferenz' AND name = 'Vegan'));

UPDATE tbl_place SET price_min = 17, price_max = 24 WHERE ((name = 'Lucky''s Thai Food' AND ABS(lat - 47.390504) < 0.002 AND ABS(lng - 8.512049) < 0.002) OR (name LIKE 'Lucky''s%' AND ABS(lat - 47.390504) < 0.0006 AND ABS(lng - 8.512049) < 0.0008)) AND price_min IS NULL;
-- 88: Lucky's Thai Food (Toni-Areal, Pfingstweidstrasse 96, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Lucky''s Thai Food' AND ABS(lat - 47.390504) < 0.002 AND ABS(lng - 8.512049) < 0.002) OR (name LIKE 'Lucky''s%' AND ABS(lat - 47.390504) < 0.0006 AND ABS(lng - 8.512049) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Lucky''s Thai Food', 'Thai Street Food, Wochenmenü wechselt', 47.390504, 8.512049, 17, 24, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Food Truck') OR (gruppe = 'kueche' AND name = 'Thailändisch') OR (gruppe = 'gericht' AND name = 'Curry'));

UPDATE tbl_place SET price_min = 12, price_max = 17 WHERE ((name = 'Markaz Döner & Falafel' AND ABS(lat - 47.3874455) < 0.002 AND ABS(lng - 8.5196693) < 0.002) OR (name LIKE 'Markaz%' AND ABS(lat - 47.3874455) < 0.0006 AND ABS(lng - 8.5196693) < 0.0008)) AND price_min IS NULL;
-- 89: Markaz Döner & Falafel (Hardstrasse 238, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Markaz Döner & Falafel' AND ABS(lat - 47.3874455) < 0.002 AND ABS(lng - 8.5196693) < 0.002) OR (name LIKE 'Markaz%' AND ABS(lat - 47.3874455) < 0.0006 AND ABS(lng - 8.5196693) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Markaz Döner & Falafel', 'Imbiss-Stand, Türkisch', 47.3874455, 8.5196693, 12, 17, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Türkisch') OR (gruppe = 'gericht' AND name = 'Kebab') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen'));

UPDATE tbl_place SET price_min = 10, price_max = 12 WHERE ((name = 'Marronistand' AND ABS(lat - 47.3858981) < 0.002 AND ABS(lng - 8.51772) < 0.002) OR (name LIKE 'Marronistand%' AND ABS(lat - 47.3858981) < 0.0006 AND ABS(lng - 8.51772) < 0.0008)) AND price_min IS NULL;
-- 90: Marronistand (Hardbrücke, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Marronistand' AND ABS(lat - 47.3858981) < 0.002 AND ABS(lng - 8.51772) < 0.002) OR (name LIKE 'Marronistand%' AND ABS(lat - 47.3858981) < 0.0006 AND ABS(lng - 8.51772) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Marronistand', 'Heisse Marroni (Saison Herbst/Winter)', 47.3858981, 8.51772, 10, 12, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Marktstand') OR (gruppe = 'kueche' AND name = 'Schweizer') OR (gruppe = 'gericht' AND name = 'Marroni') OR (gruppe = 'praeferenz' AND name = 'Vegan') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig'));

UPDATE tbl_place SET price_min = 10, price_max = 15 WHERE ((name = 'Mensa Molki (Toni-Areal)' AND ABS(lat - 47.390504) < 0.002 AND ABS(lng - 8.512049) < 0.002) OR (name LIKE 'Mensa%' AND ABS(lat - 47.390504) < 0.0006 AND ABS(lng - 8.512049) < 0.0008)) AND price_min IS NULL;
-- 91: Mensa Molki (Toni-Areal) (Pfingstweidstrasse 96, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Mensa Molki (Toni-Areal)' AND ABS(lat - 47.390504) < 0.002 AND ABS(lng - 8.512049) < 0.002) OR (name LIKE 'Mensa%' AND ABS(lat - 47.390504) < 0.0006 AND ABS(lng - 8.512049) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Mensa Molki (Toni-Areal)', 'Mensa ZHdK/ZHAW: Menüs, Suppe, Salatbuffet', 47.390504, 8.512049, 10, 15, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Mensa') OR (gruppe = 'kueche' AND name = 'Schweizer') OR (gruppe = 'gericht' AND name = 'Salate') OR (gruppe = 'gericht' AND name = 'Suppen') OR (gruppe = 'praeferenz' AND name = 'Mittagsmenü') OR (gruppe = 'praeferenz' AND name = 'Studentenrabatt') OR (gruppe = 'praeferenz' AND name = 'Mit Sitzplatz'));

UPDATE tbl_place SET price_min = 16, price_max = 23 WHERE ((name = 'Mundo del Gusto' AND ABS(lat - 47.390504) < 0.002 AND ABS(lng - 8.512049) < 0.002) OR (name LIKE 'Mundo%' AND ABS(lat - 47.390504) < 0.0006 AND ABS(lng - 8.512049) < 0.0008)) AND price_min IS NULL;
-- 92: Mundo del Gusto (Toni-Areal, Pfingstweidstrasse 96, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Mundo del Gusto' AND ABS(lat - 47.390504) < 0.002 AND ABS(lng - 8.512049) < 0.002) OR (name LIKE 'Mundo%' AND ABS(lat - 47.390504) < 0.0006 AND ABS(lng - 8.512049) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Mundo del Gusto', 'Burger, Pommes, Wochenspecial', 47.390504, 8.512049, 16, 23, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 4 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Food Truck') OR (gruppe = 'kueche' AND name = 'Amerikanisch') OR (gruppe = 'gericht' AND name = 'Burger'));

UPDATE tbl_place SET price_min = 17, price_max = 25 WHERE ((name = 'Napulé' AND ABS(lat - 47.382953) < 0.002 AND ABS(lng - 8.5307653) < 0.002) OR (name LIKE 'Napulé%' AND ABS(lat - 47.382953) < 0.0006 AND ABS(lng - 8.5307653) < 0.0008)) AND price_min IS NULL;
-- 93: Napulé (Josefstrasse 89, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Napulé' AND ABS(lat - 47.382953) < 0.002 AND ABS(lng - 8.5307653) < 0.002) OR (name LIKE 'Napulé%' AND ABS(lat - 47.382953) < 0.0006 AND ABS(lng - 8.5307653) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Napulé', 'Neapolitanisches Streetfood, Pizza a portafoglio', 47.382953, 8.5307653, 17, 25, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Italienisch') OR (gruppe = 'gericht' AND name = 'Pizza') OR (gruppe = 'praeferenz' AND name = 'Online bestellen'));

UPDATE tbl_place SET price_min = 17, price_max = 24 WHERE ((name = 'Noodle House' AND ABS(lat - 47.3904158) < 0.002 AND ABS(lng - 8.5173368) < 0.002) OR (name LIKE 'Noodle%' AND ABS(lat - 47.3904158) < 0.0006 AND ABS(lng - 8.5173368) < 0.0008)) AND price_min IS NULL;
-- 94: Noodle House (Turbinenplatz, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Noodle House' AND ABS(lat - 47.3904158) < 0.002 AND ABS(lng - 8.5173368) < 0.002) OR (name LIKE 'Noodle%' AND ABS(lat - 47.3904158) < 0.0006 AND ABS(lng - 8.5173368) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Noodle House', 'Imbiss-Stand, Asiatisch', 47.3904158, 8.5173368, 17, 24, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Asiatisch') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig'));

UPDATE tbl_place SET price_min = 14, price_max = 18 WHERE ((name = 'Phill''s BBQ' AND ABS(lat - 47.390504) < 0.002 AND ABS(lng - 8.512049) < 0.002) OR (name LIKE 'Phill''s%' AND ABS(lat - 47.390504) < 0.0006 AND ABS(lng - 8.512049) < 0.0008)) AND price_min IS NULL;
-- 95: Phill's BBQ (Toni-Areal, Pfingstweidstrasse 96, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Phill''s BBQ' AND ABS(lat - 47.390504) < 0.002 AND ABS(lng - 8.512049) < 0.002) OR (name LIKE 'Phill''s%' AND ABS(lat - 47.390504) < 0.0006 AND ABS(lng - 8.512049) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Phill''s BBQ', 'Ribs, BBQ-Burger, hausgemachte Pommes', 47.390504, 8.512049, 14, 18, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 2 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Food Truck') OR (gruppe = 'kueche' AND name = 'Amerikanisch') OR (gruppe = 'gericht' AND name = 'Burger') OR (gruppe = 'praeferenz' AND name = 'Hausgemacht'));

UPDATE tbl_place SET price_min = 17, price_max = 23 WHERE ((name = 'PHƠ-NA, ASIA take away' AND ABS(lat - 47.3816075) < 0.002 AND ABS(lng - 8.5330316) < 0.002) OR (name LIKE 'PHƠ-NA,%' AND ABS(lat - 47.3816075) < 0.0006 AND ABS(lng - 8.5330316) < 0.0008)) AND price_min IS NULL;
-- 96: PHƠ-NA, ASIA take away (Klingenstrasse, 8031 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'PHƠ-NA, ASIA take away' AND ABS(lat - 47.3816075) < 0.002 AND ABS(lng - 8.5330316) < 0.002) OR (name LIKE 'PHƠ-NA,%' AND ABS(lat - 47.3816075) < 0.0006 AND ABS(lng - 8.5330316) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'PHƠ-NA, ASIA take away', 'Imbiss-Stand, Vietnamesisch', 47.3816075, 8.5330316, 17, 23, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Vietnamesisch') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen'));

UPDATE tbl_place SET price_min = 16, price_max = 23 WHERE ((name = 'Pinky Burgers' AND ABS(lat - 47.3855172) < 0.002 AND ABS(lng - 8.5187434) < 0.002) OR (name LIKE 'Pinky%' AND ABS(lat - 47.3855172) < 0.0006 AND ABS(lng - 8.5187434) < 0.0008)) AND price_min IS NULL;
-- 97: Pinky Burgers (Geroldstrasse 27, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Pinky Burgers' AND ABS(lat - 47.3855172) < 0.002 AND ABS(lng - 8.5187434) < 0.002) OR (name LIKE 'Pinky%' AND ABS(lat - 47.3855172) < 0.0006 AND ABS(lng - 8.5187434) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Pinky Burgers', 'Halal-Burger-Take-away', 47.3855172, 8.5187434, 16, 23, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Take-away-Stand') OR (gruppe = 'gericht' AND name = 'Burger') OR (gruppe = 'gericht' AND name = 'Poulet / Fried Chicken') OR (gruppe = 'praeferenz' AND name = 'Halal'));

UPDATE tbl_place SET price_min = 17, price_max = 25 WHERE ((name = 'Rucola Pizza' AND ABS(lat - 47.3940196) < 0.002 AND ABS(lng - 8.5057893) < 0.002) OR (name LIKE 'Rucola%' AND ABS(lat - 47.3940196) < 0.0006 AND ABS(lng - 8.5057893) < 0.0008)) AND price_min IS NULL;
-- 98: Rucola Pizza (Hardturmstrasse 394, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Rucola Pizza' AND ABS(lat - 47.3940196) < 0.002 AND ABS(lng - 8.5057893) < 0.002) OR (name LIKE 'Rucola%' AND ABS(lat - 47.3940196) < 0.0006 AND ABS(lng - 8.5057893) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Rucola Pizza', 'Imbiss-Stand, Italienisch', 47.3940196, 8.5057893, 17, 25, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Italienisch') OR (gruppe = 'gericht' AND name = 'Pasta') OR (gruppe = 'gericht' AND name = 'Pizza') OR (gruppe = 'praeferenz' AND name = 'Lieferung'));

UPDATE tbl_place SET price_min = 16, price_max = 26 WHERE ((name = 'San San' AND ABS(lat - 47.3815978) < 0.002 AND ABS(lng - 8.5298851) < 0.002) OR (name LIKE 'San%' AND ABS(lat - 47.3815978) < 0.0006 AND ABS(lng - 8.5298851) < 0.0008)) AND price_min IS NULL;
-- 99: San San (Zollstrasse, 8031 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'San San' AND ABS(lat - 47.3815978) < 0.002 AND ABS(lng - 8.5298851) < 0.002) OR (name LIKE 'San%' AND ABS(lat - 47.3815978) < 0.0006 AND ABS(lng - 8.5298851) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'San San', 'Imbiss-Stand, Japanisch', 47.3815978, 8.5298851, 16, 26, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Japanisch') OR (gruppe = 'gericht' AND name = 'Sushi'));

UPDATE tbl_place SET price_min = 18, price_max = 24 WHERE ((name = 'Spoon' AND ABS(lat - 47.390961) < 0.002 AND ABS(lng - 8.508666) < 0.002) OR (name LIKE 'Spoon%' AND ABS(lat - 47.390961) < 0.0006 AND ABS(lng - 8.508666) < 0.0008)) AND price_min IS NULL;
-- 100: Spoon (Pfingstweidstrasse 104a, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Spoon' AND ABS(lat - 47.390961) < 0.002 AND ABS(lng - 8.508666) < 0.002) OR (name LIKE 'Spoon%' AND ABS(lat - 47.390961) < 0.0006 AND ABS(lng - 8.508666) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Spoon', 'Täglich rund zehn frische Thai-Gerichte', 47.390961, 8.508666, 18, 24, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Take-away-Stand') OR (gruppe = 'kueche' AND name = 'Thailändisch') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig') OR (gruppe = 'praeferenz' AND name = 'Draussen sitzen') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch') OR (gruppe = 'praeferenz' AND name = 'Mittagsmenü'));

UPDATE tbl_place SET price_min = 14, price_max = 20 WHERE ((name = 'Tacos Plaza' AND ABS(lat - 47.3902549) < 0.002 AND ABS(lng - 8.5230371) < 0.002) OR (name LIKE 'Tacos%' AND ABS(lat - 47.3902549) < 0.0006 AND ABS(lng - 8.5230371) < 0.0008)) AND price_min IS NULL;
-- 101: Tacos Plaza (Limmatstrasse 317, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Tacos Plaza' AND ABS(lat - 47.3902549) < 0.002 AND ABS(lng - 8.5230371) < 0.002) OR (name LIKE 'Tacos%' AND ABS(lat - 47.3902549) < 0.0006 AND ABS(lng - 8.5230371) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Tacos Plaza', 'Imbiss-Stand, Mexikanisch', 47.3902549, 8.5230371, 14, 20, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Mexikanisch') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch'));

UPDATE tbl_place SET price_min = 14, price_max = 20 WHERE ((name = 'Tenz Momo Foodtruck' AND ABS(lat - 47.38823) < 0.002 AND ABS(lng - 8.519562) < 0.002) OR (name LIKE 'Tenz%' AND ABS(lat - 47.38823) < 0.0006 AND ABS(lng - 8.519562) < 0.0008)) AND price_min IS NULL;
-- 102: Tenz Momo Foodtruck (EXIL, Hardstrasse 245, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Tenz Momo Foodtruck' AND ABS(lat - 47.38823) < 0.002 AND ABS(lng - 8.519562) < 0.002) OR (name LIKE 'Tenz%' AND ABS(lat - 47.38823) < 0.0006 AND ABS(lng - 8.519562) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Tenz Momo Foodtruck', 'Foodtruck der Momo-Kette Tenz', 47.38823, 8.519562, 14, 20, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 3 w, 'noon' s UNION ALL SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Food Truck') OR (gruppe = 'kueche' AND name = 'Tibetisch') OR (gruppe = 'gericht' AND name = 'Momos') OR (gruppe = 'praeferenz' AND name = 'Vegan') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch'));

UPDATE tbl_place SET price_min = 10, price_max = 15 WHERE ((name = 'The Bagel Shop' AND ABS(lat - 47.3871303) < 0.002 AND ABS(lng - 8.5246109) < 0.002) OR (name LIKE 'The%' AND ABS(lat - 47.3871303) < 0.0006 AND ABS(lng - 8.5246109) < 0.0008)) AND price_min IS NULL;
-- 103: The Bagel Shop (Viaduktstrasse 33, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'The Bagel Shop' AND ABS(lat - 47.3871303) < 0.002 AND ABS(lng - 8.5246109) < 0.002) OR (name LIKE 'The%' AND ABS(lat - 47.3871303) < 0.0006 AND ABS(lng - 8.5246109) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'The Bagel Shop', 'Frische Bagels, z.B. Sesam mit Frischkäse', 47.3871303, 8.5246109, 10, 15, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'morning' s UNION ALL SELECT 0 w, 'noon' s UNION ALL SELECT 1 w, 'morning' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 2 w, 'morning' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 3 w, 'morning' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 4 w, 'morning' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 5 w, 'morning' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 6 w, 'morning' s UNION ALL SELECT 6 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Take-away-Stand') OR (gruppe = 'gericht' AND name = 'Bagels') OR (gruppe = 'gericht' AND name = 'Sandwiches') OR (gruppe = 'praeferenz' AND name = 'Rollstuhlgängig'));

UPDATE tbl_place SET price_min = 14, price_max = 20 WHERE ((name = 'Topden' AND ABS(lat - 47.391572) < 0.002 AND ABS(lng - 8.517016) < 0.002) OR (name LIKE 'Topden%' AND ABS(lat - 47.391572) < 0.0006 AND ABS(lng - 8.517016) < 0.0008)) AND price_min IS NULL;
-- 104: Topden (Toni-Areal, Förrlibuckstrasse 149, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Topden' AND ABS(lat - 47.391572) < 0.002 AND ABS(lng - 8.517016) < 0.002) OR (name LIKE 'Topden%' AND ABS(lat - 47.391572) < 0.0006 AND ABS(lng - 8.517016) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Topden', 'Momos und Bowls', 47.391572, 8.517016, 14, 20, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 5 w, 'noon' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Food Truck') OR (gruppe = 'kueche' AND name = 'Tibetisch') OR (gruppe = 'gericht' AND name = 'Momos') OR (gruppe = 'gericht' AND name = 'Bowls'));

UPDATE tbl_place SET price_min = 13, price_max = 18 WHERE ((name = 'Vegitat' AND ABS(lat - 47.3822487) < 0.002 AND ABS(lng - 8.5296459) < 0.002) OR (name LIKE 'Vegitat%' AND ABS(lat - 47.3822487) < 0.0006 AND ABS(lng - 8.5296459) < 0.0008)) AND price_min IS NULL;
-- 105: Vegitat (Langstrasse 192, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Vegitat' AND ABS(lat - 47.3822487) < 0.002 AND ABS(lng - 8.5296459) < 0.002) OR (name LIKE 'Vegitat%' AND ABS(lat - 47.3822487) < 0.0006 AND ABS(lng - 8.5296459) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Vegitat', 'Imbiss-Stand, Türkisch', 47.3822487, 8.5296459, 13, 18, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Türkisch') OR (gruppe = 'gericht' AND name = 'Cig Köfte') OR (gruppe = 'gericht' AND name = 'Kebab') OR (gruppe = 'praeferenz' AND name = 'Vegan'));

UPDATE tbl_place SET price_min = 17, price_max = 25 WHERE ((name = 'Vito' AND ABS(lat - 47.3848528) < 0.002 AND ABS(lng - 8.5322457) < 0.002) OR (name LIKE 'Vito%' AND ABS(lat - 47.3848528) < 0.0006 AND ABS(lng - 8.5322457) < 0.0008)) AND price_min IS NULL;
-- 106: Vito (Kornhausbrücke 4, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Vito' AND ABS(lat - 47.3848528) < 0.002 AND ABS(lng - 8.5322457) < 0.002) OR (name LIKE 'Vito%' AND ABS(lat - 47.3848528) < 0.0006 AND ABS(lng - 8.5322457) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Vito', 'Imbiss-Stand, Italienisch', 47.3848528, 8.5322457, 17, 25, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT INTO tbl_place_opening (place_id, weekday, slot)
  SELECT @p, w, s FROM (SELECT 0 w, 'noon' s UNION ALL SELECT 0 w, 'evening' s UNION ALL SELECT 1 w, 'noon' s UNION ALL SELECT 1 w, 'evening' s UNION ALL SELECT 2 w, 'noon' s UNION ALL SELECT 2 w, 'evening' s UNION ALL SELECT 3 w, 'noon' s UNION ALL SELECT 3 w, 'evening' s UNION ALL SELECT 4 w, 'noon' s UNION ALL SELECT 4 w, 'evening' s UNION ALL SELECT 5 w, 'noon' s UNION ALL SELECT 5 w, 'evening' s UNION ALL SELECT 6 w, 'noon' s UNION ALL SELECT 6 w, 'evening' s) t WHERE @p IS NOT NULL;
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'kueche' AND name = 'Italienisch') OR (gruppe = 'gericht' AND name = 'Pizza') OR (gruppe = 'praeferenz' AND name = 'Vegan') OR (gruppe = 'praeferenz' AND name = 'Vegetarisch'));

UPDATE tbl_place SET price_min = 13, price_max = 18 WHERE ((name = 'Wurst & Moritz' AND ABS(lat - 47.390772) < 0.002 AND ABS(lng - 8.52244) < 0.002) OR (name LIKE 'Wurst%' AND ABS(lat - 47.390772) < 0.0006 AND ABS(lng - 8.52244) < 0.0008)) AND price_min IS NULL;
-- 107: Wurst & Moritz (Escher-Wyss-Platz, 8005 Zürich)
SET @neu = NOT EXISTS (SELECT 1 FROM tbl_place WHERE ((name = 'Wurst & Moritz' AND ABS(lat - 47.390772) < 0.002 AND ABS(lng - 8.52244) < 0.002) OR (name LIKE 'Wurst%' AND ABS(lat - 47.390772) < 0.0006 AND ABS(lng - 8.52244) < 0.0008)));
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, price_min, price_max, create_time)
  SELECT @user_id, NULL, 'Wurst & Moritz', 'Currywurst-Imbiss', 47.390772, 8.52244, 13, 18, NOW() FROM DUAL WHERE @neu;
SET @p = IF(@neu, LAST_INSERT_ID(), NULL);
INSERT IGNORE INTO tbl_place_category (place_id, category_id)
  SELECT @p, id FROM tbl_category WHERE @p IS NOT NULL AND ((gruppe = 'art' AND name = 'Imbiss-Stand') OR (gruppe = 'gericht' AND name = 'Wurst / Currywurst') OR (gruppe = 'gericht' AND name = 'Hot Dogs'));

COMMIT;
