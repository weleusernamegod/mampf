-- Import aus data/kandidaten-kreis4.csv: 29 Orte
-- Quelle: OpenStreetMap (© OpenStreetMap-Mitwirkende, ODbL)
-- Besitzer der Einträge: @user_id (live = 2). Orte, die schon existieren
-- (gleicher Name, fast gleiche Position), werden übersprungen.
SET NAMES utf8mb4;
SET @user_id = 2;

INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Addis Ababa', 'Äthiopischer Imbiss', 47.3728883, 8.5280453, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Addis Ababa' AND ABS(lat - 47.3728883) < 0.0005 AND ABS(lng - 8.5280453) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Allegrotto', 'Pizza, Burger, indisch', 47.3776837, 8.5264, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Allegrotto' AND ABS(lat - 47.3776837) < 0.0005 AND ABS(lng - 8.5264) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Bridge', 'Food Hall am HB: Banh Mi, Japanisch, Grill, Pasta, Bäckerei u. a.', 47.3788455, 8.5338299, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Bridge' AND ABS(lat - 47.3788455) < 0.0005 AND ABS(lng - 8.5338299) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Cartel - Crazy Burrito Shack', 'Burritos und Tacos zum Mitnehmen', 47.3764035, 8.5332122, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Cartel - Crazy Burrito Shack' AND ABS(lat - 47.3764035) < 0.0005 AND ABS(lng - 8.5332122) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Delhi House', 'Indischer Imbiss', 47.3774466, 8.5131703, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Delhi House' AND ABS(lat - 47.3774466) < 0.0005 AND ABS(lng - 8.5131703) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Edy''s', 'Kebab', 47.3737038, 8.5300022, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Edy''s' AND ABS(lat - 47.3737038) < 0.0005 AND ABS(lng - 8.5300022) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Fattoush', 'Syrisches Take-away', 47.3715683, 8.5255105, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Fattoush' AND ABS(lat - 47.3715683) < 0.0005 AND ABS(lng - 8.5255105) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Hiltl Sihlpost', 'Vegetarisches Restaurant mit Buffet, auch zum Mitnehmen', 47.3777357, 8.5357174, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Hiltl Sihlpost' AND ABS(lat - 47.3777357) < 0.0005 AND ABS(lng - 8.5357174) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'House of Momos', 'Tibetische Momos zum Mitnehmen', 47.3749982, 8.5258144, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'House of Momos' AND ABS(lat - 47.3749982) < 0.0005 AND ABS(lng - 8.5258144) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'La Capricciosa', 'Italienisches Take-away', 47.3794128, 8.5280071, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'La Capricciosa' AND ABS(lat - 47.3794128) < 0.0005 AND ABS(lng - 8.5280071) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'La Penisola', 'Italienischer Imbiss', 47.3739605, 8.5249794, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'La Penisola' AND ABS(lat - 47.3739605) < 0.0005 AND ABS(lng - 8.5249794) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'La Perla', 'Pizza-Imbiss', 47.3711862, 8.528815, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'La Perla' AND ABS(lat - 47.3711862) < 0.0005 AND ABS(lng - 8.528815) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Oder Wat', 'Deutscher Imbiss', 47.3783341, 8.5286082, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Oder Wat' AND ABS(lat - 47.3783341) < 0.0005 AND ABS(lng - 8.5286082) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Officina dos Sabores', 'Imbiss / Take-away', 47.3791641, 8.527304, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Officina dos Sabores' AND ABS(lat - 47.3791641) < 0.0005 AND ABS(lng - 8.527304) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Oh My Greek', 'Griechischer Imbiss', 47.3742338, 8.5214527, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Oh My Greek' AND ABS(lat - 47.3742338) < 0.0005 AND ABS(lng - 8.5214527) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Oh My Greek!', 'Griechischer Imbiss', 47.379737, 8.5363362, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Oh My Greek!' AND ABS(lat - 47.379737) < 0.0005 AND ABS(lng - 8.5363362) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Palestine Grill', 'Palästinensischer Grill, Falafel', 47.3781481, 8.5269898, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Palestine Grill' AND ABS(lat - 47.3781481) < 0.0005 AND ABS(lng - 8.5269898) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Phuket Thai Food', 'Thai-Imbiss', 47.3802073, 8.5263721, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Phuket Thai Food' AND ABS(lat - 47.3802073) < 0.0005 AND ABS(lng - 8.5263721) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Simply Soup', 'Suppen zum Mitnehmen, auch vegan', 47.3718091, 8.5290154, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Simply Soup' AND ABS(lat - 47.3718091) < 0.0005 AND ABS(lng - 8.5290154) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Spaccio', 'Pizza zum Mitnehmen', 47.376758, 8.5257606, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Spaccio' AND ABS(lat - 47.376758) < 0.0005 AND ABS(lng - 8.5257606) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'SV Mensa', 'Mensa an der Europaallee (SV), wechselnde Mittagsmenüs', 47.3783663, 8.5327943, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'SV Mensa' AND ABS(lat - 47.3783663) < 0.0005 AND ABS(lng - 8.5327943) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Tacos Ramiro y Macario', 'Mexikanische Tacos', 47.3790661, 8.5108789, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Tacos Ramiro y Macario' AND ABS(lat - 47.3790661) < 0.0005 AND ABS(lng - 8.5108789) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Thai Take-Away', 'Thai-Take-away', 47.3726302, 8.5276556, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Thai Take-Away' AND ABS(lat - 47.3726302) < 0.0005 AND ABS(lng - 8.5276556) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Via del gusto 28', 'Italienische Sandwiches', 47.3782124, 8.5325262, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Via del gusto 28' AND ABS(lat - 47.3782124) < 0.0005 AND ABS(lng - 8.5325262) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Weera Pura', 'Curry-Imbiss', 47.3746797, 8.5198775, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Weera Pura' AND ABS(lat - 47.3746797) < 0.0005 AND ABS(lng - 8.5198775) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Wesley''s Kitchen', 'Asiatisches Take-away', 47.3794641, 8.5372186, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Wesley''s Kitchen' AND ABS(lat - 47.3794641) < 0.0005 AND ABS(lng - 8.5372186) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Yalda', 'Imbiss / Take-away', 47.3792529, 8.5311093, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Yalda' AND ABS(lat - 47.3792529) < 0.0005 AND ABS(lng - 8.5311093) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Zuki''s', 'Imbiss / Take-away', 47.3713686, 8.5290453, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Zuki''s' AND ABS(lat - 47.3713686) < 0.0005 AND ABS(lng - 8.5290453) < 0.0005);
INSERT INTO tbl_place (user_id, picture_id, name, description, lat, lng, open_monday, open_tuesday, open_wednesday, open_thursday, open_friday, open_saturday, open_sunday, open_morning, open_noon, open_evening, open_night, create_time)
  SELECT @user_id, NULL, 'Zum goldenen Taschenbrot', 'Kebab im Taschenbrot', 47.3788366, 8.5291393, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, NOW()
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM tbl_place WHERE name = 'Zum goldenen Taschenbrot' AND ABS(lat - 47.3788366) < 0.0005 AND ABS(lng - 8.5291393) < 0.0005);
