import { Component, OnInit } from '@angular/core';
import { Place } from './dto/place';
import { Map } from "./component/map/map.component";

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [Map],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent implements OnInit {
  places: Place[] = [];

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
}
