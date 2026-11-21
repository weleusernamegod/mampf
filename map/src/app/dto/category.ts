/** Gruppe von Kategorien, z.B. "Küche" oder "Wartezeit". */
export interface CategoryGroup {
  key: string;
  name: string;
  /** Genau eine Auswahl pro Ort (z.B. Art des Lokals, Wartezeit). */
  single: boolean;
}

export interface Category {
  id: number;
  group: string;
  name: string;
  order: number;
}

/** Antwort von api/get-categories.php */
export interface CategoryList {
  groups: CategoryGroup[];
  categories: Category[];
}
