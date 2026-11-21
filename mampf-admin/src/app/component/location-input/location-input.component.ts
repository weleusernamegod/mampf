import {
  Component,
  EventEmitter,
  Input,
  OnChanges,
  Output,
} from '@angular/core';
import { GoogleMap, MapMarker } from '@angular/google-maps';

@Component({
  selector: 'mampf-location-input',
  standalone: true,
  imports: [GoogleMap, MapMarker],
  templateUrl: './location-input.component.html',
  styleUrl: './location-input.component.scss',
})
export class LocationInputComponent implements OnChanges {
  readonly MAP_OPTIONS: google.maps.MapOptions = {
    mapTypeControl: false,
    streetViewControl: false,
    fullscreenControl: false,
    gestureHandling: 'greedy',
    clickableIcons: false,
  };

  @Input() lat: number | undefined;
  @Input() lng: number | undefined;
  /** Höhe der Karte in px. */
  @Input() height = 500;
  /** Überschrift und Hinweis über der Karte anzeigen. */
  @Input() showTitle = true;
  @Output() latChange = new EventEmitter<number>();
  @Output() lngChange = new EventEmitter<number>();

  /** Wo die Stecknadel steht. */
  currentLocation: google.maps.LatLngLiteral = { lat: 47.3769, lng: 8.5417 };
  /** Kartenmitte: folgt der Stecknadel nur, wenn sie von aussen gesetzt wird. */
  center: google.maps.LatLngLiteral = { lat: 47.3769, lng: 8.5417 };

  ngOnChanges(): void {
    if (this.lat === undefined || this.lng === undefined) return;
    const moved =
      this.lat !== this.currentLocation.lat ||
      this.lng !== this.currentLocation.lng;
    if (moved) {
      // Von aussen geändert (z.B. "wie Montag"): Karte dorthin schieben.
      // Nach dem Ziehen der Stecknadel ist die Position schon gleich,
      // dann springt die Karte nicht.
      this.currentLocation = { lat: this.lat, lng: this.lng };
      this.center = { ...this.currentLocation };
    }
  }

  onMarkerLocationChanged(event: google.maps.MapMouseEvent): void {
    const lat = event.latLng?.lat();
    const lng = event.latLng?.lng();
    if (lat === undefined || lng === undefined) return;
    this.currentLocation = { lat, lng };
    this.latChange.emit(lat);
    this.lngChange.emit(lng);
  }
}
