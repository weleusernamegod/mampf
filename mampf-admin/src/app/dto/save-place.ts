import { Opening, PlaceLocation } from './opening';

export interface SavePlace {
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
  /** IDs der gewählten Kategorien */
  categories: number[];
  /** Preisspanne in CHF (10–30), null = unbekannt */
  priceMin: number | null;
  priceMax: number | null;
}
