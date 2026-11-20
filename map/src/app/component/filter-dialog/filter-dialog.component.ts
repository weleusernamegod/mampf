import {
  Component,
  EventEmitter,
  Input,
  OnChanges,
  Output,
} from '@angular/core';
import { Place } from '../../dto/place';
import { CUISINES, Cuisine, hasCuisine } from '../../util/cuisine-filter';

interface CuisineOption {
  cuisine: Cuisine;
  count: number; // so viele Shops passen
}

@Component({
  selector: 'mampf-filter-dialog',
  standalone: true,
  imports: [],
  templateUrl: './filter-dialog.component.html',
  styleUrl: './filter-dialog.component.scss',
})
export class FilterDialogComponent implements OnChanges {
  /** Alle Shops, um zu zählen, wie viele pro Küche passen. */
  @Input() places: Place[] = [];
  /** Aktuell angewendeter Filter. */
  @Input() selectedCuisines: string[] = [];

  /** Wird erst beim Klick auf "Anwenden" ausgelöst. */
  @Output() filterApplied: EventEmitter<string[]> = new EventEmitter<string[]>();

  options: CuisineOption[] = [];
  /** Auswahl im Dialog, noch nicht angewendet. */
  draft = new Set<string>();

  ngOnChanges(): void {
    this.options = CUISINES.map(cuisine => ({
      cuisine,
      count: this.places.filter(place => hasCuisine(place, cuisine)).length,
    }));
    this.draft = new Set(this.selectedCuisines);
  }

  toggle(id: string) {
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
