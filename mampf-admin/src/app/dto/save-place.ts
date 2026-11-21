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
}
