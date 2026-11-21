import { Opening } from './opening';
import { PlaceLocation } from './place-location';

export interface Place {
  id: number;
  pictureId: number | null;
  /** Normaler Standort (gilt, wenn locations leer ist). */
  position: google.maps.LatLngLiteral;
  name: string;
  description: string;
  opening: Opening[];
  /** Nur bei "Mehrere Standorte": ein oder mehrere Standorte pro Wochentag. */
  locations: PlaceLocation[];
  /** IDs der Kategorien (siehe api/get-categories.php). */
  categories: number[];
}
