/** Farbton von mampf-Grün #2e9991 (wie --hue in vars.scss und assets/theme.js). */
export const DEFAULT_HUE = 175.5;

/**
 * Dreht eine Farbe (#rrggbb) um "shift" Grad auf dem Farbkreis.
 * Sättigung und Helligkeit bleiben gleich, Grautöne bleiben also grau.
 */
export function rotateHue(hex: string, shift: number): string {
  const match = /^#([0-9a-f]{6})$/i.exec(hex);
  if (!match) return hex;
  const n = parseInt(match[1], 16);
  const [h, s, l] = rgbToHsl((n >> 16) & 255, (n >> 8) & 255, n & 255);
  if (s === 0) return hex;
  const [r, g, b] = hslToRgb((((h + shift) % 360) + 360) % 360, s, l);
  return '#' + [r, g, b].map(v => v.toString(16).padStart(2, '0')).join('');
}

function rgbToHsl(r: number, g: number, b: number): [number, number, number] {
  r /= 255;
  g /= 255;
  b /= 255;
  const max = Math.max(r, g, b);
  const min = Math.min(r, g, b);
  const l = (max + min) / 2;
  const d = max - min;
  if (d === 0) return [0, 0, l];
  const s = d / (1 - Math.abs(2 * l - 1));
  let h: number;
  if (max === r) h = ((g - b) / d) % 6;
  else if (max === g) h = (b - r) / d + 2;
  else h = (r - g) / d + 4;
  return [(h * 60 + 360) % 360, s, l];
}

function hslToRgb(h: number, s: number, l: number): [number, number, number] {
  const c = (1 - Math.abs(2 * l - 1)) * s;
  const x = c * (1 - Math.abs(((h / 60) % 2) - 1));
  const m = l - c / 2;
  const [r, g, b] =
    h < 60 ? [c, x, 0] : h < 120 ? [x, c, 0] : h < 180 ? [0, c, x] : h < 240 ? [0, x, c] : h < 300 ? [x, 0, c] : [c, 0, x];
  return [r, g, b].map(v => Math.round((v + m) * 255)) as [number, number, number];
}

/** Oberflächenfarbe aus assets/theme.js (in index.html geladen). */
declare global {
  interface Window {
    MampfTheme?: { hue: number; set(hue: number): void };
  }
}

/** Aktueller Farbton der Oberfläche. */
export function currentHue(): number {
  return window.MampfTheme?.hue ?? DEFAULT_HUE;
}

/** Neuen Farbton wählen: gilt sofort für alle Oberflächen und bleibt gespeichert. */
export function setHue(hue: number): void {
  window.MampfTheme?.set(hue);
}
