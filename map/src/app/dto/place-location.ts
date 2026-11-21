/** Standort eines Foodtrucks an einem bestimmten Wochentag. */
export interface PlaceLocation {
  /** wie Date.getDay(): 0 = Sonntag, 1 = Montag, ... */
  weekday: number;
  position: google.maps.LatLngLiteral;
  /** z.B. "Helvetiaplatz", kann fehlen */
  label: string | null;
}
