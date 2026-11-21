import { Component, OnInit, ViewChild } from '@angular/core';
import { Place } from './dto/place';
import { MapComponent } from './component/map/map.component';
import { DaySelectorComponent } from './component/day-selector/day-selector.component';
import { Slot } from './dto/opening';
import { NavigationComponent } from './component/navigation/navigation.component';
import { AboutDialogComponent } from './component/about-dialog/about-dialog.component';
import { PlaceDialogComponent } from './component/place-dialog/place-dialog.component';
import {
  FilterDialogComponent,
  FilterSelection,
} from './component/filter-dialog/filter-dialog.component';
import { filterByCategories } from './util/category-filter';
import { CategoryList } from './dto/category';
import { savePendingPosition } from './util/pending-position';
import { DEFAULT_SLOTS } from './util/place-util';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    MapComponent,
    DaySelectorComponent,
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
  /** Shops, die zum Filter passen (alle, wenn kein Filter aktiv). */
  visiblePlaces: Place[] = [];
  /** Alle Kategorien und Gruppen vom Server (api/get-categories.php). */
  categoryList: CategoryList = { groups: [], categories: [] };
  /** Angewendeter Filter: IDs der gewählten Kategorien. */
  selectedCategories: number[] = [];
  selectedDay: number = new Date().getDay();
  /** Tageszeiten aus dem Filter (Standard: Mittag). */
  selectedSlots: Slot[] = [...DEFAULT_SLOTS];
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
        this.updateVisiblePlaces();
      })
      .catch(error => {
        console.error('Could not fetch places', error);
      });

    fetch('api/get-categories.php')
      .then(response => response.json())
      .then(data => {
        this.categoryList = data;
        this.updateVisiblePlaces();
      })
      .catch(error => {
        console.error('Could not fetch categories', error);
      });
  }

  private updateVisiblePlaces() {
    this.visiblePlaces = filterByCategories(
      this.places,
      this.selectedCategories,
      this.categoryList
    );
  }

  /**
   * Klick auf eine leere Stelle der Karte (auch neben das Filter-Fenster):
   * About-Seite, Infobox und Filter schliessen. Der Filter bleibt dabei wie er war.
   */
  onMapClicked() {
    this.aboutDialogVisible = false;
    this.placeDialogVisible = false;
    this.filterDialogVisible = false;
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

  onLocateClicked() {
    this.mapComponent?.locate();
  }

  onFilterClicked() {
    this.placing = false;
    this.placeDialogVisible = false;
    this.aboutDialogVisible = false;
    this.filterDialogVisible = !this.filterDialogVisible;
  }

  onFilterApplied(selection: FilterSelection) {
    this.selectedCategories = selection.categories;
    this.selectedSlots = selection.slots;
    this.updateVisiblePlaces();
    this.filterDialogVisible = false;
  }

  /** Einzelnen Filter über das X unter der Navigation entfernen. */
  onCategoryRemoved(id: number) {
    this.selectedCategories = this.selectedCategories.filter(category => category !== id);
    this.updateVisiblePlaces();
  }

  /** X bei der Tageszeit unter der Navigation: wieder Mittag. */
  onSlotsReset() {
    this.selectedSlots = [...DEFAULT_SLOTS];
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
