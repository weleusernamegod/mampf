import { Component, EventEmitter, Input, Output } from '@angular/core';
import { priceText } from '../../util/price';
import { PriceFilter } from '../filter-dialog/filter-dialog.component';
import { Category, CategoryList } from '../../dto/category';
import { Slot } from '../../dto/opening';
import { DEFAULT_SLOTS, SLOTS, isCustomSlots } from '../../util/place-util';

@Component({
  selector: 'mampf-navigation',
  standalone: true,
  imports: [],
  templateUrl: './navigation.component.html',
  styleUrl: './navigation.component.scss',
})
export class NavigationComponent {
  /** Angewendeter Filter (Kategorie-IDs). Wird unter den Knöpfen angezeigt. */
  @Input() selectedCategories: number[] = [];
  /** Gewählte Tageszeiten. Erscheinen nur, wenn anders als der Standard (Mittag). */
  @Input() selectedSlots: Slot[] = DEFAULT_SLOTS;
  /** Preisspanne aus dem Filter (null = alle Preise). */
  @Input() selectedPrice: PriceFilter | null = null;
  /** Alle Kategorien, um die Namen der gewählten anzuzeigen. */
  @Input() categoryList: CategoryList = { groups: [], categories: [] };
  /** Platzieren-Modus für einen neuen Ort aktiv? Dann ist "+" grün und es erscheint ein Hinweis.
   *  (Bestätigen/Abbrechen sind unten, siehe app.component.html.) */
  @Input() placing = false;

  /** Klick auf das X bei einem Filter: diesen Filter entfernen. */
  @Output() categoryRemoved: EventEmitter<number> = new EventEmitter<number>();
  /** Klick auf das X bei der Tageszeit: zurück auf Mittag. */
  @Output() slotsReset: EventEmitter<void> = new EventEmitter<void>();
  /** X beim Preis: wieder alle Preise. */
  @Output() priceReset: EventEmitter<void> = new EventEmitter<void>();
  @Output() filterClicked: EventEmitter<void> = new EventEmitter<void>();
  @Output() locateClicked: EventEmitter<void> = new EventEmitter<void>();
  @Output() aboutClicked: EventEmitter<void> = new EventEmitter<void>();
  @Output() addClicked: EventEmitter<void> = new EventEmitter<void>();
  /** Würfel: zufälligen offenen Ort in der Nähe öffnen (wenn man nicht weiss, was essen). */
  @Output() randomClicked: EventEmitter<void> = new EventEmitter<void>();

  /** Ist ein Filter aktiv? Dann wird das Filter-Icon grün. */
  get filterActive(): boolean {
    return (
      this.selectedCategories.length > 0 ||
      isCustomSlots(this.selectedSlots) ||
      this.selectedPrice !== null
    );
  }

  /** z.B. "CHF 13–18"; undefined ohne Preisfilter. */
  get priceLabel(): string | undefined {
    return this.selectedPrice
      ? priceText(this.selectedPrice.min, this.selectedPrice.max)
      : undefined;
  }

  /** z.B. "Morgen, Abend" oder "Ganzer Tag"; undefined bei Standard (Mittag). */
  get slotLabel(): string | undefined {
    if (!isCustomSlots(this.selectedSlots)) return undefined;
    if (this.selectedSlots.length === 0) return 'Ganzer Tag';
    return SLOTS.filter(slot => this.selectedSlots.includes(slot.value))
      .map(slot => slot.name)
      .join(', ');
  }

  /** Die gewählten Kategorien in der Reihenfolge wie im Filter-Dialog. */
  get activeCategories(): Category[] {
    const groupOrder = this.categoryList.groups.map(group => group.key);
    return this.categoryList.categories
      .filter(category => this.selectedCategories.includes(category.id))
      .sort(
        (a, b) =>
          groupOrder.indexOf(a.group) - groupOrder.indexOf(b.group) ||
          a.order - b.order
      );
  }

  onCategoryRemoved(id: number) {
    this.categoryRemoved.emit(id);
  }

  onLocateClicked() {
    this.locateClicked.emit();
  }

  onFilterClicked() {
    this.filterClicked.emit();
  }

  onAboutClicked() {
    this.aboutClicked.emit();
  }

  onAddClicked() {
    this.addClicked.emit();
  }
}
