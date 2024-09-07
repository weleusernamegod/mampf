import { OpenDays } from './open-days';
import { OpeningHours } from './opening-hours';

export interface Place {
  position: google.maps.LatLngLiteral;
  name: string;
  description: string;
  logo: string;
  openDays: OpenDays;
  openingHours: OpeningHours;
}
