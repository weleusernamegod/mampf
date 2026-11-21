-- =====================================================================
-- mampf: Datenbank-Umstellung November 2026
-- Anleitung: data/MIGRATION.md (vorher unbedingt eine Sicherung machen!)
--
-- Nur EINMAL ausführen. Bei einem Fehler: Sicherung wieder einspielen.
-- =====================================================================

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- Teil 1: Öffnungszeiten als Matrix (7 Wochentage × Morgen/Mittag/Abend)
-- ---------------------------------------------------------------------

-- Eine Zeile pro Kreuz. weekday wie in JavaScript: 0 = Sonntag, 1 = Montag, … 6 = Samstag
CREATE TABLE `tbl_place_opening` (
  `place_id` int(11) NOT NULL,
  `weekday` tinyint(4) NOT NULL,
  `slot` enum('morning','noon','evening') NOT NULL,
  PRIMARY KEY (`place_id`, `weekday`, `slot`),
  CONSTRAINT `fk_opening_place` FOREIGN KEY (`place_id`) REFERENCES `tbl_place` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Übernahme: heutige Tage × Tageszeiten -> Kreuze. "Nacht" fällt weg.
INSERT INTO `tbl_place_opening` (`place_id`, `weekday`, `slot`)
SELECT p.id, d.weekday, s.slot
FROM tbl_place p
CROSS JOIN (SELECT 0 AS weekday UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
            UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6) d
CROSS JOIN (SELECT 'morning' AS slot UNION ALL SELECT 'noon' UNION ALL SELECT 'evening') s
WHERE (CASE d.weekday
         WHEN 0 THEN p.open_sunday   WHEN 1 THEN p.open_monday
         WHEN 2 THEN p.open_tuesday  WHEN 3 THEN p.open_wednesday
         WHEN 4 THEN p.open_thursday WHEN 5 THEN p.open_friday
         WHEN 6 THEN p.open_saturday END) = 1
  AND (CASE s.slot
         WHEN 'morning' THEN p.open_morning
         WHEN 'noon'    THEN p.open_noon
         WHEN 'evening' THEN p.open_evening END) = 1;

-- Die alten Spalten werden nicht mehr gebraucht
ALTER TABLE `tbl_place`
  DROP COLUMN `open_sunday`,
  DROP COLUMN `open_monday`,
  DROP COLUMN `open_tuesday`,
  DROP COLUMN `open_wednesday`,
  DROP COLUMN `open_thursday`,
  DROP COLUMN `open_friday`,
  DROP COLUMN `open_saturday`,
  DROP COLUMN `open_morning`,
  DROP COLUMN `open_noon`,
  DROP COLUMN `open_evening`,
  DROP COLUMN `open_night`;

-- ---------------------------------------------------------------------
-- Teil 2: Mehrere Standorte (Foodtrucks)
-- Leer = der normale Standort (tbl_place.lat/lng) gilt. Bestehende Orte
-- bleiben also unverändert.
-- ---------------------------------------------------------------------

CREATE TABLE `tbl_place_location` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `place_id` int(11) NOT NULL,
  `weekday` tinyint(4) NOT NULL,
  `lat` double NOT NULL,
  `lng` double NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_location_place` (`place_id`, `weekday`),
  CONSTRAINT `fk_location_place` FOREIGN KEY (`place_id`) REFERENCES `tbl_place` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ---------------------------------------------------------------------
-- Teil 3: Kategorien
-- Gruppen: art (Art des Lokals, genau eine), kueche, gericht,
-- praeferenz (mehrere), wartezeit (genau eine). Die Namen der Gruppen
-- stehen in api/category/category-repository.php.
-- ---------------------------------------------------------------------

CREATE TABLE `tbl_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gruppe` varchar(30) NOT NULL,
  `name` varchar(50) NOT NULL,
  `reihenfolge` int(11) NOT NULL DEFAULT 0,
  `aktiv` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_gruppe_name` (`gruppe`, `name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `tbl_place_category` (
  `place_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  PRIMARY KEY (`place_id`, `category_id`),
  KEY `fk_place_category_category` (`category_id`),
  CONSTRAINT `fk_place_category_place` FOREIGN KEY (`place_id`) REFERENCES `tbl_place` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_place_category_category` FOREIGN KEY (`category_id`) REFERENCES `tbl_category` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tbl_category` (`gruppe`, `name`, `reihenfolge`) VALUES
  ('art', 'Food Truck', 10),
  ('art', 'Imbiss', 20),
  ('art', 'Marktstand', 30),
  ('art', 'Take-away', 40),
  ('art', 'Mensa', 50),
  ('art', 'Personalrestaurant', 60),
  ('art', 'Bäckerei', 70),
  ('art', 'Café', 80),
  ('art', 'Deli', 90),
  ('art', 'Metzgerei', 100),
  ('art', 'Supermarkt', 110),
  ('art', 'Food Court', 120),
  ('art', 'Restaurant mit Take-away', 130);

INSERT INTO `tbl_category` (`gruppe`, `name`, `reihenfolge`) VALUES
  ('kueche', 'Schweizer', 10),
  ('kueche', 'Italienisch', 20),
  ('kueche', 'Französisch', 30),
  ('kueche', 'Spanisch', 40),
  ('kueche', 'Griechisch', 50),
  ('kueche', 'Balkan', 60),
  ('kueche', 'Georgisch', 70),
  ('kueche', 'Türkisch', 80),
  ('kueche', 'Libanesisch', 90),
  ('kueche', 'Persisch', 100),
  ('kueche', 'Israelisch', 110),
  ('kueche', 'Eritreisch', 120),
  ('kueche', 'Indisch', 130),
  ('kueche', 'Sri Lankisch', 140),
  ('kueche', 'Tibetisch', 150),
  ('kueche', 'Chinesisch', 160),
  ('kueche', 'Japanisch', 170),
  ('kueche', 'Koreanisch', 180),
  ('kueche', 'Thailändisch', 190),
  ('kueche', 'Vietnamesisch', 200),
  ('kueche', 'Indonesisch', 210),
  ('kueche', 'Mexikanisch', 220),
  ('kueche', 'Peruanisch', 230),
  ('kueche', 'Brasilianisch', 240),
  ('kueche', 'Amerikanisch', 250),
  ('kueche', 'Hawaiianisch', 260);

INSERT INTO `tbl_category` (`gruppe`, `name`, `reihenfolge`) VALUES
  ('gericht', 'Pizza', 10),
  ('gericht', 'Pasta', 20),
  ('gericht', 'Burger', 30),
  ('gericht', 'Kebab', 40),
  ('gericht', 'Falafel', 50),
  ('gericht', 'Sushi', 60),
  ('gericht', 'Ramen', 70),
  ('gericht', 'Poke', 80),
  ('gericht', 'Bowls', 90),
  ('gericht', 'Salate', 100),
  ('gericht', 'Suppen', 110),
  ('gericht', 'Sandwiches', 120),
  ('gericht', 'Wraps', 130),
  ('gericht', 'Hot Dogs', 140),
  ('gericht', 'Momos', 150),
  ('gericht', 'Banh Mi', 160),
  ('gericht', 'Tacos', 170),
  ('gericht', 'Curry', 180);

INSERT INTO `tbl_category` (`gruppe`, `name`, `reihenfolge`) VALUES
  ('praeferenz', 'Vegan', 10),
  ('praeferenz', 'Vegetarisch', 20),
  ('praeferenz', 'Glutenfrei', 30),
  ('praeferenz', 'Laktosefrei', 40),
  ('praeferenz', 'Halal', 50),
  ('praeferenz', 'Koscher', 60),
  ('praeferenz', 'Bio', 70),
  ('praeferenz', 'Regional', 80),
  ('praeferenz', 'Eigenes Geschirr willkommen', 90),
  ('praeferenz', 'reCIRCLE', 100),
  ('praeferenz', 'Mehrwegtopf', 110),
  ('praeferenz', 'Mittagsmenü', 120),
  ('praeferenz', 'Unter CHF 15', 130),
  ('praeferenz', 'Mit Sitzplatz', 140),
  ('praeferenz', 'Vorbestellung möglich', 150),
  ('praeferenz', 'Gesund', 160),
  ('praeferenz', 'Proteinreich', 170),
  ('praeferenz', 'Frisch', 180),
  ('praeferenz', 'Low Carb', 190),
  ('praeferenz', 'Zuckerfrei', 200),
  ('praeferenz', 'Nussfrei / allergikerfreundlich', 210),
  ('praeferenz', 'Artgerechte Haltung', 220),
  ('praeferenz', 'Nachhaltiger Fisch', 230),
  ('praeferenz', 'Hausgemacht', 240),
  ('praeferenz', 'Scharf', 250),
  ('praeferenz', 'Kinderfreundliche Gerichte', 260),
  ('praeferenz', 'Saisonal', 270),
  ('praeferenz', 'Zero Waste', 280),
  ('praeferenz', 'Too Good To Go', 290),
  ('praeferenz', 'Tagesreste vergünstigt', 300),
  ('praeferenz', 'Elektrisch betrieben', 310),
  ('praeferenz', 'Online bestellen', 320),
  ('praeferenz', 'Lieferung', 330),
  ('praeferenz', 'Kartenzahlung', 340),
  ('praeferenz', 'TWINT', 350),
  ('praeferenz', 'Nur Bargeld', 360),
  ('praeferenz', 'Grosse Portionen', 370),
  ('praeferenz', 'Catering', 380),
  ('praeferenz', 'Gedeckt / wettergeschützt', 390),
  ('praeferenz', 'Draussen sitzen', 400),
  ('praeferenz', 'Mit Aussicht', 410),
  ('praeferenz', 'Rollstuhlgängig', 420),
  ('praeferenz', 'Hunde willkommen', 430),
  ('praeferenz', 'Kinderfreundlich', 440),
  ('praeferenz', 'WC vorhanden', 450),
  ('praeferenz', 'Gratis-Wasser', 460),
  ('praeferenz', 'Ruhig', 470),
  ('praeferenz', 'Treffpunkt', 480),
  ('praeferenz', 'Unter CHF 10', 490),
  ('praeferenz', 'Studentenrabatt', 500),
  ('praeferenz', 'Happy Hour', 510),
  ('praeferenz', 'Kaffee', 520),
  ('praeferenz', 'Bier / Wein', 530),
  ('praeferenz', 'Smoothies', 540),
  ('praeferenz', 'Dessert / Süsses', 550),
  ('praeferenz', 'Frühstück', 560);

INSERT INTO `tbl_category` (`gruppe`, `name`, `reihenfolge`) VALUES
  ('wartezeit', 'Unter 5 Minuten', 10),
  ('wartezeit', '5–15 Minuten', 20),
  ('wartezeit', 'Über 15 Minuten', 30);

-- Einmalige Vorab-Zuordnung: Stichworte in Name und Beschreibung der
-- bestehenden Orte -> Kategorien (ersetzt die alte Stichwort-Testversion
-- der Karte). Danach im Admin-Bereich von Hand nachbessern.
CREATE TABLE `tmp_category_keyword` (
  `gruppe` varchar(30) NOT NULL,
  `name` varchar(50) NOT NULL,
  `keyword` varchar(50) NOT NULL,
  `keyword2` varchar(50) DEFAULT NULL,
  `prio` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tmp_category_keyword` (`gruppe`, `name`, `keyword`, `keyword2`, `prio`) VALUES
  ('kueche', 'Italienisch', 'italien', NULL, 0),
  ('kueche', 'Griechisch', 'griech', NULL, 0),
  ('kueche', 'Griechisch', 'greek', NULL, 0),
  ('kueche', 'Thailändisch', 'thai', NULL, 0),
  ('kueche', 'Indisch', 'indisch', NULL, 0),
  ('kueche', 'Indisch', 'indian', NULL, 0),
  ('kueche', 'Indisch', 'delhi', NULL, 0),
  ('kueche', 'Japanisch', 'japan', NULL, 0),
  ('kueche', 'Vietnamesisch', 'vietnam', NULL, 0),
  ('kueche', 'Vietnamesisch', 'banh mi', NULL, 0),
  ('kueche', 'Tibetisch', 'tibet', NULL, 0),
  ('kueche', 'Tibetisch', 'momo', NULL, 0),
  ('kueche', 'Chinesisch', 'chines', NULL, 0),
  ('kueche', 'Koreanisch', 'korea', NULL, 0),
  ('kueche', 'Mexikanisch', 'mexikan', NULL, 0),
  ('kueche', 'Mexikanisch', 'burrito', NULL, 0),
  ('kueche', 'Mexikanisch', 'taco', NULL, 0),
  ('kueche', 'Türkisch', 'türk', NULL, 0),
  ('kueche', 'Libanesisch', 'liban', NULL, 0),
  ('kueche', 'Eritreisch', 'eritre', NULL, 0),
  ('kueche', 'Schweizer', 'schweiz', NULL, 0),
  ('kueche', 'Persisch', 'persisch', NULL, 0),
  ('kueche', 'Persisch', 'persian', NULL, 0),
  ('kueche', 'Spanisch', 'spanisch', NULL, 0),
  ('kueche', 'Spanisch', 'tapas', NULL, 0),
  ('kueche', 'Französisch', 'französ', NULL, 0),
  ('kueche', 'Georgisch', 'georgisch', NULL, 0),
  ('kueche', 'Israelisch', 'israel', NULL, 0),
  ('kueche', 'Sri Lankisch', 'sri lank', NULL, 0),
  ('kueche', 'Indonesisch', 'indones', NULL, 0),
  ('kueche', 'Peruanisch', 'peruan', NULL, 0),
  ('kueche', 'Brasilianisch', 'brasil', NULL, 0),
  ('kueche', 'Amerikanisch', 'amerikan', NULL, 0),
  ('kueche', 'Hawaiianisch', 'hawai', NULL, 0),
  ('kueche', 'Balkan', 'balkan', NULL, 0),
  ('gericht', 'Pizza', 'pizza', NULL, 0),
  ('gericht', 'Pasta', 'pasta', NULL, 0),
  ('gericht', 'Burger', 'burger', NULL, 0),
  ('gericht', 'Kebab', 'kebab', NULL, 0),
  ('gericht', 'Kebab', 'döner', NULL, 0),
  ('gericht', 'Falafel', 'falafel', NULL, 0),
  ('gericht', 'Sushi', 'sushi', NULL, 0),
  ('gericht', 'Ramen', 'ramen', NULL, 0),
  ('gericht', 'Poke', 'poke', NULL, 0),
  ('gericht', 'Bowls', 'bowl', NULL, 0),
  ('gericht', 'Salate', 'salat', NULL, 0),
  ('gericht', 'Suppen', 'suppe', NULL, 0),
  ('gericht', 'Suppen', 'soup', NULL, 0),
  ('gericht', 'Sandwiches', 'sandwich', NULL, 0),
  ('gericht', 'Wraps', 'wrap', NULL, 0),
  ('gericht', 'Hot Dogs', 'hot dog', NULL, 0),
  ('gericht', 'Hot Dogs', 'hotdog', NULL, 0),
  ('gericht', 'Momos', 'momo', NULL, 0),
  ('gericht', 'Banh Mi', 'banh mi', NULL, 0),
  ('gericht', 'Tacos', 'taco', NULL, 0),
  ('gericht', 'Curry', 'curry', NULL, 0),
  ('praeferenz', 'Vegan', 'vegan', NULL, 0),
  ('praeferenz', 'Vegetarisch', 'vegetar', NULL, 0),
  ('praeferenz', 'Halal', 'halal', NULL, 0),
  ('praeferenz', 'Glutenfrei', 'glutenfrei', NULL, 0),
  ('praeferenz', 'Mittagsmenü', 'mittagsmen', NULL, 0),
  ('art', 'Food Court', 'food hall', NULL, 1),
  ('art', 'Food Court', 'food court', NULL, 1),
  ('art', 'Mensa', 'mensa', NULL, 2),
  ('art', 'Personalrestaurant', 'personalrestaurant', NULL, 3),
  ('art', 'Restaurant mit Take-away', 'restaurant', 'mitnehm', 4),
  ('art', 'Restaurant mit Take-away', 'restaurant', 'take-away', 4),
  ('art', 'Bäckerei', 'bäckerei', NULL, 5),
  ('art', 'Café', 'cafe', NULL, 6),
  ('art', 'Metzgerei', 'metzg', NULL, 7),
  ('art', 'Food Truck', 'food truck', NULL, 8),
  ('art', 'Food Truck', 'foodtruck', NULL, 8),
  ('art', 'Marktstand', 'marktstand', NULL, 9),
  ('art', 'Imbiss', 'imbiss', NULL, 10),
  ('art', 'Imbiss', 'grill', NULL, 10),
  ('art', 'Take-away', 'take-away', NULL, 11),
  ('art', 'Take-away', 'takeaway', NULL, 11),
  ('art', 'Take-away', 'mitnehm', NULL, 11);

-- Küche, Gerichte, Präferenzen: alle passenden
INSERT IGNORE INTO `tbl_place_category` (`place_id`, `category_id`)
SELECT DISTINCT p.id, c.id
FROM tbl_place p
JOIN tmp_category_keyword k ON k.gruppe <> 'art'
JOIN tbl_category c ON c.gruppe = k.gruppe AND c.name = k.name
WHERE CONCAT(p.name, ' ', p.description) LIKE CONCAT('%', k.keyword, '%');

-- Art des Lokals: nur die erste passende (kleinste prio)
INSERT INTO `tbl_place_category` (`place_id`, `category_id`)
SELECT x.place_id, x.category_id
FROM (
  SELECT p.id AS place_id,
    (SELECT c.id
     FROM tmp_category_keyword k
     JOIN tbl_category c ON c.gruppe = k.gruppe AND c.name = k.name
     WHERE k.gruppe = 'art'
       AND CONCAT(p.name, ' ', p.description) LIKE CONCAT('%', k.keyword, '%')
       AND (k.keyword2 IS NULL OR CONCAT(p.name, ' ', p.description) LIKE CONCAT('%', k.keyword2, '%'))
     ORDER BY k.prio
     LIMIT 1) AS category_id
  FROM tbl_place p
) x
WHERE x.category_id IS NOT NULL;

DROP TABLE `tmp_category_keyword`;
