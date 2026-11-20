import { Component, OnInit, ViewChild } from '@angular/core';
import { Place } from './dto/place';
import { MapComponent } from './component/map/map.component';
import { DaySelectorComponent } from './component/day-selector/day-selector.component';
import { NavigationComponent } from './component/navigation/navigation.component';
import { AboutDialogComponent } from './component/about-dialog/about-dialog.component';
import { PlaceDialogComponent } from './component/place-dialog/place-dialog.component';
import { FilterDialogComponent } from './component/filter-dialog/filter-dialog.component';
import { filterByCuisines } from './util/cuisine-filter';

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
  /** Shops, die zum Küchen-Filter passen (alle, wenn kein Filter aktiv). */
  visiblePlaces: Place[] = [];
  /** Angewendeter Küchen-Filter, z.B. ['thai', 'greek']. */
  selectedCuisines: string[] = [];
  selectedDay: number = new Date().getDay();
  selectedPlace: Place | undefined = undefined;
  aboutDialogVisible = false;
  placeDialogVisible = false;
  filterDialogVisible = false;

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
    this.placeDialogVisible = false;
    this.filterDialogVisible = false;
    this.aboutDialogVisible = !this.aboutDialogVisible;
  }

  onAddClicked() {
    window.location.href = './admin';
  }
}
