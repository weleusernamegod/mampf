import { Category, CategoryList } from '../dto/category';
import { Place } from '../dto/place';

/** Gruppe mit ihren Kategorien, für Filter und Infobox. */
export interface GroupedCategories {
  key: string;
  name: string;
  categories: Category[];
}

/** Kategorien nach Gruppe ordnen, Gruppen ohne Einträge weglassen. */
export function groupCategories(
  list: CategoryList,
  categories: Category[]
): GroupedCategories[] {
  return list.groups
    .map(group => ({
      key: group.key,
      name: group.name,
      categories: categories
        .filter(category => category.group === group.key)
        .sort((a, b) => a.order - b.order),
    }))
    .filter(group => group.categories.length > 0);
}

/** Die Kategorien eines Shops (in der Reihenfolge der Liste). */
export function categoriesOf(place: Place, list: CategoryList): Category[] {
  return list.categories.filter(category => place.categories.includes(category.id));
}

/**
 * Shops, die zum Filter passen. Nichts gewählt = alle.
 * Innerhalb einer Gruppe reicht eine der gewählten Kategorien ("oder"),
 * zwischen den Gruppen muss jede Gruppe passen ("und").
 * Beispiel: (Italienisch oder Griechisch) und Vegan.
 */
export function filterByCategories(
  places: Place[],
  selectedIds: number[],
  list: CategoryList
): Place[] {
  if (selectedIds.length === 0) return places;

  const selectedByGroup = new Map<string, number[]>();
  for (const category of list.categories) {
    if (!selectedIds.includes(category.id)) continue;
    const ids = selectedByGroup.get(category.group) ?? [];
    ids.push(category.id);
    selectedByGroup.set(category.group, ids);
  }

  return places.filter(place =>
    [...selectedByGroup.values()].every(ids =>
      ids.some(id => place.categories.includes(id))
    )
  );
}
