import { Component, EventEmitter, Input, Output } from '@angular/core';
import { Category, CategoryList } from '../../dto/category';

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
  /** Alle Kategorien, um die Namen der gewählten anzuzeigen. */
  @Input() categoryList: CategoryList = { groups: [], categories: [] };
  /** Ist die About-Seite offen? Dann erscheint rechts ein X zum Schliessen. */
  @Input() aboutOpen = false;
  /** Platzieren-Modus für einen neuen Ort aktiv? Dann erscheinen ✓ und ✕. */
  @Input() placing = false;

  @Output() placeConfirmed: EventEmitter<void> = new EventEmitter<void>();
  @Output() placeCancelled: EventEmitter<void> = new EventEmitter<void>();

  /** Klick auf das X bei einem Filter: diesen Filter entfernen. */
  @Output() categoryRemoved: EventEmitter<number> = new EventEmitter<number>();
  @Output() filterClicked: EventEmitter<void> = new EventEmitter<void>();
  @Output() locateClicked: EventEmitter<void> = new EventEmitter<void>();
  @Output() aboutClicked: EventEmitter<void> = new EventEmitter<void>();
  @Output() addClicked: EventEmitter<void> = new EventEmitter<void>();
  @Output() closeClicked: EventEmitter<void> = new EventEmitter<void>();

  /** Ist ein Filter aktiv? Dann wird das Filter-Icon grün. */
  get filterActive(): boolean {
    return this.selectedCategories.length > 0;
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

  onPlaceConfirmed() {
    this.placeConfirmed.emit();
  }

  onPlaceCancelled() {
    this.placeCancelled.emit();
  }

  onCloseClicked() {
    this.closeClicked.emit();
  }

  onAddClicked() {
    this.addClicked.emit();
  }
}
