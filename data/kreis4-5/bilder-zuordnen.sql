-- =====================================================================
-- mampf: Logos/Bilder aus der Recherche Kreis 4 und 5 den Orten zuordnen
-- Vorher: den Ordner data/kreis4-5/bilder-fuer-server/orte/ per FTP in den
-- Ordner /bilder/orte/ auf dem Server hochladen (Dateien, nicht den Ordner selbst).
-- Gesetzt wird nur bei Orten, die noch KEIN Bild haben. Darf mehrmals laufen.
-- Braucht migration-2026-11-bilddateien.sql.
-- =====================================================================

SET NAMES utf8mb4;

UPDATE tbl_place SET picture_file = 'k45-002-addis-ababa.png' WHERE name = 'Addis Ababa' AND ABS(lat - 47.3728883) < 0.002 AND ABS(lng - 8.5280453) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-003-allegrotto.jpg' WHERE name = 'Allegrotto' AND ABS(lat - 47.3776837) < 0.002 AND ABS(lng - 8.5264) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-004-banh-mi-136.jpg' WHERE name = 'Banh Mi 136' AND ABS(lat - 47.378255) < 0.002 AND ABS(lng - 8.528575) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-005-banh-mi-136-bridge.svg' WHERE name = 'Banh Mi 136 @ bridge' AND ABS(lat - 47.3788434) < 0.002 AND ABS(lng - 8.5341553) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-008-bridge.svg' WHERE name = 'Bridge' AND ABS(lat - 47.3788455) < 0.002 AND ABS(lng - 8.5338299) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-009-cartel-crazy-burrito-shack.png' WHERE name = 'Cartel - Crazy Burrito Shack' AND ABS(lat - 47.3764035) < 0.002 AND ABS(lng - 8.5332122) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-014-delhi-house.png' WHERE name = 'Delhi House' AND ABS(lat - 47.3774466) < 0.002 AND ABS(lng - 8.5131703) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-017-fattoush.png' WHERE name = 'Fattoush' AND ABS(lat - 47.3715683) < 0.002 AND ABS(lng - 8.5255105) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-018-helvetiaplatz.png' WHERE name = 'Helvetiaplatz' AND ABS(lat - 47.3760634) < 0.002 AND ABS(lng - 8.5268416) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-019-house-of-momos.svg' WHERE name = 'House of Momos' AND ABS(lat - 47.3749982) < 0.002 AND ABS(lng - 8.5258144) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-022-jung-bridge.svg' WHERE name = 'jung @ bridge' AND ABS(lat - 47.3788415) < 0.002 AND ABS(lng - 8.5335123) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-023-kanton-slice.png' WHERE name = 'Kanton Slice' AND ABS(lat - 47.3778013) < 0.002 AND ABS(lng - 8.5268763) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-024-la-capricciosa.jpg' WHERE name = 'La Capricciosa' AND ABS(lat - 47.3794128) < 0.002 AND ABS(lng - 8.5280071) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-026-la-penisola.png' WHERE name = 'La Penisola' AND ABS(lat - 47.3739605) < 0.002 AND ABS(lng - 8.5249794) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-032-oh-my-greek.png' WHERE name = 'Oh My Greek' AND ABS(lat - 47.3742338) < 0.002 AND ABS(lng - 8.5214527) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-033-oh-my-greek.png' WHERE name = 'Oh My Greek!' AND ABS(lat - 47.379737) < 0.002 AND ABS(lng - 8.5363362) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-035-phuket-thai-food.png' WHERE name = 'Phuket Thai Food' AND ABS(lat - 47.3802073) < 0.002 AND ABS(lng - 8.5263721) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-041-simply-soup.png' WHERE name = 'Simply Soup' AND ABS(lat - 47.3718091) < 0.002 AND ABS(lng - 8.5290154) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-042-simply-soup-kalkbreite.png' WHERE name = 'Simply Soup Kalkbreite' AND ABS(lat - 47.3740794) < 0.002 AND ABS(lng - 8.5204972) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-045-suppelade.png' WHERE name = 'Suppelade' AND ABS(lat - 47.379811) < 0.002 AND ABS(lng - 8.52851) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-048-tacos-ramiro-y-macario.png' WHERE name = 'Tacos Ramiro y Macario' AND ABS(lat - 47.3790661) < 0.002 AND ABS(lng - 8.5108789) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-052-three-men-s-kebab.png' WHERE name = 'Three Men''s Kebab' AND ABS(lat - 47.3770319) < 0.002 AND ABS(lng - 8.5323997) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-053-tiny-fish.svg' WHERE name = 'Tiny Fish' AND ABS(lat - 47.3743132) < 0.002 AND ABS(lng - 8.521665) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-055-veganitas.png' WHERE name = 'Veganitas' AND ABS(lat - 47.3775824) < 0.002 AND ABS(lng - 8.5276791) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-056-via-del-gusto-28.png' WHERE name = 'Via del gusto 28' AND ABS(lat - 47.3782124) < 0.002 AND ABS(lng - 8.5325262) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-058-wesley-s-kitchen.jpg' WHERE name = 'Wesley''s Kitchen' AND ABS(lat - 47.3794641) < 0.002 AND ABS(lng - 8.5372186) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-060-zum-goldenen-taschenbrot.png' WHERE name = 'Zum goldenen Taschenbrot' AND ABS(lat - 47.3788366) < 0.002 AND ABS(lng - 8.5291393) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-061-zuerich-fried-chicken.png' WHERE name = 'Zürich Fried Chicken' AND ABS(lat - 47.3751013) < 0.002 AND ABS(lng - 8.5285248) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-063-banh-mi.png' WHERE name = 'Banh Mi' AND ABS(lat - 47.3883286) < 0.002 AND ABS(lng - 8.5259591) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-066-bibim-shack.png' WHERE name = 'Bibim Shack' AND ABS(lat - 47.3903038) < 0.002 AND ABS(lng - 8.5226208) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-068-con-gusto.png' WHERE name = 'Con Gusto' AND ABS(lat - 47.3907695) < 0.002 AND ABS(lng - 8.5093071) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-069-c-ba-canteen.jpg' WHERE name = 'Cô Ba Canteen' AND ABS(lat - 47.3839455) < 0.002 AND ABS(lng - 8.5307226) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-074-gyoza-yokocho.png' WHERE name = 'Gyoza Yokocho' AND ABS(lat - 47.3876919) < 0.002 AND ABS(lng - 8.5264887) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-080-kaisin.png' WHERE name = 'kaisin' AND ABS(lat - 47.3875609) < 0.002 AND ABS(lng - 8.5190573) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-081-kantine-im-5i.svg' WHERE name = 'Kantine im 5i' AND ABS(lat - 47.3867746) < 0.002 AND ABS(lng - 8.5207474) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-082-kitchen-republic.jpg' WHERE name = 'Kitchen Republic' AND ABS(lat - 47.3889173) < 0.002 AND ABS(lng - 8.5222924) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-084-la-penisola.png' WHERE name = 'La Penisola' AND ABS(lat - 47.3909632) < 0.002 AND ABS(lng - 8.5184954) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-088-lucky-s-thai-food.png' WHERE name = 'Lucky''s Thai Food' AND ABS(lat - 47.390504) < 0.002 AND ABS(lng - 8.512049) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-093-napul.svg' WHERE name = 'Napulé' AND ABS(lat - 47.382953) < 0.002 AND ABS(lng - 8.5307653) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-095-phill-s-bbq.svg' WHERE name = 'Phill''s BBQ' AND ABS(lat - 47.390504) < 0.002 AND ABS(lng - 8.512049) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-101-tacos-plaza.png' WHERE name = 'Tacos Plaza' AND ABS(lat - 47.3902549) < 0.002 AND ABS(lng - 8.5230371) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-102-tenz-momo-foodtruck.svg' WHERE name = 'Tenz Momo Foodtruck' AND ABS(lat - 47.38823) < 0.002 AND ABS(lng - 8.519562) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-103-the-bagel-shop.png' WHERE name = 'The Bagel Shop' AND ABS(lat - 47.3871303) < 0.002 AND ABS(lng - 8.5246109) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-105-vegitat.png' WHERE name = 'Vegitat' AND ABS(lat - 47.3822487) < 0.002 AND ABS(lng - 8.5296459) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-106-vito.svg' WHERE name = 'Vito' AND ABS(lat - 47.3848528) < 0.002 AND ABS(lng - 8.5322457) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
UPDATE tbl_place SET picture_file = 'k45-107-wurst-moritz.png' WHERE name = 'Wurst & Moritz' AND ABS(lat - 47.390772) < 0.002 AND ABS(lng - 8.52244) < 0.002 AND picture_file IS NULL AND picture_id IS NULL;
