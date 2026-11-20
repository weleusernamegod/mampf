import { Place } from '../dto/place';

/** Hat der Shop am Wochentag offen? day wie Date.getDay(): 0 = Sonntag, 1 = Montag, ... */
export function isPlaceOpenOnDay(place: Place, day: number): boolean {
  switch (day) {
    case 0:
      return place.openDays.sunday;
    case 1:
      return place.openDays.monday;
    case 2:
      return place.openDays.tuesday;
    case 3:
      return place.openDays.wednesday;
    case 4:
      return place.openDays.thursday;
    case 5:
      return place.openDays.friday;
    case 6:
      return place.openDays.saturday;
    default:
      return false;
  }
}
