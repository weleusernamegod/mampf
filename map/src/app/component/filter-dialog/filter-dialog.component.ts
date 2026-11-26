import {
  Component,
  EventEmitter,
  Input,
  OnChanges,
  Output,
} from '@angular/core';
import { NgTemplateOutlet } from '@angular/common';
import { Place } from '../../dto/place';
import { Category, CategoryList } from '../../dto/category';
import { Slot } from '../../dto/opening';
import { DEFAULT_SLOTS, SLOTS, isPlaceOpen } from '../../util/place-util';
import { PRICE_MAX, PRICE_MIN, matchesPrice } from '../../util/price';
import { PriceRangeInputComponent } from '../price-range-input/price-range-input.component';

/** Gruppe "Wartezeit": eigener Platz im Filter (unter dem Preis). */
const WAITING_GROUP = 'wartezeit';

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

/** Preisspanne im Filter in CHF. */
export interface PriceFilter {
  min: number;
  max: number;
}

/** Was im Filter gewählt ist: Kategorien, Tageszeiten und Preis (null = alle Preise). */
export interface FilterSelection {
  categories: number[];
  slots: Slot[];
  price: PriceFilter | null;
}

/** Klein, ohne Akzente: "Café" findet man auch mit "cafe". */
function normalize(text: string): string {
  return text.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().trim();
}

/** Passt der Name zur Suche? Jedes Wort der Suche muss irgendwo im Namen vorkommen. */
function matchesQuery(name: string, query: string): boolean {
  const words = normalize(query).split(/\s+/).filter(Boolean);
  const target = normalize(name);
  return words.length > 0 && words.every(word => target.includes(word));
}

@Component({
  selector: 'mampf-filter-dialog',
  standalone: true,
  imports: [PriceRangeInputComponent, NgTemplateOutlet],
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
  /** Aktuell gewählte Preisspanne (null = alle Preise). */
  @Input() selectedPrice: PriceFilter | null = null;
  /** Im Slider gewählter Wochentag, für die Anzahl pro Tageszeit. */
  @Input() day: number = new Date().getDay();

  /** "Anwenden" oder "Zurücksetzen" (dann mit leerem Filter). */
  @Output() filterApplied = new EventEmitter<FilterSelection>();

  sections: GroupSection[] = [];
  /** Wartezeit: steht direkt unter dem Preis, immer mit allen Chips. */
  waitingSection: GroupSection | undefined;
  slotOptions: SlotOption[] = [];
  /** Auswahl im Dialog, noch nicht angewendet. */
  draft = new Set<number>();
  draftSlots = new Set<Slot>();
  /** Preisregler im Dialog; ganz offen (10–30) = kein Preisfilter. */
  readonly PRICE_MIN = PRICE_MIN;
  readonly PRICE_MAX = PRICE_MAX;
  draftPriceMin: number = PRICE_MIN;
  draftPriceMax: number = PRICE_MAX;

  /** Text im Suchfeld: zeigt passende Chips aus allen Gruppen. */
  query = '';

  /** Tageszeiten, die zur Suche passen. */
  get searchSlots(): SlotOption[] {
    return this.slotOptions.filter(option => matchesQuery(option.name, this.query));
  }

  /** Kategorien aus allen Gruppen, die zur Suche passen. */
  get searchCategories(): CategoryOption[] {
    return [...(this.waitingSection ? [this.waitingSection] : []), ...this.sections]
      .flatMap(section => section.options)
      .filter(option => matchesQuery(option.category.name, this.query));
  }

  ngOnChanges(): void {
    this.draft = new Set(this.selectedCategories);
    this.draftSlots = new Set(this.selectedSlots);
    this.draftPriceMin = this.selectedPrice?.min ?? PRICE_MIN;
    this.draftPriceMax = this.selectedPrice?.max ?? PRICE_MAX;
    this.slotOptions = SLOTS.map(slot => ({
      slot: slot.value,
      name: slot.name,
      count: this.places.filter(place => isPlaceOpen(place, this.day, [slot.value])).length,
    }));
    // Pro Gruppe ein Abschnitt. Kategorien ohne Orte ausblenden
    // (ausser sie sind gerade gewählt, sonst könnte man sie nicht abwählen).
    // Ausnahme Wartezeit: immer alle Chips, wie bei der Tageszeit.
    const all = this.categoryList.groups
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
          .filter(
            option =>
              group.key === WAITING_GROUP ||
              option.count > 0 ||
              this.draft.has(option.category.id)
          ),
      }))
      .filter(section => section.options.length > 0);
    this.waitingSection = all.find(section => section.key === WAITING_GROUP);
    this.sections = all.filter(section => section.key !== WAITING_GROUP);
  }

  /** So viele Orte passen zum Preisregler (ganz offen: alle). */
  get priceCount(): number {
    const price = this.draftPrice;
    if (!price) return this.places.length;
    return this.places.filter(place =>
      matchesPrice(place.priceMin, place.priceMax, price.min, price.max)
    ).length;
  }

  /** Preisspanne aus dem Regler; null, wenn er ganz offen ist. */
  private get draftPrice(): PriceFilter | null {
    const open = this.draftPriceMin <= PRICE_MIN && this.draftPriceMax >= PRICE_MAX;
    return open ? null : { min: this.draftPriceMin, max: this.draftPriceMax };
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
    this.filterApplied.emit({ categories: [], slots: [...DEFAULT_SLOTS], price: null });
  }

  apply() {
    // Reihenfolge immer Morgen, Mittag, Abend
    const slots = SLOTS.map(slot => slot.value).filter(slot => this.draftSlots.has(slot));
    this.filterApplied.emit({ categories: [...this.draft], slots, price: this.draftPrice });
  }
}
