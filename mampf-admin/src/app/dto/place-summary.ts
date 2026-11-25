export interface PlaceSummary {
  id: number;
  pictureId: number | undefined;
  /** Bild-Adresse (Datei in /bilder/orte/ oder altes Datenbank-Bild), null = kein Bild. */
  pictureUrl: string | null;
  name: string;
  description: string;
}
