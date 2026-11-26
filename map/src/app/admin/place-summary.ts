/** Ein eigener Ort in der Liste "Meine Orte" (api/get-own-places.php). */
export interface PlaceSummary {
  id: number;
  /** Bild-Adresse (Datei in /bilder/orte/ oder altes Datenbank-Bild), null = kein Bild. */
  pictureUrl: string | null;
  name: string;
  description: string;
}
