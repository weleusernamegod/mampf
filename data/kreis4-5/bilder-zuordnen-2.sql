-- =====================================================================
-- mampf: fehlende Bilder Kreis 4 und 5 den Orten zuordnen (zweite Runde)
-- Vorher: alle Dateien aus data/kreis4-5/bilder-fuer-server/orte-neu/ per FTP
-- in den Ordner /bilder/orte/ auf dem Server hochladen (die Dateien, nicht den Ordner).
-- Gesetzt wird nur bei Orten, die noch KEIN Bild haben. Darf mehrmals laufen.
-- =====================================================================

SET NAMES utf8mb4;

-- Famiglia Tremonte
UPDATE tbl_place SET picture_file = '000038-famiglia-tremonte-ec6516.jpg' WHERE id = 38 AND picture_file IS NULL AND picture_id IS NULL;
-- Bilo Bistro
UPDATE tbl_place SET picture_file = '000041-bilo-bistro-54478b.jpg' WHERE id = 41 AND picture_file IS NULL AND picture_id IS NULL;
-- Bistro ALADIN
UPDATE tbl_place SET picture_file = '000042-bistro-aladin-f94cda.jpg' WHERE id = 42 AND picture_file IS NULL AND picture_id IS NULL;
-- Centro Pizza
UPDATE tbl_place SET picture_file = '000043-centro-pizza-db8f03.jpg' WHERE id = 43 AND picture_file IS NULL AND picture_id IS NULL;
-- Charlie''s Take Away
UPDATE tbl_place SET picture_file = '000044-charlie-s-take-away-a8a9e6.jpg' WHERE id = 44 AND picture_file IS NULL AND picture_id IS NULL;
-- Cheesecake Love
UPDATE tbl_place SET picture_file = '000045-cheesecake-love-05e55c.jpg' WHERE id = 45 AND picture_file IS NULL AND picture_id IS NULL;
-- Da Antonietta
UPDATE tbl_place SET picture_file = '000046-da-antonietta-dc39e9.jpg' WHERE id = 46 AND picture_file IS NULL AND picture_id IS NULL;
-- Delhi-Bistro
UPDATE tbl_place SET picture_file = '000047-delhi-bistro-31ca68.jpg' WHERE id = 47 AND picture_file IS NULL AND picture_id IS NULL;
-- Edy''s
UPDATE tbl_place SET picture_file = '000011-edy-s-af2f7f.jpg' WHERE id = 11 AND picture_file IS NULL AND picture_id IS NULL;
-- Huncho
UPDATE tbl_place SET picture_file = '000049-huncho-b7a8ce.jpg' WHERE id = 49 AND picture_file IS NULL AND picture_id IS NULL;
-- La Perla
UPDATE tbl_place SET picture_file = '000017-la-perla-f4dad0.jpg' WHERE id = 17 AND picture_file IS NULL AND picture_id IS NULL;
-- Loasia
UPDATE tbl_place SET picture_file = '000053-loasia-fc4224.jpg' WHERE id = 53 AND picture_file IS NULL AND picture_id IS NULL;
-- Oder Wat
UPDATE tbl_place SET picture_file = '000018-oder-wat-5e5dc9.jpg' WHERE id = 18 AND picture_file IS NULL AND picture_id IS NULL;
-- Officina dos Sabores
UPDATE tbl_place SET picture_file = '000019-officina-dos-sabores-1a0fb1.jpg' WHERE id = 19 AND picture_file IS NULL AND picture_id IS NULL;
-- Palestine Grill
UPDATE tbl_place SET picture_file = '000022-palestine-grill-45de41.jpg' WHERE id = 22 AND picture_file IS NULL AND picture_id IS NULL;
-- Piro
UPDATE tbl_place SET picture_file = '000055-piro-c82ef1.jpg' WHERE id = 55 AND picture_file IS NULL AND picture_id IS NULL;
-- PUTPU Takeaway
UPDATE tbl_place SET picture_file = '000056-putpu-takeaway-e8b9b5.jpg' WHERE id = 56 AND picture_file IS NULL AND picture_id IS NULL;
-- Roots of Himalaya
UPDATE tbl_place SET picture_file = '000057-roots-of-himalaya-ef70eb.jpg' WHERE id = 57 AND picture_file IS NULL AND picture_id IS NULL;
-- Rosita''s
UPDATE tbl_place SET picture_file = '000058-rosita-s-85a984.jpg' WHERE id = 58 AND picture_file IS NULL AND picture_id IS NULL;
-- Rotana
UPDATE tbl_place SET picture_file = '000059-rotana-02794c.jpg' WHERE id = 59 AND picture_file IS NULL AND picture_id IS NULL;
-- Spaccio
UPDATE tbl_place SET picture_file = '000025-spaccio-172142.jpg' WHERE id = 25 AND picture_file IS NULL AND picture_id IS NULL;
-- Street
UPDATE tbl_place SET picture_file = '000060-street-7b2976.jpg' WHERE id = 60 AND picture_file IS NULL AND picture_id IS NULL;
-- SV Mensa
UPDATE tbl_place SET picture_file = '000026-sv-mensa-675950.jpg' WHERE id = 26 AND picture_file IS NULL AND picture_id IS NULL;
-- Swiss Fried Chicken
UPDATE tbl_place SET picture_file = '000062-swiss-fried-chicken-c1e5a2.jpg' WHERE id = 62 AND picture_file IS NULL AND picture_id IS NULL;
-- Taste of Africa
UPDATE tbl_place SET picture_file = '000063-taste-of-africa-ba4359.jpg' WHERE id = 63 AND picture_file IS NULL AND picture_id IS NULL;
-- Thai Take-Away
UPDATE tbl_place SET picture_file = '000028-thai-take-away-7c446d.jpg' WHERE id = 28 AND picture_file IS NULL AND picture_id IS NULL;
-- The Barn
UPDATE tbl_place SET picture_file = '000064-the-barn-e594b0.jpg' WHERE id = 64 AND picture_file IS NULL AND picture_id IS NULL;
-- Umami House
UPDATE tbl_place SET picture_file = '000066-umami-house-3abd0c.jpg' WHERE id = 66 AND picture_file IS NULL AND picture_id IS NULL;
-- Weera Pura
UPDATE tbl_place SET picture_file = '000030-weera-pura-4e7f54.jpg' WHERE id = 30 AND picture_file IS NULL AND picture_id IS NULL;
-- Zuki''s
UPDATE tbl_place SET picture_file = '000033-zuki-s-3edd8e.jpg' WHERE id = 33 AND picture_file IS NULL AND picture_id IS NULL;
-- Ada Lokma
UPDATE tbl_place SET picture_file = '000069-ada-lokma-8131ec.jpg' WHERE id = 69 AND picture_file IS NULL AND picture_id IS NULL;
-- Bebos Beef & Chicken
UPDATE tbl_place SET picture_file = '000071-bebos-beef-chicken-152c21.jpg' WHERE id = 71 AND picture_file IS NULL AND picture_id IS NULL;
-- Best Kebab
UPDATE tbl_place SET picture_file = '000074-best-kebab-1d672a.jpg' WHERE id = 74 AND picture_file IS NULL AND picture_id IS NULL;
-- Bunzai Popup
UPDATE tbl_place SET picture_file = '000076-bunzai-popup-551ad1.jpg' WHERE id = 76 AND picture_file IS NULL AND picture_id IS NULL;
-- Da Marco am Limmatplatz
UPDATE tbl_place SET picture_file = '000079-da-marco-am-limmatplatz-c2d3e0.jpg' WHERE id = 79 AND picture_file IS NULL AND picture_id IS NULL;
-- Deliz Asia
UPDATE tbl_place SET picture_file = '000080-deliz-asia-376011.jpg' WHERE id = 80 AND picture_file IS NULL AND picture_id IS NULL;
-- El Turpial
UPDATE tbl_place SET picture_file = '000081-el-turpial-ffdb22.jpg' WHERE id = 81 AND picture_file IS NULL AND picture_id IS NULL;
-- Frida
UPDATE tbl_place SET picture_file = '000082-frida-d46b5b.jpg' WHERE id = 82 AND picture_file IS NULL AND picture_id IS NULL;
-- Haus am Fluss
UPDATE tbl_place SET picture_file = '000084-haus-am-fluss-256929.jpg' WHERE id = 84 AND picture_file IS NULL AND picture_id IS NULL;
-- Hungry Pita
UPDATE tbl_place SET picture_file = '000085-hungry-pita-731e42.jpg' WHERE id = 85 AND picture_file IS NULL AND picture_id IS NULL;
-- Il Pentagramma
UPDATE tbl_place SET picture_file = '000086-il-pentagramma-b2ab6d.jpg' WHERE id = 86 AND picture_file IS NULL AND picture_id IS NULL;
-- India Street Food
UPDATE tbl_place SET picture_file = '000087-india-street-food-efbfda.jpg' WHERE id = 87 AND picture_file IS NULL AND picture_id IS NULL;
-- Juicery21
UPDATE tbl_place SET picture_file = '000088-juicery21-28d91e.jpg' WHERE id = 88 AND picture_file IS NULL AND picture_id IS NULL;
-- Kottu Roti by Loving Lanka
UPDATE tbl_place SET picture_file = '000092-kottu-roti-by-loving-lanka-5da7b2.jpg' WHERE id = 92 AND picture_file IS NULL AND picture_id IS NULL;
-- Lemon Grass
UPDATE tbl_place SET picture_file = '000094-lemon-grass-4ded97.jpg' WHERE id = 94 AND picture_file IS NULL AND picture_id IS NULL;
-- Libanon il-Achdar
UPDATE tbl_place SET picture_file = '000095-libanon-il-achdar-48b8d5.jpg' WHERE id = 95 AND picture_file IS NULL AND picture_id IS NULL;
-- Loving Lanka
UPDATE tbl_place SET picture_file = '000096-loving-lanka-56fc83.jpg' WHERE id = 96 AND picture_file IS NULL AND picture_id IS NULL;
-- Mensa Molki (Toni-Areal)
UPDATE tbl_place SET picture_file = '000100-mensa-molki-toni-areal-b799d0.jpg' WHERE id = 100 AND picture_file IS NULL AND picture_id IS NULL;
-- Mundo del Gusto
UPDATE tbl_place SET picture_file = '000101-mundo-del-gusto-232278.jpg' WHERE id = 101 AND picture_file IS NULL AND picture_id IS NULL;
-- Noodle House
UPDATE tbl_place SET picture_file = '000103-noodle-house-e0fce2.jpg' WHERE id = 103 AND picture_file IS NULL AND picture_id IS NULL;
-- PHƠ-NA, ASIA take away
UPDATE tbl_place SET picture_file = '000105-pho-na-asia-take-away-3a07af.jpg' WHERE id = 105 AND picture_file IS NULL AND picture_id IS NULL;
-- Pinky Burgers
UPDATE tbl_place SET picture_file = '000106-pinky-burgers-75be68.jpg' WHERE id = 106 AND picture_file IS NULL AND picture_id IS NULL;
-- Rucola Pizza
UPDATE tbl_place SET picture_file = '000107-rucola-pizza-81dbb8.jpg' WHERE id = 107 AND picture_file IS NULL AND picture_id IS NULL;
-- San San
UPDATE tbl_place SET picture_file = '000108-san-san-3d29c1.jpg' WHERE id = 108 AND picture_file IS NULL AND picture_id IS NULL;
-- Spoon
UPDATE tbl_place SET picture_file = '000109-spoon-8c6309.jpg' WHERE id = 109 AND picture_file IS NULL AND picture_id IS NULL;
-- Topden
UPDATE tbl_place SET picture_file = '000113-topden-4a91da.jpg' WHERE id = 113 AND picture_file IS NULL AND picture_id IS NULL;
