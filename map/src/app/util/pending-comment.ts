/**
 * Ort, bei dem jemand kommentieren wollte, aber noch nicht angemeldet war.
 *
 * Wird vor dem Umweg über Login (und evtl. Registrierung) im Browser-Tab
 * gemerkt (sessionStorage). Zurück auf der Karte öffnet sich die Infobox
 * dieses Orts direkt mit dem Kommentarfeld.
 */
const PENDING_COMMENT_KEY = 'mampf.pendingComment';

export function savePendingComment(placeId: number) {
  try {
    sessionStorage.setItem(PENDING_COMMENT_KEY, String(placeId));
  } catch {
    // Privater Modus o.ä.: nach dem Login landet man einfach auf der Karte
  }
}

/** Gemerkten Ort holen und gleich vergessen (nur einmal öffnen). */
export function takePendingComment(): number | undefined {
  try {
    const value = sessionStorage.getItem(PENDING_COMMENT_KEY);
    sessionStorage.removeItem(PENDING_COMMENT_KEY);
    return value ? Number(value) : undefined;
  } catch {
    return undefined;
  }
}
