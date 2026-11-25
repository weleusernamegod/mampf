-- =====================================================================
-- mampf: Bilder als Dateien auf dem Webserver statt in der Datenbank
-- (Version 0.0.017)
--
-- Neue Spalte tbl_place.picture_file: Dateiname im Ordner /bilder/orte/
-- auf dem Webserver (z.B. "a3f9c0d2e1b4.jpg"). Leer = kein Bild als Datei.
-- Die alte Spalte picture_id (Bild in tbl_picture) bleibt vorerst, bis
-- api/admin-bilder-umziehen.php die alten Bilder zu Dateien gemacht hat.
--
-- Live: in phpMyAdmin die mampf-Datenbank anklicken, Reiter "SQL",
-- den Inhalt dieser Datei einfügen, "OK". Vorher eine Sicherung machen
-- (siehe data/MIGRATION.md, Schritt 1). Gehört zur Website-Version 0.0.017:
-- erst diese Datei ausführen, dann die neue Website hochladen.
-- =====================================================================

SET NAMES utf8mb4;

ALTER TABLE `tbl_place`
  ADD COLUMN IF NOT EXISTS `picture_file` varchar(100) DEFAULT NULL AFTER `picture_id`;
