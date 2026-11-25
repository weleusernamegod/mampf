import { Opening } from './opening';
import { PlaceLocation } from './place-location';

export interface Place {
  id: number;
  pictureId: number | null;
  /** Bild-Adresse (Datei in /bilder/orte/ oder altes Datenbank-Bild), null = kein Bild. */
  pictureUrl: string | null;
  /** Normaler Standort (gilt, wenn locations leer ist). */
  position: google.maps.LatLngLiteral;
  name: string;
  description: string;
  opening: Opening[];
  /** Nur bei "Mehrere Standorte": ein oder mehrere Standorte pro Wochentag. */
  locations: PlaceLocation[];
  /** IDs der Kategorien (siehe api/get-categories.php). */
  categories: number[];
  /** Preisspanne in CHF (10–30), null = unbekannt */
  priceMin: number | null;
  priceMax: number | null;
  /** Erstellt am (JJJJ-MM-TT). */
  created: string;
  /** Gehört dem angemeldeten Nutzer. */
  own: boolean;
  /** Darf bearbeitet werden (eigener Ort, oder Admin). */
  editable: boolean;
}
