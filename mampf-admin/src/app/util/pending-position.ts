/**
 * Position für einen neuen Ort, gewählt im Platzieren-Modus der Karte
 * (map/src/app/util/pending-position.ts, gleicher Schlüssel!).
 *
 * Liegt im Browser (localStorage), damit sie auch nach Login oder
 * Registrierung noch da ist.
 */
const PENDING_POSITION_KEY = 'mampf.pendingPosition';
/** Ältere Positionen ignorieren (z.B. wenn jemand den Vorgang abgebrochen hat). */
const MAX_AGE_MS = 24 * 60 * 60 * 1000;

export interface PendingPosition {
  lat: number;
  lng: number;
}

/** Gibt es eine gemerkte Position, die noch nicht verwendet wurde? */
export function hasPendingPosition(): boolean {
  return readPendingPosition() !== undefined;
}

/** Gemerkte Position holen und dabei löschen (sie wird nur einmal verwendet). */
export function takePendingPosition(): PendingPosition | undefined {
  const position = readPendingPosition();
  try {
    localStorage.removeItem(PENDING_POSITION_KEY);
  } catch {
    // ignorieren
  }
  return position;
}

function readPendingPosition(): PendingPosition | undefined {
  try {
    const raw = localStorage.getItem(PENDING_POSITION_KEY);
    if (!raw) return undefined;
    const data = JSON.parse(raw);
    const valid =
      typeof data.lat === 'number' &&
      typeof data.lng === 'number' &&
      Date.now() - (data.savedAt ?? 0) < MAX_AGE_MS;
    return valid ? { lat: data.lat, lng: data.lng } : undefined;
  } catch {
    return undefined;
  }
}
