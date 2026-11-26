/** Der angemeldete Benutzer (api/get-own-user.php). */
export interface OwnUser {
  id: number;
  mail: string;
  /** Anzeigename bei Kommentaren (null = noch keiner gewählt) */
  name: string | null;
  admin: boolean;
}

let cached: Promise<OwnUser | undefined> | undefined;

/**
 * Angemeldeten Benutzer holen (undefined, wenn nicht angemeldet oder Fehler).
 * Wird gemerkt, damit die Reiter nicht bei jedem Wechsel neu fragen.
 * fresh = true holt ihn neu (z.B. nach dem Anmelden oder im Profil).
 */
export function fetchOwnUser(fresh = false): Promise<OwnUser | undefined> {
  if (!cached || fresh) {
    cached = fetch('/api/get-own-user.php', { cache: 'no-store' })
      .then(response => (response.ok ? response.json() : undefined))
      .catch(() => undefined);
    cached.then(user => {
      if (!user) cached = undefined; // nicht angemeldet: nächstes Mal neu fragen
    });
  }
  return cached;
}
