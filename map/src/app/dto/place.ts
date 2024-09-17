import { OpenDays } from './open-days';
import { OpeningHours } from './opening-hours';

export interface Place {
  id: number;
  pictureId: number | null;
  position: google.maps.LatLngLiteral;
  name: string;
  description: string;
  openDays: OpenDays;
  openingHours: OpeningHours;
}
