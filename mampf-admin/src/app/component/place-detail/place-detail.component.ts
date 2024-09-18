import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { Place } from '../../dto/place';
import { LoadingSpinnerComponent } from '../loading-spinner/loading-spinner.component';

@Component({
  selector: 'mampf-place-detail',
  standalone: true,
  imports: [LoadingSpinnerComponent],
  templateUrl: './place-detail.component.html',
  styleUrl: './place-detail.component.scss',
})
export class PlaceDetailComponent implements OnInit {
  place: Place | undefined;

  constructor(private route: ActivatedRoute) {}

  ngOnInit(): void {
    this.route.params.subscribe((params: Params) => {
      this.fetchPlace(params['id']);
    });
  }

  private fetchPlace(id: number) {
    fetch(`api/get-place.php?id=${id}`)
      .then(response => response.json())
      .then(data => {
        this.place = data;
      })
      .catch(error => {
        console.error('Could not fetch place', error);
      });
  }
}
