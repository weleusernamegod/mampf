export interface User {
  id: number;
  mail: string;
  /** Anzeigename bei Kommentaren (null = noch keiner gewählt) */
  name: string | null;
  admin: boolean;
}
