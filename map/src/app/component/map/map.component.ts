import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { GoogleMap, MapCircle, MapMarker } from '@angular/google-maps';
import { MAP_STYLES } from '../../util/map-styles';
import { Place } from '../../dto/place';

@Component({
  selector: 'mampf-map',
  standalone: true,
  imports: [GoogleMap, MapCircle, MapMarker],
  templateUrl: './map.component.html',
  styleUrl: './map.component.scss',
})
export class MapComponent implements OnInit {
  readonly MAX_ACCURACY_RADIUS = 300;
  readonly DETAIL_ZOOM = 16;
  readonly MAP_OPTIONS: google.maps.MapOptions = {
    styles: MAP_STYLES,
    zoomControl: false,
    mapTypeControl: false,
    streetViewControl: false,
    rotateControl: false,
    fullscreenControl: false,
    gestureHandling: 'greedy',
    clickableIcons: false,
    disableDefaultUI: true,
  };
  readonly ACCURACY_CIRCLE_OPTIONS: google.maps.CircleOptions = {
    strokeWeight: 0,
    fillColor: '#1473e7',
    fillOpacity: 0.3,
  };

  positionReceived = false;
  mapZoom = 9;
  mapCenter: google.maps.LatLngLiteral = { lat: 47.3769, lng: 8.5417 };
  accuracyCircleCenter: google.maps.LatLngLiteral = {
    lat: 47.3769,
    lng: 8.5417,
  };
  accuracyCircleRadius = 0;
  locationMarkerPosition: google.maps.LatLngLiteral = {
    lat: 47.3769,
    lng: 8.5417,
  };

  @Input() places: Place[] = [];
  @Output() placeClicked: EventEmitter<Place> = new EventEmitter<Place>();

  ngOnInit(): void {
    if (navigator.geolocation) {
      navigator.geolocation.watchPosition(
        (geolocationPosition: GeolocationPosition) =>
          this.onPositionUpdate(geolocationPosition)
      );
    }
  }

  locate(): void {
    this.goToPosition(this.locationMarkerPosition);
  }

  onPlaceClicked(place: Place) {
    this.goToPosition(place.position);
    this.placeClicked.emit(place);
  }

  private onPositionUpdate(geolocationPosition: GeolocationPosition): void {
    this.locationMarkerPosition = this.toLatLngLiteral(geolocationPosition);

    this.accuracyCircleCenter = this.toLatLngLiteral(geolocationPosition);
    this.accuracyCircleRadius =
      geolocationPosition.coords.accuracy > this.MAX_ACCURACY_RADIUS
        ? 0
        : geolocationPosition.coords.accuracy;

    if (!this.positionReceived) {
      this.positionReceived = true;
      this.locate();
    }
  }

  private toLatLngLiteral(
    geolocationPosition: GeolocationPosition
  ): google.maps.LatLngLiteral {
    return {
      lat: geolocationPosition.coords.latitude,
      lng: geolocationPosition.coords.longitude,
    };
  }

  private goToPosition(position: google.maps.LatLngLiteral) {
    this.mapZoom = this.DETAIL_ZOOM + Math.random(); // random offset used to trigger change
    this.mapCenter = { ...position };
  }
}
