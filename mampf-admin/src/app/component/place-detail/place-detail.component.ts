import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { Place } from '../../dto/place';
import { LoadingSpinnerComponent } from '../loading-spinner/loading-spinner.component';
import { FormsModule, FormSubmittedEvent } from '@angular/forms';
import { PictureInputComponent } from '../picture-input/picture-input.component';
import { LocationInputComponent } from '../location-input/location-input.component';
import { ActionStatusModalComponent } from '../action-status-modal/action-status-modal.component';
import { ActionStatus } from '../action-status-modal/action-status';
import { SavePlace } from '../../dto/save-place';

@Component({
  selector: 'mampf-place-detail',
  standalone: true,
  imports: [
    LoadingSpinnerComponent,
    PictureInputComponent,
    LocationInputComponent,
    ActionStatusModalComponent,
    FormsModule,
  ],
  templateUrl: './place-detail.component.html',
  styleUrl: './place-detail.component.scss',
})
export class PlaceDetailComponent implements OnInit {
  isLoading = false;
  actionStatus: ActionStatus = ActionStatus.NoOperation;

  place: Place | undefined;

  pictureChanged = false;
  newPictureData: string | undefined;

  lat = 47.3769;
  lng = 8.5417;

  name = '';
  description = '';
  openSunday = false;
  openMonday = false;
  openTuesday = false;
  openWednesday = false;
  openThursday = false;
  openFriday = false;
  openSaturday = false;
  openMorning = false;
  openNoon = false;
  openEvening = false;
  openNight = false;

  constructor(private route: ActivatedRoute) {}

  ngOnInit(): void {
    this.route.params.subscribe((params: Params) => {
      const id = params['id'];
      if (id) {
        this.initFromExistingPlace(id);
      }
    });
  }

  onPictureDeleted() {
    this.pictureChanged = true;
    this.newPictureData = undefined;
  }

  onPictureUploaded(pictureData: string) {
    this.pictureChanged = true;
    this.newPictureData = pictureData;
  }

  onFormSubmitted(event: SubmitEvent) {
    this.actionStatus = ActionStatus.Loading;

    const savePlace = {
      id: this.place ? this.place.id : -1,
      updatePicture: this.pictureChanged,
      pictureData: this.newPictureData,
      name: this.name,
      description: this.description,
      lat: this.lat,
      lng: this.lng,
      openSunday: this.openSunday,
      openMonday: this.openMonday,
      openTuesday: this.openTuesday,
      openWednesday: this.openWednesday,
      openThursday: this.openThursday,
      openFriday: this.openFriday,
      openSaturday: this.openSaturday,
      openMorning: this.openMorning,
      openNoon: this.openNoon,
      openEvening: this.openEvening,
      openNight: this.openNight,
    } as SavePlace;

    fetch('api/post-place.php', {
      method: 'post',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(savePlace),
    }).then((response) => {
      this.actionStatus = response.ok ? ActionStatus.CompletedSuccess : ActionStatus.CompletedError;
    }).catch(() => {
      this.actionStatus = ActionStatus.CompletedError;
    });

    event.preventDefault();
  }

  private initFromExistingPlace(id: number) {
    this.isLoading = true;

    fetch(`api/get-place.php?id=${id}`)
      .then(response => response.json())
      .then(data => {
        this.place = data;
        this.name = data.name;
        this.description = data.description;
        this.lat = data.lat;
        this.lng = data.lng;
        this.openSunday = data.openSunday;
        this.openMonday = data.openMonday;
        this.openTuesday = data.openTuesday;
        this.openWednesday = data.openWednesday;
        this.openThursday = data.openThursday;
        this.openFriday = data.openFriday;
        this.openSaturday = data.openSaturday;
        this.openMorning = data.openMorning;
        this.openNoon = data.openNoon;
        this.openEvening = data.openEvening;
        this.openNight = data.openNight;

        this.isLoading = false;
      })
      .catch(error => {
        console.error('Could not fetch place', error);
      });
  }
}
