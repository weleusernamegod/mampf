/** Tageszeit in der Öffnungszeiten-Matrix. */
export type Slot = 'morning' | 'noon' | 'evening';

/** Ein Kreuz in der Öffnungszeiten-Matrix. weekday wie Date.getDay(): 0 = Sonntag ... */
export interface Opening {
  weekday: number;
  slot: Slot;
}

/** Standort eines Foodtrucks an einem Wochentag (nur bei "Mehrere Standorte"). */
export interface PlaceLocation {
  weekday: number;
  lat: number;
  lng: number;
  label: string | null;
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

export const SLOTS: { value: Slot; name: string }[] = [
  { value: 'morning', name: 'Morgen' },
  { value: 'noon', name: 'Mittag' },
  { value: 'evening', name: 'Abend' },
];
