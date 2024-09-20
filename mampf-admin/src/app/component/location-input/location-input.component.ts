import {
  Component,
  EventEmitter,
  Input,
  OnChanges,
  OnInit,
  Output,
  SimpleChanges,
} from '@angular/core';
import { GoogleMap, MapMarker } from '@angular/google-maps';

@Component({
  selector: 'mampf-location-input',
  standalone: true,
  imports: [GoogleMap, MapMarker],
  templateUrl: './location-input.component.html',
  styleUrl: './location-input.component.scss',
})
export class LocationInputComponent implements OnInit {
  readonly MAP_OPTIONS: google.maps.MapOptions = {
    mapTypeControl: false,
    streetViewControl: false,
    fullscreenControl: false,
    gestureHandling: 'greedy',
    clickableIcons: false,
  };

  @Input() lat: number | undefined;
  @Input() lng: number | undefined;
  @Output() latChange = new EventEmitter<number>();
  @Output() lngChange = new EventEmitter<number>();

  currentLocation: google.maps.LatLngLiteral = { lat: 47.3769, lng: 8.5417 };

  ngOnInit(): void {
    if (this.lat && this.lng) {
      this.currentLocation = { lat: this.lat, lng: this.lng };
    }
  }

  onMarkerLocationChanged(event: google.maps.MapMouseEvent): void {
    this.latChange.emit(event.latLng?.lat());
    this.lngChange.emit(event.latLng?.lng());
  }
}
