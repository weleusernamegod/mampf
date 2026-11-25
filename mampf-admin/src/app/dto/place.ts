import { Opening, PlaceLocation } from './opening';

export interface Place {
  id: number;
  pictureId: number | undefined;
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
}
