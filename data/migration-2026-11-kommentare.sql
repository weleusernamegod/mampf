-- Migration Nov. 2026: Kommentare zu Orten und Anzeigename für Nutzer
--  1. tbl_user.name: Anzeigename bei den Kommentaren (die Mail wird nie angezeigt).
--     Wird bei der Registrierung gewählt und kann im Admin-Bereich geändert werden.
--     Bestehende Nutzer haben noch keinen Namen (NULL), bis sie einen setzen.
--  2. tbl_comment: höchstens 130 Zeichen pro Kommentar. Kommentieren nur mit Login.
-- Einmal auf der Datenbank ausführen (lokal und live, z.B. in phpMyAdmin).

SET NAMES utf8mb4;

ALTER TABLE `tbl_user`
  ADD COLUMN `name` varchar(30) DEFAULT NULL AFTER `mail`;

CREATE TABLE `tbl_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `place_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `text` varchar(130) NOT NULL,
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_comment_place` (`place_id`, `create_time`),
  KEY `fk_comment_user` (`user_id`),
  CONSTRAINT `fk_comment_place` FOREIGN KEY (`place_id`) REFERENCES `tbl_place` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_comment_user` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
