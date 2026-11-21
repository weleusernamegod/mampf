import {
  Component,
  EventEmitter,
  Input,
  OnChanges,
  Output,
} from '@angular/core';
import { Place } from '../../dto/place';
import { Category, CategoryList } from '../../dto/category';
import { Slot } from '../../dto/opening';
import { DEFAULT_SLOTS, SLOTS, isPlaceOpen } from '../../util/place-util';

interface CategoryOption {
  category: Category;
  count: number; // so viele Shops passen
}

interface GroupSection {
  key: string;
  name: string;
  options: CategoryOption[];
}

interface SlotOption {
  slot: Slot;
  name: string;
  count: number; // so viele Shops haben am gewählten Tag zu dieser Zeit offen
}

/** Was im Filter gewählt ist: Kategorien und Tageszeiten. */
export interface FilterSelection {
  categories: number[];
  slots: Slot[];
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
  /** Aktuell gewählte Tageszeiten. */
  @Input() selectedSlots: Slot[] = DEFAULT_SLOTS;
  /** Im Slider gewählter Wochentag, für die Anzahl pro Tageszeit. */
  @Input() day: number = new Date().getDay();

  /** "Anwenden" oder "Zurücksetzen" (dann mit leerem Filter). */
  @Output() filterApplied = new EventEmitter<FilterSelection>();

  sections: GroupSection[] = [];
  slotOptions: SlotOption[] = [];
  /** Auswahl im Dialog, noch nicht angewendet. */
  draft = new Set<number>();
  draftSlots = new Set<Slot>();

  ngOnChanges(): void {
    this.draft = new Set(this.selectedCategories);
    this.draftSlots = new Set(this.selectedSlots);
    this.slotOptions = SLOTS.map(slot => ({
      slot: slot.value,
      name: slot.name,
      count: this.places.filter(place => isPlaceOpen(place, this.day, [slot.value])).length,
    }));
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

  toggleSlot(slot: Slot) {
    if (this.draftSlots.has(slot)) {
      this.draftSlots.delete(slot);
    } else {
      this.draftSlots.add(slot);
    }
  }

  /** Alle Filter löschen (Tageszeit wieder Mittag) und Menü schliessen. */
  reset() {
    this.filterApplied.emit({ categories: [], slots: [...DEFAULT_SLOTS] });
  }

  apply() {
    // Reihenfolge immer Morgen, Mittag, Abend
    const slots = SLOTS.map(slot => slot.value).filter(slot => this.draftSlots.has(slot));
    this.filterApplied.emit({ categories: [...this.draft], slots });
  }
}
