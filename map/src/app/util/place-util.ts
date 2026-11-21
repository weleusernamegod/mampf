import { Opening, Slot } from '../dto/opening';
import { Place } from '../dto/place';

/** Wochentage in der Reihenfolge Montag ... Sonntag (Werte wie Date.getDay()). */
export const WEEKDAYS = [
  { value: 1, short: 'Mo', name: 'Montag' },
  { value: 2, short: 'Di', name: 'Dienstag' },
  { value: 3, short: 'Mi', name: 'Mittwoch' },
  { value: 4, short: 'Do', name: 'Donnerstag' },
  { value: 5, short: 'Fr', name: 'Freitag' },
  { value: 6, short: 'Sa', name: 'Samstag' },
  { value: 0, short: 'So', name: 'Sonntag' },
];

export const SLOTS: { value: Slot; name: string }[] = [
  { value: 'morning', name: 'Morgen' },
  { value: 'noon', name: 'Mittag' },
  { value: 'evening', name: 'Abend' },
];

export function hasOpening(opening: Opening[], day: number, slot: Slot): boolean {
  return opening.some(entry => entry.weekday === day && entry.slot === slot);
}

/** Hat der Shop am Wochentag zur Tageszeit offen? day wie Date.getDay(): 0 = Sonntag, ... */
export function isPlaceOpen(place: Place, day: number, slot: Slot): boolean {
  return hasOpening(place.opening, day, slot);
}

/** Ein Punkt auf der Karte: ein Shop an einem seiner Standorte. */
export interface PlacePin {
  /** Eindeutig pro Punkt, z.B. "12" oder bei mehreren Standorten "12-0", "12-1". */
  key: string;
  place: Place;
  position: google.maps.LatLngLiteral;
  open: boolean;
}

/**
 * Wo steht der Shop am gewählten Tag? Normaler Shop: immer am gleichen Ort.
 * Foodtruck mit mehreren Standorten: am Standort dieses Tages (auch zwei,
 * falls er am gleichen Tag an zwei Orten ist). Ohne Standort an dem Tag
 * erscheint er nicht.
 */
export function pinsForDay(places: Place[], day: number, slot: Slot): PlacePin[] {
  const pins: PlacePin[] = [];
  for (const place of places) {
    const open = isPlaceOpen(place, day, slot);
    if (place.locations.length === 0) {
      pins.push({ key: `${place.id}`, place, position: place.position, open });
      continue;
    }
    place.locations
      .filter(location => location.weekday === day)
      .forEach((location, index) =>
        pins.push({
          key: `${place.id}-${index}`,
          place,
          position: location.position,
          open,
        })
      );
  }
  return pins;
}
