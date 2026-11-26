import { Opening } from '../dto/opening';

export type { Opening, Slot } from '../dto/opening';

/** Standort eines Foodtrucks an einem Wochentag (nur bei "Je nach Wochentag"). */
export interface PlaceLocation {
  weekday: number;
  lat: number;
  lng: number;
  label: string | null;
}

/** Ein Ort zum Bearbeiten (api/get-place.php). */
export interface EditPlace {
  id: number;
  /** Bild-Adresse (Datei in /bilder/orte/ oder altes Datenbank-Bild), null = kein Bild. */
  pictureUrl: string | null;
  name: string;
  description: string;
  lat: number;
  lng: number;
  opening: Opening[];
  locations: PlaceLocation[];
  categories: number[];
  /** Preisspanne in CHF (10–30), null = unbekannt */
  priceMin: number | null;
  priceMax: number | null;
  /** Link zur Website oder zum Menü, null = keiner */
  website: string | null;
}

/** Was an api/post-place.php geschickt wird. */
export interface SavePlace {
  /** -1 = neuer Ort */
  id: number;
  updatePicture: boolean;
  pictureData: string | undefined;
  name: string;
  description: string;
  lat: number;
  lng: number;
  opening: Opening[];
  /** Leer = nur ein Standort (lat/lng). */
  locations: PlaceLocation[];
  categories: number[];
  priceMin: number | null;
  priceMax: number | null;
  website: string | null;
}

/** Wochentage Montag ... Sonntag (Werte wie Date.getDay()). */
export const WEEKDAYS = [
  { value: 1, short: 'Mo', name: 'Montag' },
  { value: 2, short: 'Di', name: 'Dienstag' },
  { value: 3, short: 'Mi', name: 'Mittwoch' },
  { value: 4, short: 'Do', name: 'Donnerstag' },
  { value: 5, short: 'Fr', name: 'Freitag' },
  { value: 6, short: 'Sa', name: 'Samstag' },
  { value: 0, short: 'So', name: 'Sonntag' },
];
