import { Component, EventEmitter, Input, Output } from '@angular/core';
import { CUISINES, Cuisine } from '../../util/cuisine-filter';

@Component({
  selector: 'mampf-navigation',
  standalone: true,
  imports: [],
  templateUrl: './navigation.component.html',
  styleUrl: './navigation.component.scss',
})
export class NavigationComponent {
  /** Angewendeter Küchen-Filter (IDs). Wird unter den Knöpfen angezeigt. */
  @Input() selectedCuisines: string[] = [];
  /** Ist die About-Seite offen? Dann erscheint rechts ein X zum Schliessen. */
  @Input() aboutOpen = false;
  /** Platzieren-Modus für einen neuen Ort aktiv? Dann erscheinen ✓ und ✕. */
  @Input() placing = false;

  @Output() placeConfirmed: EventEmitter<void> = new EventEmitter<void>();
  @Output() placeCancelled: EventEmitter<void> = new EventEmitter<void>();

  /** Klick auf das X bei einem Filter: diesen Filter entfernen. */
  @Output() cuisineRemoved: EventEmitter<string> = new EventEmitter<string>();
  @Output() filterClicked: EventEmitter<void> = new EventEmitter<void>();
  @Output() locateClicked: EventEmitter<void> = new EventEmitter<void>();
  @Output() aboutClicked: EventEmitter<void> = new EventEmitter<void>();
  @Output() addClicked: EventEmitter<void> = new EventEmitter<void>();
  @Output() closeClicked: EventEmitter<void> = new EventEmitter<void>();

  /** Ist ein Filter aktiv? Dann wird das Filter-Icon grün. */
  get filterActive(): boolean {
    return this.selectedCuisines.length > 0;
  }

  /** Die gewählten Küchen in der Reihenfolge wie im Filter-Dialog. */
  get activeCuisines(): Cuisine[] {
    return CUISINES.filter(cuisine =>
      this.selectedCuisines.includes(cuisine.id)
    );
  }

  onCuisineRemoved(id: string) {
    this.cuisineRemoved.emit(id);
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
