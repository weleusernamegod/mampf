import { Component, OnInit, ViewChild } from '@angular/core';
import { Place } from './dto/place';
import { MapComponent } from './component/map/map.component';
import { DaySelectorComponent } from './component/day-selector/day-selector.component';
import { NavigationComponent } from './component/navigation/navigation.component';
import { AboutDialogComponent } from './component/about-dialog/about-dialog.component';
import { PlaceDialogComponent } from './component/place-dialog/place-dialog.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    MapComponent,
    DaySelectorComponent,
    NavigationComponent,
    AboutDialogComponent,
    PlaceDialogComponent,
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent implements OnInit {
  @ViewChild(MapComponent) mapComponent: MapComponent | undefined = undefined;

  places: Place[] = [];
  filteredPlaces: Place[] = [];
  selectedPlace: Place | undefined = undefined;
  aboutDialogVisible = false;
  placeDialogVisible = false;

  ngOnInit(): void {
    fetch('api/get-public-places.php')
      .then(response => response.json())
      .then(data => {
        this.places = data;
        this.filteredPlaces = this.filterPlaces(
          this.places,
          new Date().getDay()
        );
      })
      .catch(error => {
        console.error('Could not fetch places', error);
      });
  }

  onPlaceClicked(place: Place) {
    this.selectedPlace = place;

    this.aboutDialogVisible = false;
    this.placeDialogVisible = true;
  }

  onDaySelected(day: number) {
    this.placeDialogVisible = false;
    this.aboutDialogVisible = false;

    this.filteredPlaces = this.filterPlaces(this.places, day);
  }

  onLocateClicked() {
    this.mapComponent?.locate();
  }

  onAboutClicked() {
    this.placeDialogVisible = false;
    this.aboutDialogVisible = !this.aboutDialogVisible;
  }

  onAddClicked() {
    window.location.href = './admin';
  }

  private filterPlaces(places: Place[], dayFilter: number): Place[] {
    return this.places.filter(place => this.isPlaceOpenOnDay(place, dayFilter));
  }

  private isPlaceOpenOnDay(place: Place, day: number): boolean {
    switch (day) {
      case 0:
        return place.openDays.sunday;
      case 1:
        return place.openDays.monday;
      case 2:
        return place.openDays.tuesday;
      case 3:
        return place.openDays.wednesday;
      case 4:
        return place.openDays.thursday;
      case 5:
        return place.openDays.friday;
      case 6:
        return place.openDays.saturday;
      default:
        return false;
    }
  }
}
