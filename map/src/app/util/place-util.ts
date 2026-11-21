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

/** Tageszeit im Filter, wenn nichts anderes gewählt ist (auch nach "Zurücksetzen"). */
export const DEFAULT_SLOTS: Slot[] = ['noon'];

/** Ist die Tageszeit-Auswahl anders als der Standard (nur Mittag)? */
export function isCustomSlots(slots: Slot[]): boolean {
  return slots.length !== DEFAULT_SLOTS.length || slots.some(slot => !DEFAULT_SLOTS.includes(slot));
}

/**
 * Hat der Shop am Wochentag zu einer der gewählten Tageszeiten offen?
 * Keine Tageszeit gewählt = egal wann an diesem Tag.
 * day wie Date.getDay(): 0 = Sonntag, ...
 */
export function isPlaceOpen(place: Place, day: number, slots: Slot[]): boolean {
  if (slots.length === 0) {
    return place.opening.some(entry => entry.weekday === day);
  }
  return slots.some(slot => hasOpening(place.opening, day, slot));
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
 * falls er am gleichen Tag an zwei Orten ist). An seinen übrigen Standorten
 * erscheint er als kleiner grauer Punkt (wie geschlossen), damit man sieht,
 * wo er an anderen Tagen steht.
 */
export function pinsForDay(places: Place[], day: number, slots: Slot[]): PlacePin[] {
  const pins: PlacePin[] = [];
  for (const place of places) {
    const open = isPlaceOpen(place, day, slots);
    if (place.locations.length === 0) {
      pins.push({ key: `${place.id}`, place, position: place.position, open });
      continue;
    }
    // Ein Punkt pro Standort (gleiche Koordinaten an mehreren Tagen nur einmal).
    // Der Schlüssel hängt am Ort, so wechselt ein Punkt beim Tageswechsel
    // nur die Farbe statt zu springen.
    const byPosition = new Map<string, PlacePin>();
    for (const location of place.locations) {
      const key = `${place.id}@${location.position.lat},${location.position.lng}`;
      const here = location.weekday === day;
      const existing = byPosition.get(key);
      if (existing) {
        existing.open ||= here && open;
        continue;
      }
      byPosition.set(key, { key, place, position: location.position, open: here && open });
    }
    pins.push(...byPosition.values());
  }
  return pins;
}
