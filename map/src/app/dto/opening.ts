/** Tageszeit in der Öffnungszeiten-Matrix. */
export type Slot = 'morning' | 'noon' | 'evening';

/** Ein Kreuz in der Öffnungszeiten-Matrix. */
export interface Opening {
  /** wie Date.getDay(): 0 = Sonntag, 1 = Montag, ... */
  weekday: number;
  slot: Slot;
}
