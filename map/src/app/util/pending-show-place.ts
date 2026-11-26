/**
 * Ort, der nach dem Speichern im Admin-Bereich auf der Karte gleich
 * geöffnet werden soll (Infobox offen, Karte darauf ausgerichtet).
 *
 * Wird im Browser-Tab gemerkt (sessionStorage). Der Admin-Bereich
 * importiert diese Datei, damit beide den gleichen Schlüssel verwenden.
 */
const PENDING_SHOW_PLACE_KEY = 'mampf.showPlace';

export function savePendingShowPlace(placeId: number) {
  try {
    sessionStorage.setItem(PENDING_SHOW_PLACE_KEY, String(placeId));
  } catch {
    // Privater Modus o.ä.: die Karte öffnet einfach ohne Ort
  }
}

/** Gemerkten Ort holen und gleich vergessen (nur einmal öffnen). */
export function takePendingShowPlace(): number | undefined {
  try {
    const value = sessionStorage.getItem(PENDING_SHOW_PLACE_KEY);
    sessionStorage.removeItem(PENDING_SHOW_PLACE_KEY);
    return value ? Number(value) : undefined;
  } catch {
    return undefined;
  }
}
