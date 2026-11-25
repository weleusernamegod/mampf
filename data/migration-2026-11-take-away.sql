-- =====================================================================
-- mampf: "Imbiss-Stand" in "Take-away" verschmelzen + neue Beschreibungen
--
-- Live: in phpMyAdmin die mampf-Datenbank anklicken, Reiter "SQL",
-- den Inhalt dieser Datei einfügen, "OK". Vorher eine Sicherung machen
-- (siehe data/MIGRATION.md, Schritt 1).
--
-- Darf auch zweimal laufen: beim zweiten Mal passiert einfach nichts mehr.
-- =====================================================================

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- 1. Kategorie: alle Orte mit "Imbiss-Stand" bekommen "Take-away-Stand"
--    (wer beides hat, behält es einfach einmal), dann "Imbiss-Stand" löschen
--    und "Take-away-Stand" in "Take-away" umbenennen.
-- ---------------------------------------------------------------------

INSERT IGNORE INTO tbl_place_category (place_id, category_id)
SELECT pc.place_id, ta.id
FROM tbl_place_category pc
JOIN tbl_category im ON im.id = pc.category_id AND im.gruppe = 'art' AND im.name = 'Imbiss-Stand'
JOIN tbl_category ta ON ta.gruppe = 'art' AND ta.name IN ('Take-away-Stand', 'Take-away');

-- Zuordnungen zu "Imbiss-Stand" werden automatisch mitgelöscht (ON DELETE CASCADE).
DELETE FROM tbl_category WHERE gruppe = 'art' AND name = 'Imbiss-Stand';

UPDATE tbl_category SET name = 'Take-away' WHERE gruppe = 'art' AND name = 'Take-away-Stand';

-- ---------------------------------------------------------------------
-- 2. Neue Beschreibungen (aus data/beschreibungen-vorschlag.xlsx).
--    Geändert wird nur, wenn Name UND alter Text noch übereinstimmen.
--    Wer den Beschrieb inzwischen im Admin selber geändert hat, bleibt so.
-- ---------------------------------------------------------------------

UPDATE tbl_place SET description = 'Äthiopische Injera mit Linsen- und Fleischcurrys' WHERE name = 'Addis Ababa' AND description = 'Äthiopischer Imbiss';
UPDATE tbl_place SET description = 'Pizza, Burger und Currys – alles aus einer Küche' WHERE name = 'Allegrotto' AND description = 'Pizza, Burger, indisch';
UPDATE tbl_place SET description = 'Migros-Konzept mit wechselnden Pop-up-Ständen' WHERE name = 'Bridge' AND description = 'Food Hall am HB: Banh Mi, Japanisch, Grill, Pasta';
UPDATE tbl_place SET description = 'Dicke Burritos und Tacos aus dem Shack' WHERE name = 'Cartel - Crazy Burrito Shack' AND description = 'Burritos und Tacos zum Mitnehmen';
UPDATE tbl_place SET description = 'Indische Currys und Momos' WHERE name = 'Delhi House' AND description = 'Indischer Imbiss';
UPDATE tbl_place SET description = 'Fleisch- oder Gemüse-Kebab' WHERE name = 'Edy''s' AND description = 'Kebab';
UPDATE tbl_place SET description = 'Syrische Falafel, Wraps und Lahmacun' WHERE name = 'Fattoush' AND description = 'Syrisches Take-away';
UPDATE tbl_place SET description = 'Das Hiltl-Buffet, bezahlt wird nach Gewicht' WHERE name = 'Hiltl Sihlpost' AND description = 'Vegetarisches Buffet, auch zum Mitnehmen';
UPDATE tbl_place SET description = 'Handgemachte Momos, Mochi zum Dessert' WHERE name = 'House of Momos' AND description = 'Tibetische Momos zum Mitnehmen';
UPDATE tbl_place SET description = 'Pizza und hausgemachte Pasta' WHERE name = 'La Capricciosa' AND description = 'Italienisches Take-away';
UPDATE tbl_place SET description = 'Piadina, Pizza und Panini' WHERE name = 'La Penisola' AND description = 'Italienischer Imbiss';
UPDATE tbl_place SET description = 'Pizzastücke für zwischendurch' WHERE name = 'La Perla' AND description = 'Pizza-Imbiss';
UPDATE tbl_place SET description = 'Berliner Currywurst mit Pommes' WHERE name = 'Oder Wat' AND description = 'Deutscher Imbiss';
UPDATE tbl_place SET description = 'Brasilianische Küche' WHERE name = 'Officina dos Sabores' AND description = 'Imbiss / Take-away';
UPDATE tbl_place SET description = 'Gyros-Pita und Bowls mit Bio-Zutaten' WHERE name = 'Oh My Greek' AND description = 'Griechischer Imbiss';
UPDATE tbl_place SET description = 'Gyros-Pita und Bowls mit Bio-Zutaten' WHERE name = 'Oh My Greek!' AND description = 'Griechischer Imbiss';
UPDATE tbl_place SET description = 'Palästinensische Falafel und Shawarma vom Grill' WHERE name = 'Palestine Grill' AND description = 'Palästinensischer Grill, Falafel';
UPDATE tbl_place SET description = 'Currys, Nudeln und Suppen' WHERE name = 'Phuket Thai Food' AND description = 'Thai-Imbiss';
UPDATE tbl_place SET description = 'Wechselnde Suppen und Bowls aus der Region' WHERE name = 'Simply Soup' AND description = 'Suppen zum Mitnehmen, auch vegan';
UPDATE tbl_place SET description = 'Pizza, ganz oder als Slice' WHERE name = 'Spaccio' AND description = 'Pizza zum Mitnehmen';
UPDATE tbl_place SET description = 'Wechselnde Tagesmenüs' WHERE name = 'SV Mensa' AND description = 'Mensa an der Europaallee, wechselnde Menüs';
UPDATE tbl_place SET description = 'Tacos und Quesadillas' WHERE name = 'Tacos Ramiro y Macario' AND description = 'Mexikanische Tacos';
UPDATE tbl_place SET description = 'Currys, Nudeln und Reisgerichte' WHERE name = 'Thai Take-Away' AND description = 'Thai-Take-away';
UPDATE tbl_place SET description = 'Panini mit italienischen Spezialitäten' WHERE name = 'Via del gusto 28' AND description = 'Italienische Sandwiches';
UPDATE tbl_place SET description = 'Sri-lankische Currys mit Reis' WHERE name = 'Weera Pura' AND description = 'Curry-Imbiss';
UPDATE tbl_place SET description = 'Bao, Dim Sum und Nudeln, chinesisch inspiriert' WHERE name = 'Wesley''s Kitchen' AND description = 'Asiatisches Take-away';
UPDATE tbl_place SET description = 'Orientalisches Buffet, warm und kalt' WHERE name = 'Yalda' AND description = 'Imbiss / Take-away';
UPDATE tbl_place SET description = 'Anatolische Gözleme, Linsensuppe und Baklava' WHERE name = 'Zuki''s' AND description = 'Imbiss / Take-away';
UPDATE tbl_place SET description = 'Kebab im selbst gebackenen Taschenbrot' WHERE name = 'Zum goldenen Taschenbrot' AND description = 'Kebab im Taschenbrot';
UPDATE tbl_place SET description = 'Familienbetrieb mit Piadina und Tagespasta' WHERE name = 'Famiglia Tremonte' AND description = 'Familienbetrieb an der Schmiede Wiedikon, Piadina';
UPDATE tbl_place SET description = 'Banh Mi, das vietnamesische Baguette' WHERE name = 'Banh Mi 136' AND description = 'Vietnamesische Banh Mi';
UPDATE tbl_place SET description = 'Ableger von Banh Mi 136' WHERE name = 'Banh Mi 136 @ bridge' AND description = 'menu: https://menu.tablesnappr.com/bridgezurich/#/';
UPDATE tbl_place SET description = 'Mediterrane Teller und Wraps, bis spät offen' WHERE name = 'Bilo Bistro' AND description = 'Mediterranes Bistro, Lieferung, bis spät offen';
UPDATE tbl_place SET description = 'Döner und Pizza' WHERE name = 'Bistro ALADIN' AND description = 'Imbiss-Stand';
UPDATE tbl_place SET description = 'Klassische Pizza' WHERE name = 'Centro Pizza' AND description = 'Imbiss-Stand, Italienisch';
UPDATE tbl_place SET description = 'Cheesecake in vielen Sorten' WHERE name = 'Cheesecake Love' AND description = 'Imbiss-Stand';
UPDATE tbl_place SET description = 'Beliebte Paninoteca mit Panini und Piadina' WHERE name = 'Da Antonietta' AND description = 'Imbiss-Stand';
UPDATE tbl_place SET description = 'Indisches Buffet mit vielen Currys' WHERE name = 'Delhi-Bistro' AND description = 'Indisches Bistro mit Buffet, sehr vegan-freundlich';
UPDATE tbl_place SET description = 'Wochenmarkt, Dienstag und Freitag' WHERE name = 'Helvetiaplatz' AND description = 'Marktstand';
UPDATE tbl_place SET description = 'Café mit kleinen Snacks' WHERE name = 'Infocafé' AND description = 'Imbiss-Stand';
UPDATE tbl_place SET description = 'Wechselnder Pop-up-Stand' WHERE name = 'jung @ bridge' AND description = 'Imbiss-Stand';
UPDATE tbl_place SET description = 'Pizza-Slices zum Zusammenstellen' WHERE name = 'Kanton Slice' AND description = 'Pizza-Slices, Zugang per Lift bei Hungry Duck';
UPDATE tbl_place SET description = 'Asiatische Nudeln und Reisgerichte' WHERE name = 'Loasia' AND description = 'Imbiss-Stand, Asiatisch';
UPDATE tbl_place SET description = 'Heisse Marroni, nur Herbst und Winter' WHERE name = 'Marronistand' AND description = 'Heisse Marroni (Saison Herbst/Winter)';
UPDATE tbl_place SET description = 'Salate und Schaschlik' WHERE name = 'Piro' AND description = 'Imbiss-Stand';
UPDATE tbl_place SET description = 'Japanisches Chicken Curry und Onigiri' WHERE name = 'PUTPU Takeaway' AND description = 'Japanisches Chicken Curry';
UPDATE tbl_place SET description = 'Himalaya-Küche vom Koch des Foodtrucks Topden' WHERE name = 'Roots of Himalaya' AND description = 'Tibetische Momos, auch Curry und Bowls';
UPDATE tbl_place SET description = 'Grosszügig belegte Sandwiches nach Wahl' WHERE name = 'Rosita''s' AND description = 'Grosszügige, frisch belegte Sandwiches';
UPDATE tbl_place SET description = 'Wechselnde Suppen und Bowls aus der Region' WHERE name = 'Simply Soup Kalkbreite' AND description = 'Imbiss-Stand';
UPDATE tbl_place SET description = 'Burger und Pommes' WHERE name = 'Street' AND description = 'Imbiss-Stand, Amerikanisch';
UPDATE tbl_place SET description = 'Drei Suppen täglich mit Brot und Frucht' WHERE name = 'Suppelade' AND description = 'Drei frische Suppen täglich mit Brot und Frucht';
UPDATE tbl_place SET description = 'Knuspriges Fried Chicken und Wings' WHERE name = 'Swiss Fried Chicken' AND description = 'Imbiss-Stand';
UPDATE tbl_place SET description = 'Afrikanische Küche, auch Catering' WHERE name = 'Taste of Africa' AND description = 'Restaurant/Take-away/Catering';
UPDATE tbl_place SET description = 'Frische Pasta in vielen Varianten' WHERE name = 'The Barn' AND description = 'Imbiss-Stand';
UPDATE tbl_place SET description = 'Kebab nach eigenem Rezept' WHERE name = 'Three Men''s Kebab' AND description = 'Imbiss-Stand';
UPDATE tbl_place SET description = 'Sushi to go, auch Platten zum Teilen' WHERE name = 'Tiny Fish' AND description = 'Imbiss-Stand, Japanisch';
UPDATE tbl_place SET description = 'Sushi und Bowls' WHERE name = 'Umami House' AND description = 'Imbiss-Stand, Japanisch';
UPDATE tbl_place SET description = 'Pitas und Burger, Brot täglich frisch gebacken' WHERE name = 'Veganitas' AND description = 'Veganes Fast Food: Pitas und Burger';
UPDATE tbl_place SET description = 'Halal Fried Chicken und Burger' WHERE name = 'Zürich Fried Chicken' AND description = 'Imbiss-Stand, Amerikanisch';
UPDATE tbl_place SET description = 'Kebab und Köfte vom Grill' WHERE name = 'Ada Lokma' AND description = 'Kebab, Köfte, auch vegetarisch und vegan';
UPDATE tbl_place SET description = 'Banh Mi und Reisnudeln (Bun)' WHERE name = 'Banh Mi' AND description = 'Imbiss-Stand, Vietnamesisch';
UPDATE tbl_place SET description = 'Burger, Fried Chicken und Kebab' WHERE name = 'Bebos Beef & Chicken' AND description = 'Imbiss-Stand, Amerikanisch, Türkisch';
UPDATE tbl_place SET description = 'Bibimbap to go' WHERE name = 'Bibim Shack' AND description = 'Imbiss-Stand, Koreanisch';
UPDATE tbl_place SET description = 'Thai-Küche als Pop-up' WHERE name = 'Bunzai Popup' AND description = 'Imbiss-Stand, Thailändisch';
UPDATE tbl_place SET description = 'Pizza napoletana und Süditalienisches' WHERE name = 'Con Gusto' AND description = 'Imbiss-Stand, Italienisch';
UPDATE tbl_place SET description = 'Bowls, Pho und Banh Mi' WHERE name = 'Cô Ba Canteen' AND description = 'Imbiss-Stand, Vietnamesisch';
UPDATE tbl_place SET description = 'Frische Panini und Pizza' WHERE name = 'Da Marco am Limmatplatz' AND description = 'Frische Panini und Pizza am Limmatplatz';
UPDATE tbl_place SET description = 'Butter Chicken, Kottu Roti, Naan, Samosa' WHERE name = 'Deliz Asia' AND description = 'Butter Chicken, Kottu Rotti, Naan, Samosa';
UPDATE tbl_place SET description = 'Gefüllte Arepas aus Maismehl' WHERE name = 'El Turpial' AND description = 'Venezolanische Arepas, auch vegan';
UPDATE tbl_place SET description = 'Tacos und Burritos' WHERE name = 'Frida' AND description = 'Mexikanische Tacos und Burritos zum Mitnehmen';
UPDATE tbl_place SET description = 'Frisch gebratene Gyoza' WHERE name = 'Gyoza Yokocho' AND description = 'Imbiss-Stand, Japanisch';
UPDATE tbl_place SET description = 'Asiatische Stände unter einem Dach' WHERE name = 'Haus am Fluss' AND description = 'Asiatische Food Hall am Sihlquai';
UPDATE tbl_place SET description = 'Pitas mit Fleisch, Falafel oder Seitan' WHERE name = 'Hungry Pita' AND description = 'Pitas mit Fleisch, Poulet, Falafel, veganem Seitan';
UPDATE tbl_place SET description = 'Panini-Institution mit grosser Auswahl' WHERE name = 'Il Pentagramma' AND description = 'Panini-Institution an der Josefstrasse';
UPDATE tbl_place SET description = 'Samosas, Kottu Roti und Currys' WHERE name = 'India Street Food' AND description = 'Samosas, Kottu Roti, Currys';
UPDATE tbl_place SET description = 'Frische Säfte, Bowls und Bagels' WHERE name = 'Juicery21' AND description = 'Imbiss-Stand';
UPDATE tbl_place SET description = 'Asiatisch inspirierte Bowls und Currys' WHERE name = 'kaisin' AND description = 'Imbiss-Stand';
UPDATE tbl_place SET description = 'Saisonale Tagesmenüs mit und ohne Fleisch' WHERE name = 'Kantine im 5i' AND description = 'Imbiss-Stand';
UPDATE tbl_place SET description = 'Foodhall: Sushi, Wok, Burger, Korean Chicken' WHERE name = 'Kitchen Republic' AND description = 'Food Hall: Sushi, Wok, Burger, Korean Chicken';
UPDATE tbl_place SET description = 'Piadina, Pizza und Panini' WHERE name = 'La Penisola' AND description = 'Imbiss-Stand, Italienisch';
UPDATE tbl_place SET description = 'Thai-Currys und Wok-Gerichte' WHERE name = 'Lemon Grass' AND description = 'Imbiss-Stand, Thailändisch';
UPDATE tbl_place SET description = 'Mezze, Falafel und Shawarma' WHERE name = 'Libanon il-Achdar' AND description = 'Imbiss-Stand, Libanesisch';
UPDATE tbl_place SET description = 'Scharfe tamilische Currys mit Reis' WHERE name = 'Loving Lanka' AND description = 'Scharfe tamilische Currys mit Reis, auch vegan';
UPDATE tbl_place SET description = 'Thai-Küche mit wechselndem Wochenmenü' WHERE name = 'Lucky''s Thai Food' AND description = 'Thai Street Food, Wochenmenü wechselt';
UPDATE tbl_place SET description = 'Döner und Falafel' WHERE name = 'Markaz Döner & Falafel' AND description = 'Imbiss-Stand, Türkisch';
UPDATE tbl_place SET description = 'Heisse Marroni, nur Herbst und Winter' WHERE name = 'Marronistand' AND description = 'Heisse Marroni (Saison Herbst/Winter)';
UPDATE tbl_place SET description = 'ZHdK/ZHAW: Menüs, Suppe, Salatbuffet' WHERE name = 'Mensa Molki (Toni-Areal)' AND description = 'Mensa ZHdK/ZHAW: Menüs, Suppe, Salatbuffet';
UPDATE tbl_place SET description = 'Burger, Pommes und Wochenspecial' WHERE name = 'Mundo del Gusto' AND description = 'Burger, Pommes, Wochenspecial';
UPDATE tbl_place SET description = 'Neapolitanische Pizza, auch a portafoglio' WHERE name = 'Napulé' AND description = 'Neapolitanisches Streetfood, Pizza a portafoglio';
UPDATE tbl_place SET description = 'Nudelsuppen und Wok-Gerichte' WHERE name = 'Noodle House' AND description = 'Imbiss-Stand, Asiatisch';
UPDATE tbl_place SET description = 'Ribs, BBQ-Burger und Pommes' WHERE name = 'Phill''s BBQ' AND description = 'Ribs, BBQ-Burger, hausgemachte Pommes';
UPDATE tbl_place SET description = 'Pho und Reisgerichte' WHERE name = 'PHƠ-NA, ASIA take away' AND description = 'Imbiss-Stand, Vietnamesisch';
UPDATE tbl_place SET description = 'Burger und Fried Chicken' WHERE name = 'Pinky Burgers' AND description = 'Halal-Burger-Take-away';
UPDATE tbl_place SET description = 'Pizza und Pasta' WHERE name = 'Rucola Pizza' AND description = 'Imbiss-Stand, Italienisch';
UPDATE tbl_place SET description = 'Sushi to go' WHERE name = 'San San' AND description = 'Imbiss-Stand, Japanisch';
UPDATE tbl_place SET description = 'Tacos und Burritos' WHERE name = 'Tacos Plaza' AND description = 'Imbiss-Stand, Mexikanisch';
UPDATE tbl_place SET description = 'Ableger der Momo-Kette Tenz' WHERE name = 'Tenz Momo Foodtruck' AND description = 'Foodtruck der Momo-Kette Tenz';
UPDATE tbl_place SET description = 'Çiğ Köfte, Wraps und Bowls' WHERE name = 'Vegitat' AND description = 'Imbiss-Stand, Türkisch';
UPDATE tbl_place SET description = 'Pizza zum Teilen' WHERE name = 'Vito' AND description = 'Imbiss-Stand, Italienisch';
UPDATE tbl_place SET description = 'Currywurst mit Pommes, seit 2012' WHERE name = 'Wurst & Moritz' AND description = 'Currywurst-Imbiss';
