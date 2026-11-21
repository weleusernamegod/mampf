import { Component, OnInit, ViewChild } from '@angular/core';
import { Place } from './dto/place';
import { MapComponent } from './component/map/map.component';
import { DaySelectorComponent } from './component/day-selector/day-selector.component';
import { SlotSelectorComponent } from './component/slot-selector/slot-selector.component';
import { Slot } from './dto/opening';
import { NavigationComponent } from './component/navigation/navigation.component';
import { AboutDialogComponent } from './component/about-dialog/about-dialog.component';
import { PlaceDialogComponent } from './component/place-dialog/place-dialog.component';
import { FilterDialogComponent } from './component/filter-dialog/filter-dialog.component';
import { filterByCuisines } from './util/cuisine-filter';
import { savePendingPosition } from './util/pending-position';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    MapComponent,
    DaySelectorComponent,
    SlotSelectorComponent,
    NavigationComponent,
    AboutDialogComponent,
    PlaceDialogComponent,
    FilterDialogComponent,
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent implements OnInit {
  @ViewChild(MapComponent) mapComponent: MapComponent | undefined = undefined;

  /** Alle Shops vom Server. */
  places: Place[] = [];
  /** Shops, die zum Küchen-Filter passen (alle, wenn kein Filter aktiv). */
  visiblePlaces: Place[] = [];
  /** Angewendeter Küchen-Filter, z.B. ['thai', 'greek']. */
  selectedCuisines: string[] = [];
  selectedDay: number = new Date().getDay();
  /** Mittag oder Abend (Standard: Mittag). */
  selectedSlot: Slot = 'noon';
  selectedPlace: Place | undefined = undefined;
  aboutDialogVisible = false;
  placeDialogVisible = false;
  filterDialogVisible = false;
  /** Platzieren-Modus: neuen Ort mit dem roten Punkt in der Kartenmitte wählen. */
  placing = false;

  ngOnInit(): void {
    fetch('api/get-public-places.php')
      .then(response => response.json())
      .then(data => {
        this.places = data;
        this.visiblePlaces = filterByCuisines(this.places, this.selectedCuisines);
      })
      .catch(error => {
        console.error('Could not fetch places', error);
      });
  }

  /** Klick auf eine leere Stelle der Karte: About-Seite und Infobox schliessen. */
  onMapClicked() {
    this.aboutDialogVisible = false;
    this.placeDialogVisible = false;
  }

  onPlaceClicked(place: Place) {
    this.selectedPlace = place;

    this.aboutDialogVisible = false;
    this.filterDialogVisible = false;
    this.placeDialogVisible = true;
  }

  onDaySelected(day: number) {
    this.placeDialogVisible = false;
    this.aboutDialogVisible = false;
    this.filterDialogVisible = false;

    this.selectedDay = day;
  }

  onSlotSelected(slot: Slot) {
    this.placeDialogVisible = false;
    this.aboutDialogVisible = false;
    this.filterDialogVisible = false;

    this.selectedSlot = slot;
  }

  onLocateClicked() {
    this.mapComponent?.locate();
  }

  onFilterClicked() {
    this.placing = false;
    this.placeDialogVisible = false;
    this.aboutDialogVisible = false;
    this.filterDialogVisible = !this.filterDialogVisible;
  }

  onFilterApplied(cuisines: string[]) {
    this.selectedCuisines = cuisines;
    this.visiblePlaces = filterByCuisines(this.places, cuisines);
    this.filterDialogVisible = false;
  }

  /** Einzelnen Filter über das X unter der Navigation entfernen. */
  onCuisineRemoved(id: string) {
    this.onFilterApplied(this.selectedCuisines.filter(cuisine => cuisine !== id));
  }

  onAboutClicked() {
    this.placing = false;
    this.placeDialogVisible = false;
    this.filterDialogVisible = false;
    this.aboutDialogVisible = !this.aboutDialogVisible;
  }

  onAddClicked() {
    // "+" schaltet den Platzieren-Modus ein bzw. wieder aus
    this.placing = !this.placing;
    this.placeDialogVisible = false;
    this.aboutDialogVisible = false;
    this.filterDialogVisible = false;
  }

  /** ✓ im Platzieren-Modus: Position merken und Formular "Ort hinzufügen" öffnen. */
  onPlaceConfirmed() {
    const center = this.mapComponent?.getCenter();
    if (center) {
      savePendingPosition(center);
    }
    // Ohne Login leitet der Admin-Bereich zuerst zum Login weiter.
    // Die Position bleibt im Browser gespeichert.
    window.location.href = './admin/place/new';
  }
}
