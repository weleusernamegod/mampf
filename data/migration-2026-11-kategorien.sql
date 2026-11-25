-- =====================================================================
-- mampf: Neue Küchen und Gerichte (aus der Recherche Kreis 4 und 5,
-- siehe data/kreis4-5/neue-kategorien.csv)
--
-- Live: in phpMyAdmin die mampf-Datenbank anklicken, Reiter "SQL",
-- den Inhalt dieser Datei einfügen, "OK". Vorher eine Sicherung machen
-- (siehe data/MIGRATION.md, Schritt 1).
--
-- Darf auch zweimal laufen: INSERT IGNORE überspringt Kategorien,
-- die es schon gibt (gleiche Gruppe + gleicher Name).
-- Die Reihenfolge-Zahlen liegen zwischen den bestehenden, damit die
-- neuen Einträge an der passenden Stelle in der Liste erscheinen.
-- =====================================================================

SET NAMES utf8mb4;

INSERT IGNORE INTO `tbl_category` (`gruppe`, `name`, `reihenfolge`) VALUES
  ('kueche', 'Deutsch',        15),   -- nach Schweizer
  ('kueche', 'Mediterran',     55),   -- nach Griechisch
  ('kueche', 'Syrisch',        95),   -- nach Libanesisch
  ('kueche', 'Usbekisch',     105),   -- nach Persisch
  ('kueche', 'Äthiopisch',    125),   -- nach Eritreisch
  ('kueche', 'Asiatisch',     155),   -- vor Chinesisch (gemischt asiatisch)
  ('kueche', 'Malaysisch',    205),   -- vor Indonesisch
  ('kueche', 'Venezolanisch', 235);   -- nach Peruanisch

INSERT IGNORE INTO `tbl_category` (`gruppe`, `name`, `reihenfolge`) VALUES
  ('gericht', 'Pide / Lahmacun',        15),   -- nach Pizza
  ('gericht', 'Piadina',                25),   -- nach Pasta
  ('gericht', 'Focaccia',               27),
  ('gericht', 'Smash Burger',           32),   -- nach Burger
  ('gericht', 'Poulet / Fried Chicken', 35),
  ('gericht', 'Pommes',                 37),
  ('gericht', 'Köfte',                  43),   -- nach Kebab
  ('gericht', 'Cig Köfte',              45),
  ('gericht', 'Pita',                   55),   -- nach Falafel
  ('gericht', 'Nudeln',                 75),   -- nach Ramen
  ('gericht', 'Panini',                122),   -- nach Sandwiches
  ('gericht', 'Bagels',                125),
  ('gericht', 'Wurst / Currywurst',    145),   -- nach Hot Dogs
  ('gericht', 'Dim Sum',               155),   -- nach Momos
  ('gericht', 'Samosa',                157),
  ('gericht', 'Burritos',              172),   -- nach Tacos
  ('gericht', 'Arepas',                175),
  ('gericht', 'Rendang',               182),   -- nach Curry
  ('gericht', 'Kottu Roti',            185),
  ('gericht', 'Marroni',               190),
  ('gericht', 'Dessert',               200);

-- "Deli" war in 0.0.011 entfernt worden und kommt hier zurück
-- (italienische Feinkostläden mit Panini/Mittagessen, z.B. Di Bennardo).
INSERT IGNORE INTO `tbl_category` (`gruppe`, `name`, `reihenfolge`) VALUES
  ('art', 'Deli', 95);   -- nach Mensa
