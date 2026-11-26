/** Der angemeldete Benutzer (api/get-own-user.php). */
export interface OwnUser {
  id: number;
  mail: string;
  /** Anzeigename bei Kommentaren (null = noch keiner gewählt) */
  name: string | null;
  admin: boolean;
}

/** Angemeldeten Benutzer holen (undefined, wenn nicht angemeldet oder Fehler). */
export function fetchOwnUser(): Promise<OwnUser | undefined> {
  return fetch('/api/get-own-user.php', { cache: 'no-store' })
    .then(response => (response.ok ? response.json() : undefined))
    .catch(() => undefined);
}
