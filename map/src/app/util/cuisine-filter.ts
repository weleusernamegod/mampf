import { Place } from '../dto/place';

/**
 * TEST-VERSION: Die Küche ist in der Datenbank noch nicht gespeichert.
 * Darum wird sie hier anhand von Stichworten in Name und Beschreibung erkannt.
 * Später besser ein eigenes Feld "Küche" in tbl_place, im Admin auswählbar.
 */
export interface Cuisine {
  id: string;
  label: string;
  keywords: string[]; // klein geschrieben
}

export const CUISINES: Cuisine[] = [
  { id: 'thai', label: 'Thai', keywords: ['thai'] },
  { id: 'greek', label: 'Griechisch', keywords: ['griech', 'greek'] },
  {
    id: 'italian',
    label: 'Italienisch',
    keywords: ['italien', 'pizza', 'pasta'],
  },
  {
    id: 'indian',
    label: 'Indisch',
    keywords: ['indisch', 'indian', 'delhi', 'curry'],
  },
  {
    id: 'asian',
    label: 'Asiatisch',
    keywords: ['asiat', 'japan', 'banh mi', 'momo', 'tibet'],
  },
  {
    id: 'mexican',
    label: 'Mexikanisch',
    keywords: ['mexikan', 'taco', 'burrito'],
  },
  {
    id: 'oriental',
    label: 'Kebab & Falafel',
    keywords: ['kebab', 'falafel', 'syrisch', 'paläst'],
  },
  { id: 'ethiopian', label: 'Äthiopisch', keywords: ['äthiop'] },
  { id: 'burger', label: 'Burger', keywords: ['burger'] },
  { id: 'veggie', label: 'Vegetarisch', keywords: ['vegetar', 'vegan'] },
];

export function hasCuisine(place: Place, cuisine: Cuisine): boolean {
  const text = `${place.name} ${place.description}`.toLowerCase();
  return cuisine.keywords.some(keyword => text.includes(keyword));
}

/** Alle Küchen, die zu einem Shop passen (z.B. für die Infobox). */
export function cuisinesOf(place: Place): Cuisine[] {
  return CUISINES.filter(cuisine => hasCuisine(place, cuisine));
}

/** Shops, die zu mindestens einer gewählten Küche passen. Nichts gewählt = alle. */
export function filterByCuisines(places: Place[], cuisineIds: string[]): Place[] {
  if (cuisineIds.length === 0) return places;
  const cuisines = CUISINES.filter(cuisine => cuisineIds.includes(cuisine.id));
  return places.filter(place =>
    cuisines.some(cuisine => hasCuisine(place, cuisine))
  );
}
