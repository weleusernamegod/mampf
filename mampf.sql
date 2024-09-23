-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 22. Sep 2024 um 22:27
-- Server-Version: 10.4.32-MariaDB
-- PHP-Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `mampf`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tbl_picture`
--

CREATE TABLE `tbl_picture` (
  `id` int(11) NOT NULL,
  `data` mediumblob NOT NULL,
  `type` varchar(255) NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tbl_place`
--

CREATE TABLE `tbl_place` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `picture_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `lat` double NOT NULL,
  `lng` double NOT NULL,
  `open_sunday` tinyint(4) NOT NULL,
  `open_monday` tinyint(4) NOT NULL,
  `open_tuesday` tinyint(4) NOT NULL,
  `open_wednesday` tinyint(4) NOT NULL,
  `open_thursday` tinyint(4) NOT NULL,
  `open_friday` tinyint(4) NOT NULL,
  `open_saturday` tinyint(4) NOT NULL,
  `open_morning` tinyint(4) NOT NULL,
  `open_noon` tinyint(4) NOT NULL,
  `open_evening` tinyint(4) NOT NULL,
  `open_night` tinyint(4) NOT NULL,
  `create_time` datetime NOT NULL,
  `last_update_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tbl_user`
--

CREATE TABLE `tbl_user` (
  `id` int(11) NOT NULL,
  `mail` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `admin` tinyint(4) NOT NULL,
  `registration_time` datetime NOT NULL,
  `last_login_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `tbl_picture`
--
ALTER TABLE `tbl_picture`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `tbl_place`
--
ALTER TABLE `tbl_place`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_place_user` (`user_id`),
  ADD KEY `fk_place_picture` (`picture_id`);

--
-- Indizes für die Tabelle `tbl_user`
--
ALTER TABLE `tbl_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_mail` (`mail`) USING BTREE;

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `tbl_picture`
--
ALTER TABLE `tbl_picture`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `tbl_place`
--
ALTER TABLE `tbl_place`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `tbl_user`
--
ALTER TABLE `tbl_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `tbl_place`
--
ALTER TABLE `tbl_place`
  ADD CONSTRAINT `fk_place_picture` FOREIGN KEY (`picture_id`) REFERENCES `tbl_picture` (`id`),
  ADD CONSTRAINT `fk_place_user` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
