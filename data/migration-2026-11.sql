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
