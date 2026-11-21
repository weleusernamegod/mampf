import {
  Component,
  EventEmitter,
  Input,
  OnChanges,
  Output,
} from '@angular/core';
import { Place } from '../../dto/place';
import { Category, CategoryList } from '../../dto/category';

interface CategoryOption {
  category: Category;
  count: number; // so viele Shops passen
}

interface GroupSection {
  key: string;
  name: string;
  options: CategoryOption[];
}

@Component({
  selector: 'mampf-filter-dialog',
  standalone: true,
  imports: [],
  templateUrl: './filter-dialog.component.html',
  styleUrl: './filter-dialog.component.scss',
})
export class FilterDialogComponent implements OnChanges {
  /** Alle Shops, um zu zählen, wie viele pro Kategorie passen. */
  @Input() places: Place[] = [];
  /** Alle Kategorien und Gruppen vom Server. */
  @Input() categoryList: CategoryList = { groups: [], categories: [] };
  /** Aktuell angewendeter Filter (Kategorie-IDs). */
  @Input() selectedCategories: number[] = [];

  /** Wird erst beim Klick auf "Anwenden" ausgelöst. */
  @Output() filterApplied: EventEmitter<number[]> = new EventEmitter<number[]>();

  sections: GroupSection[] = [];
  /** Auswahl im Dialog, noch nicht angewendet. */
  draft = new Set<number>();

  ngOnChanges(): void {
    this.draft = new Set(this.selectedCategories);
    // Pro Gruppe ein Abschnitt. Kategorien ohne Orte ausblenden
    // (ausser sie sind gerade gewählt, sonst könnte man sie nicht abwählen).
    this.sections = this.categoryList.groups
      .map(group => ({
        key: group.key,
        name: group.name,
        options: this.categoryList.categories
          .filter(category => category.group === group.key)
          .sort((a, b) => a.order - b.order)
          .map(category => ({
            category,
            count: this.places.filter(place =>
              place.categories.includes(category.id)
            ).length,
          }))
          .filter(option => option.count > 0 || this.draft.has(option.category.id)),
      }))
      .filter(section => section.options.length > 0);
  }

  toggle(id: number) {
    if (this.draft.has(id)) {
      this.draft.delete(id);
    } else {
      this.draft.add(id);
    }
  }

  reset() {
    this.draft.clear();
  }

  apply() {
    this.filterApplied.emit([...this.draft]);
  }
}
