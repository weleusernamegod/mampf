/*
 * Zufälliger Anzeigename, z.B. "Knusprige Bratwurst" oder "Hungriger Falafel".
 * Verwendet im Fenster "Registrieren" und im Profil (beide laden die Datei erst bei Bedarf)
 * Aufruf: mampfRandomName()
 *
 * Das Adjektiv bekommt je nach Geschlecht des Nomens die passende Endung:
 * m = der (-er), f = die (-e), n = das (-es).
 */
(function () {
  const ADJECTIVES = [
    'Hungrig', 'Knusprig', 'Scharf', 'Würzig', 'Saftig', 'Fröhlich', 'Gemütlich',
    'Flink', 'Satt', 'Neugierig', 'Mutig', 'Heiss', 'Frisch', 'Gefüllt', 'Gebraten',
    'Gegrillt', 'Süss', 'Pikant', 'Zufrieden', 'Wild', 'Schlau', 'Verträumt',
  ];
  const NOUNS = [
    ['Falafel', 'f'], ['Bratwurst', 'f'], ['Pizza', 'f'], ['Momo', 'm'],
    ['Dürüm', 'm'], ['Taco', 'm'], ['Burger', 'm'], ['Kebab', 'm'],
    ['Crêpe', 'f'], ['Raclette', 'n'], ['Bao', 'n'], ['Curry', 'n'],
    ['Pommes', 'f'], ['Nudel', 'f'], ['Dumpling', 'm'], ['Bagel', 'm'],
    ['Waffel', 'f'], ['Samosa', 'f'], ['Gipfeli', 'n'], ['Schnitzel', 'n'],
    ['Empanada', 'f'], ['Hotdog', 'm'], ['Sandwich', 'n'], ['Rösti', 'f'],
    ['Biryani', 'n'], ['Pho', 'f'], ['Sushi', 'n'], ['Fladenbrot', 'n'],
  ];
  const ENDINGS = { m: 'er', f: 'e', n: 'es' };

  function pick(list) {
    return list[Math.floor(Math.random() * list.length)];
  }

  window.mampfRandomName = function () {
    const [noun, gender] = pick(NOUNS);
    return pick(ADJECTIVES) + ENDINGS[gender] + ' ' + noun;
  };
})();
