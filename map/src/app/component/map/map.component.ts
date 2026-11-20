import {
  Component,
  EventEmitter,
  Input,
  NgZone,
  OnChanges,
  OnInit,
  Output,
  inject,
} from '@angular/core';
import { GoogleMap, MapCircle, MapMarker } from '@angular/google-maps';
import { MAP_STYLES } from '../../util/map-styles';
import { Place } from '../../dto/place';
import { PlacesOverlay, createPlacesOverlay } from './places-overlay';

/**
 * TEMPORÄR: fester Standort Zürich Kreis 4 (Langstrasse) statt dem echten
 * GPS-Standort. Bewusst auch live aktiv (Test-Phase): Alle Besucher starten
 * hier, der blaue Punkt zeigt nicht ihren echten Standort.
 * Zum Ausschalten auf null setzen, dann gilt wieder der echte GPS-Standort.
 */
const FIXED_LOCATION: google.maps.LatLngLiteral | null = {
  lat: 47.3772,
  lng: 8.5290,
};

@Component({
  selector: 'mampf-map',
  standalone: true,
  imports: [GoogleMap, MapCircle, MapMarker],
  templateUrl: './map.component.html',
  styleUrl: './map.component.scss',
})
export class MapComponent implements OnInit, OnChanges {
  private readonly zone = inject(NgZone);
  private placesOverlay: PlacesOverlay | undefined = undefined;

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
  /** Blaue Kugel für den eigenen Standort, mit Ankerpunkt in der Mitte. */
  positionIcon: google.maps.Icon | undefined = undefined;
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

  /** Alle Shops, offene und geschlossene. */
  @Input() places: Place[] = [];
  /** Gewählter Wochentag wie Date.getDay(): 0 = Sonntag, 1 = Montag, ... */
  @Input() day: number = new Date().getDay();
  @Output() placeClicked: EventEmitter<Place> = new EventEmitter<Place>();

  ngOnInit(): void {
    if (FIXED_LOCATION) {
      this.onPositionUpdate(FIXED_LOCATION, 0);
      return;
    }
    if (navigator.geolocation) {
      navigator.geolocation.watchPosition(
        (geolocationPosition: GeolocationPosition) =>
          this.onPositionUpdate(
            this.toLatLngLiteral(geolocationPosition),
            geolocationPosition.coords.accuracy
          )
      );
    }
  }

  ngOnChanges(): void {
    this.placesOverlay?.update(this.places, this.day);
  }

  onMapInitialized(map: google.maps.Map) {
    // Ohne "anchor" setzt Google den Ankerpunkt unten in die Mitte (wie bei
    // einer Stecknadel), dann sitzt die Kugel über dem echten Standort.
    // Das Bild ist 26x26px, die Mitte also bei 13/13.
    this.positionIcon = {
      url: 'assets/marker/position.svg',
      anchor: new google.maps.Point(13, 13),
    };
    this.placesOverlay = createPlacesOverlay(map, place =>
      this.zone.run(() => this.onPlaceClicked(place))
    );
    this.placesOverlay.update(this.places, this.day);
  }

  locate(): void {
    if (this.positionReceived) {
      this.goToPosition(this.locationMarkerPosition);
    }
  }

  onPlaceClicked(place: Place) {
    this.goToPosition(place.position);
    this.placeClicked.emit(place);
  }

  private onPositionUpdate(
    position: google.maps.LatLngLiteral,
    accuracy: number
  ): void {
    this.locationMarkerPosition = { ...position };

    this.accuracyCircleCenter = { ...position };
    this.accuracyCircleRadius =
      accuracy > this.MAX_ACCURACY_RADIUS ? 0 : accuracy;

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
