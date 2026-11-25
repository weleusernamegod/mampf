/** Grenzen des Preisreglers in CHF (ganze Franken). 10 heisst "10.– oder
 *  weniger", 30 heisst "30.– oder mehr". Gleich im Admin und im Filter. */
export const PRICE_MIN = 10;
export const PRICE_MAX = 30;

/** Kurz für Chips, z.B. "CHF 13–18", "CHF bis 18", "CHF ab 15". */
export function priceText(min: number, max: number): string {
  const lowest = min <= PRICE_MIN;
  const highest = max >= PRICE_MAX;
  if (lowest && highest) return `CHF ${PRICE_MIN}–${PRICE_MAX}+`;
  if (min === max) return `CHF ${min}`;
  if (lowest) return `CHF bis ${max}`;
  if (highest) return `CHF ab ${min}`;
  return `CHF ${min}–${max}`;
}

/** Passt der Preis eines Ortes zur Spanne im Filter (überschneiden sich)?
 *  Orte ohne Preis passen nicht, sobald nach Preis gefiltert wird. */
export function matchesPrice(
  placeMin: number | null,
  placeMax: number | null,
  filterMin: number,
  filterMax: number
): boolean {
  if (placeMin == null || placeMax == null) return false;
  return placeMin <= filterMax && placeMax >= filterMin;
}
