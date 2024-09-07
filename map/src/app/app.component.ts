import { Component, OnInit, ViewChild } from '@angular/core';
import { Place } from './dto/place';
import { MapComponent } from './component/map/map.component';
import { DaySelectorComponent } from './component/day-selector/day-selector.component';
import { NavigationComponent } from './component/navigation/navigation.component';
import { AboutDialogComponent } from './component/about-dialog/about-dialog.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    MapComponent,
    DaySelectorComponent,
    NavigationComponent,
    AboutDialogComponent,
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent implements OnInit {
  @ViewChild(MapComponent) mapComponent: MapComponent | undefined = undefined;

  places: Place[] = [];
  aboutDialogVisible = false;

  ngOnInit(): void {
    fetch('assets/tmp/places.json')
      .then(response => response.json())
      .then(data => {
        this.places = data;
      })
      .catch(error => {
        console.error('Could not fetch places', error);
      });
  }

  onPlaceClicked(place: Place) {
    console.log('Place', place);
  }

  onDaySelected(day: number) {
    console.log('Day', day);
  }

  onLocateClicked() {
    this.mapComponent?.locate();
  }

  onAboutClicked() {
    this.aboutDialogVisible = !this.aboutDialogVisible;
  }

  onAddClicked() {
    window.location.href = 'https://www.google.com';
  }
}
