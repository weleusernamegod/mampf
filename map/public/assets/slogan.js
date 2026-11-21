/*
 * mampf: zufälliger Spruch unter dem Logo.
 *
 * Die Sprüche stehen in assets/slogans.txt, die Schrift (abgeleitet vom Logo)
 * in assets/fonts/Mampf-Regular.woff2 (erzeugt von design/font/mampf_font.py).
 *
 * Verwendung:
 *   <script src="/assets/slogan.js"></script>
 *   - Element mit data-mampf-slogan: wird beim Laden automatisch beschriftet.
 *   - Von Hand: MampfSlogan.attach(element) -> Promise<SVGTextElement | null>
 *
 * "element" ist entweder
 *   - ein eingebettetes Logo-<svg> (viewBox 0 0 1700 750): der Spruch kommt ins SVG, oder
 *   - ein Behälter, der genau das Logo-Bild (<img>) enthält: der Spruch wird als
 *     durchsichtige Ebene darübergelegt.
 */
(() => {
  const NS = 'http://www.w3.org/2000/svg';
  const BASE = new URL('.', document.currentScript.src).href; // .../assets/
  const FAMILY = 'Mampf Slogan';
  const COLOR = '#2e9991';
  const LAST_KEY = 'mampf-slogan-last';

  /** Freier Platz im Logo unten links (Logo-Koordinaten, viewBox 1700 x 750). */
  const AREA = { left: 178, right: 1055, bottom: 654, maxSize: 178 };
  /** Masse der Schrift Mampf Regular pro 1000 Einheiten (siehe mampf_font.py). */
  const FONT = { sideBearing: 64.2 - 75.9 / 2, below: 75.9 / 2, descender: 207 };

  let fontPromise;
  let slogansPromise;

  function loadFont() {
    fontPromise ??= new FontFace(FAMILY, `url(${BASE}fonts/Mampf-Regular.woff2)`)
      .load()
      .then(face => {
        document.fonts.add(face);
      });
    return fontPromise;
  }

  function loadSlogans() {
    slogansPromise ??= fetch(BASE + 'slogans.txt')
      .then(response => (response.ok ? response.text() : ''))
      .then(text =>
        text
          .split('\n')
          .map(line => line.trim())
          .filter(line => line && !line.startsWith('#'))
      );
    return slogansPromise;
  }

  /** Zufälliger Spruch, aber nicht zweimal hintereinander derselbe. */
  function pick(slogans) {
    let last = null;
    try {
      last = localStorage.getItem(LAST_KEY);
    } catch {}
    const choices = slogans.length > 1 ? slogans.filter(s => s !== last) : slogans;
    const slogan = choices[Math.floor(Math.random() * choices.length)];
    try {
      localStorage.setItem(LAST_KEY, slogan);
    } catch {}
    return slogan;
  }

  /** Durchsichtige SVG-Ebene über dem Logo-Bild im Behälter. */
  function overlay(container) {
    if (getComputedStyle(container).position === 'static') {
      container.style.position = 'relative';
    }
    const svg = document.createElementNS(NS, 'svg');
    svg.setAttribute('viewBox', '0 0 1700 750');
    svg.setAttribute('aria-hidden', 'true');
    svg.style.cssText =
      'position:absolute;left:0;top:0;width:100%;height:auto;aspect-ratio:1700/750;pointer-events:none;overflow:visible';
    container.appendChild(svg);
    return svg;
  }

  /** Schreibt den Spruch so gross wie möglich in den freien Platz. */
  function fit(textEl, slogan) {
    textEl.textContent = slogan;
    textEl.setAttribute('font-size', '100');
    const side = FONT.sideBearing / 1000;
    const ink100 = textEl.getComputedTextLength() - 2 * side * 100;
    const size = Math.min(AREA.maxSize, ((AREA.right - AREA.left) / ink100) * 100);
    const hasDescender = /[gjpqy,]/.test(slogan);
    const below = ((hasDescender ? FONT.descender : 0) + FONT.below) / 1000;
    textEl.setAttribute('font-size', size.toFixed(1));
    textEl.setAttribute('x', (AREA.left - side * size).toFixed(1));
    textEl.setAttribute('y', (AREA.bottom - below * size).toFixed(1));
  }

  async function attach(element) {
    try {
      const [slogans] = await Promise.all([loadSlogans(), loadFont()]);
      if (!element || !slogans.length) return null;
      const svg = element.tagName.toLowerCase() === 'svg' ? element : overlay(element);
      const textEl = document.createElementNS(NS, 'text');
      textEl.setAttribute('class', 'mampf-slogan');
      textEl.setAttribute('fill', COLOR);
      textEl.style.fontFamily = `"${FAMILY}"`;
      textEl.style.fontWeight = '400';
      svg.appendChild(textEl);
      fit(textEl, pick(slogans));
      return textEl;
    } catch (error) {
      console.warn('mampf: Spruch konnte nicht geladen werden', error);
      return null;
    }
  }

  // Schon beim Laden der Seite holen, damit der Spruch ohne Verzögerung erscheint
  loadFont().catch(() => {});
  loadSlogans().catch(() => {});

  window.MampfSlogan = { attach };

  const autoAttach = () => document.querySelectorAll('[data-mampf-slogan]').forEach(attach);
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', autoAttach);
  } else {
    autoAttach();
  }
})();
