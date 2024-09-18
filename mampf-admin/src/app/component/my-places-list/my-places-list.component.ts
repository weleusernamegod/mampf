import { Component, OnInit } from '@angular/core';
import { PlaceSummary } from '../../dto/place-summary';
import { Router } from '@angular/router';
import { LoadingSpinnerComponent } from '../loading-spinner/loading-spinner.component';

@Component({
  selector: 'mampf-my-places-list',
  standalone: true,
  imports: [LoadingSpinnerComponent],
  templateUrl: './my-places-list.component.html',
  styleUrl: './my-places-list.component.scss',
})
export class MyPlacesListComponent implements OnInit {
  myPlaces: PlaceSummary[] = [];

  constructor(private router: Router) {}

  ngOnInit(): void {
    fetch('api/get-own-places.php')
      .then(response => response.json())
      .then(data => {
        this.myPlaces = data;
      })
      .catch(error => {
        console.error('Could not fetch my places', error);
      });
  }

  onPlace(place: PlaceSummary) {
    this.router.navigate(['place', place.id]);
  }

  getPictureUrl(pictureId: number | undefined) {
    return pictureId
      ? `api/get-public-picture.php?id=${pictureId}`
      : 'assets/no-picture.jpg';
  }
}
