/*
 * mampf: Oberflächenfarbe (Farbton), vom Farbregler auf der About-Seite wählbar.
 *
 * Alle Farben der Seite hängen an der CSS-Variable --hue (0–360, siehe src/vars.scss):
 *   --primary        mampf-Grün (Standard #2e9991)
 *   --primary-light  helles Grün (Kategorien in der Infobox)
 *   --accent         Weinrot, genau gegenüber auf dem Farbkreis (Wochenende, heutiger Tag)
 * Dieses Skript setzt --hue so früh wie möglich (im <head> laden), damit beim Laden
 * nichts kurz in der falschen Farbe aufblitzt. Die Wahl bleibt im Browser gespeichert.
 *
 * Verwendung:
 *   <script src="/assets/theme.js"></script>
 *   MampfTheme.hue            aktueller Farbton
 *   MampfTheme.set(hue)       neuen Farbton wählen und speichern
 *   window 'mampf-hue'        Ereignis nach jeder Änderung (event.detail = Farbton)
 */
(() => {
  /** Farbton von mampf-Grün #2e9991. */
  const DEFAULT_HUE = 175.5;
  const KEY = 'mampf-hue';

  /** Gleiche Werte wie --primary in vars.scss (für die Browser-Leiste oben). */
  function primaryColor(hue) {
    return `hsl(${hue} 53.8% 39%)`;
  }

  function apply(hue) {
    document.documentElement.style.setProperty('--hue', String(hue));
    document.querySelector('meta[name="theme-color"]')?.setAttribute('content', primaryColor(hue));
  }

  function load() {
    try {
      const value = parseFloat(localStorage.getItem(KEY) ?? '');
      if (value >= 0 && value <= 360) return value;
    } catch {
      // Speicher gesperrt (z.B. privates Surfen): Standard verwenden
    }
    return DEFAULT_HUE;
  }

  const theme = {
    DEFAULT_HUE,
    hue: load(),
    primaryColor,
    set(hue) {
      theme.hue = hue;
      apply(hue);
      try {
        if (hue === DEFAULT_HUE) localStorage.removeItem(KEY);
        else localStorage.setItem(KEY, String(hue));
      } catch {
        // nicht speicherbar: gilt dann nur bis zum Neuladen
      }
      window.dispatchEvent(new CustomEvent('mampf-hue', { detail: hue }));
    },
  };

  apply(theme.hue);
  // Die meta theme-color steht evtl. erst nach diesem Skript im HTML
  document.addEventListener('DOMContentLoaded', () => apply(theme.hue));

  window.MampfTheme = theme;
})();
