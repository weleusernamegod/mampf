import { Component, OnInit } from '@angular/core';
import { MyPlace } from '../../dto/my-place';
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
  myPlaces: MyPlace[] = [];

  constructor(private router: Router) {}

  ngOnInit(): void {
    fetch('assets/tmp/own-places.json')
      .then(response => response.json())
      .then(data => {
        this.myPlaces = data;
      })
      .catch(error => {
        console.error('Could not fetch my places', error);
      });
  }

  onRowClicked(myPlace: MyPlace) {
    this.router.navigate(['my-places', myPlace.id]);
  }
}
