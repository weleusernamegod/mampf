import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { Place } from '../../dto/place';
import { LoadingSpinnerComponent } from '../loading-spinner/loading-spinner.component';
import { FormsModule } from '@angular/forms';
import { PictureInputComponent } from '../picture-input/picture-input.component';
import { LocationInputComponent } from '../location-input/location-input.component';

@Component({
  selector: 'mampf-place-detail',
  standalone: true,
  imports: [
    LoadingSpinnerComponent,
    PictureInputComponent,
    LocationInputComponent,
    FormsModule,
  ],
  templateUrl: './place-detail.component.html',
  styleUrl: './place-detail.component.scss',
})
export class PlaceDetailComponent implements OnInit {
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
        this.initFormFromPlace(id);
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

  onSaveClicked() {}

  private initFormFromPlace(id: number) {
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
      })
      .catch(error => {
        console.error('Could not fetch place', error);
      });
  }
}
