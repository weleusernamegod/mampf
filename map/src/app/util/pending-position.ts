/**
 * Position für einen neuen Ort, gewählt im Platzieren-Modus der Karte.
 *
 * Wird im Browser gespeichert (localStorage), damit sie auch einen Umweg
 * über Login oder Registrierung übersteht. Der Admin-Bereich liest sie im
 * Formular "Ort hinzufügen" wieder aus (mampf-admin/src/app/util/pending-position.ts,
 * gleicher Schlüssel!).
 */
export const PENDING_POSITION_KEY = 'mampf.pendingPosition';

export function savePendingPosition(position: google.maps.LatLngLiteral) {
  try {
    localStorage.setItem(
      PENDING_POSITION_KEY,
      JSON.stringify({ ...position, savedAt: Date.now() })
    );
  } catch {
    // Privater Modus o.ä.: Position geht verloren, Formular startet normal
  }
}
