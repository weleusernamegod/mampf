import { Component, OnInit } from '@angular/core';
import { PlaceSummary } from '../../dto/place-summary';
import { Router } from '@angular/router';
import { LoadingSpinnerComponent } from '../loading-spinner/loading-spinner.component';
import { ActionStatus } from '../action-status-modal/action-status';
import { ActionStatusModalComponent } from '../action-status-modal/action-status-modal.component';

@Component({
  selector: 'mampf-my-places-list',
  standalone: true,
  imports: [LoadingSpinnerComponent, ActionStatusModalComponent],
  templateUrl: './my-places-list.component.html',
  styleUrl: './my-places-list.component.scss',
})
export class MyPlacesListComponent implements OnInit {
  actionStatus: ActionStatus = ActionStatus.NoOperation;
  myPlaces: PlaceSummary[] = [];

  constructor(private router: Router) {}

  ngOnInit(): void {
    this.loadPlaces();
  }

  onPlaceClicked(place: PlaceSummary) {
    this.router.navigate(['place', place.id]);
  }

  onPlaceDeleteClicked(place: PlaceSummary) {
    this.actionStatus = ActionStatus.Loading;

    fetch(`/api/delete-place.php?id=${place.id}`, {
      method: 'delete',
    })
      .then(response => {
        if (response.ok) {
          this.loadPlaces();
          this.actionStatus = ActionStatus.CompletedSuccess;
        } else {
          this.actionStatus = ActionStatus.CompletedError;
        }
      })
      .catch(() => {
        this.actionStatus = ActionStatus.CompletedError;
      });
  }

  onAddClicked() {
    this.router.navigate(['place', 'new']);
  }

  getPictureUrl(pictureUrl: string | null) {
    return pictureUrl ?? 'assets/marktstand.svg';
  }

  private loadPlaces() {
    this.myPlaces = [];

    fetch('/api/get-own-places.php')
      .then(response => response.json())
      .then(data => {
        this.myPlaces = data;
      })
      .catch(error => {
        console.error('Could not fetch my places', error);
      });
  }
}
