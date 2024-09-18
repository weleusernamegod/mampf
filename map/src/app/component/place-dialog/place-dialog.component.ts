import { Component, Input, OnChanges, SimpleChanges } from '@angular/core';
import { Place } from '../../dto/place';
import { OpenDaysComponent } from './open-days/open-days.component';

@Component({
  selector: 'mampf-place-dialog',
  standalone: true,
  imports: [OpenDaysComponent],
  templateUrl: './place-dialog.component.html',
  styleUrl: './place-dialog.component.scss',
})
export class PlaceDialogComponent implements OnChanges {
  @Input() place: Place | undefined = undefined;

  minimized = true;
  openingHours: string | undefined;
  pictureUrl: string | undefined;

  ngOnChanges(): void {
    if (this.place) {
      this.openingHours = this.generateOpeningHours(this.place);
      this.pictureUrl = this.place.pictureId
        ? `api/get-public-picture.php?id=${this.place.pictureId}`
        : 'assets/no-picture.jpg';
    }
  }

  toggleSize(): void {
    this.minimized = !this.minimized;
  }

  private generateOpeningHours(place: Place): string {
    const array = [];
    if (place.openingHours.morning) {
      array.push('Morgens');
    }
    if (place.openingHours.noon) {
      array.push('Mittags');
    }
    if (place.openingHours.evening) {
      array.push('Abends');
    }
    if (place.openingHours.night) {
      array.push('Nachts');
    }
    return array.join(', ');
  }
}
