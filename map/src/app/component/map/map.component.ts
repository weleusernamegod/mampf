import { Component, EventEmitter, Input, NgZone, OnChanges, OnInit, Output, inject, HostBinding } from '@angular/core';
import { GoogleMap, MapCircle, MapMarker } from '@angular/google-maps';
import { mapStyles } from '../../util/map-styles';
import { currentHue } from '../../util/color';
import { Place } from '../../dto/place';
import { PlacesOverlay, createPlacesOverlay } from './places-overlay';
import { Slot } from '../../dto/opening';
import { DEFAULT_SLOTS, PlacePin, pinsForDay } from '../../util/place-util';
import { isTestBuild } from '../../util/test-build';
import { CompassWatcher, HeadingOverlay, createHeadingOverlay } from './heading-overlay';

/**
 * Nur im Test-Build (lokal oder Test-Subdomain): fester Standort Zürich Kreis 4
 * (Langstrasse) statt dem echten GPS-Standort, damit man die Orte dort sieht.
 * Live auf mampf.io gilt immer der echte Standort des Besuchers.
 */
const FIXED_LOCATION: google.maps.LatLngLiteral | null = isTestBuild()
  ? { lat: 47.3772, lng: 8.529 }
  : null;
/** Im Test-Build ein Genauigkeitskreis von so vielen Metern, damit man ihn sieht. */
const FIXED_ACCURACY = 40;

/** Blau des eigenen Standorts aus vars.scss (--location-blue). */
function locationBlue(): string {
  return (
    getComputedStyle(document.documentElement).getPropertyValue('--location-blue').trim() ||
    'blue'
  );
}

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
  /** Ein Ort wurde gezielt geöffnet: nicht automatisch zum eigenen Standort springen. */
  private skipAutoLocate = false;
  readonly MAP_OPTIONS: google.maps.MapOptions = {
    styles: mapStyles(currentHue()),
    zoomControl: false,
    mapTypeControl: false,
    streetViewControl: false,
    rotateControl: false,
    fullscreenControl: false,
    gestureHandling: 'greedy',
    clickableIcons: false,
    disableDefaultUI: true,
  };
  /** Durchsichtiger blauer Kreis um den eigenen Standort: so ungenau ist das GPS gerade. */
  readonly ACCURACY_CIRCLE_OPTIONS: google.maps.CircleOptions = {
    strokeColor: locationBlue(),
    strokeOpacity: 0.35,
    strokeWeight: 1,
    fillColor: locationBlue(),
    fillOpacity: 0.15,
    clickable: false,
  };
  /** Blickrichtung (Fächer unter dem blauen Punkt). */
  private headingOverlay: HeadingOverlay | undefined = undefined;
  /** Richtung vom Kompass des Handys; solange es keine gibt, die Fahrtrichtung vom GPS. */
  private compassHeading: number | null = null;
  private readonly compass = new CompassWatcher(heading => {
    this.compassHeading = heading;
    this.headingOverlay?.setHeading(heading);
  });

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
  /** Samstag/Sonntag: offene Orte und Blasen weinrot wie das Wochenende im Tages-Wähler. */
  @HostBinding('class.weekend') get weekend(): boolean {
    return this.day === 0 || this.day === 6;
  }
  /** Gewählte Tageszeiten aus dem Filter (Standard: Mittag). */
  @Input() slots: Slot[] = DEFAULT_SLOTS;
  /** Platzieren-Modus: Shops ausblenden, roter Punkt in der Kartenmitte. */
  @Input() placing = false;
  /** Klick auf eine leere Stelle der Karte (nicht auf einen Shop). */
  @Output() mapClicked: EventEmitter<void> = new EventEmitter<void>();
  @Output() placeClicked: EventEmitter<Place> = new EventEmitter<Place>();

  ngOnInit(): void {
    this.compass.start();
    if (FIXED_LOCATION) {
      this.onPositionUpdate(FIXED_LOCATION, FIXED_ACCURACY);
      return;
    }
    if (navigator.geolocation) {
      navigator.geolocation.watchPosition(
        (geolocationPosition: GeolocationPosition) => {
          this.onPositionUpdate(
            this.toLatLngLiteral(geolocationPosition),
            geolocationPosition.coords.accuracy
          );
          // Ohne Kompass: beim Gehen/Fahren zeigt das GPS die Bewegungsrichtung
          const { heading, speed } = geolocationPosition.coords;
          if (this.compassHeading === null && heading !== null && (speed ?? 0) > 0.5) {
            this.headingOverlay?.setHeading(heading);
          }
        },
        undefined,
        { enableHighAccuracy: true }
      );
    }
  }

  /** Wird die Karte gerade verschoben? Dann hebt sich der rote Punkt leicht an. */
  mapMoving = false;
  private map: google.maps.Map | undefined = undefined;

  ngOnChanges(): void {
    this.placesOverlay?.setHidden(this.placing);
    this.placesOverlay?.update(this.pins());
  }

  /** Punkte für den gewählten Tag (Foodtrucks am Standort dieses Tages). */
  private pins(): PlacePin[] {
    return pinsForDay(this.places, this.day, this.slots);
  }

  /** Aktuelle Kartenmitte = Position des roten Punkts im Platzieren-Modus. */
  getCenter(): google.maps.LatLngLiteral | undefined {
    return this.map?.getCenter()?.toJSON();
  }

  onMapInitialized(map: google.maps.Map) {
    this.map = map;
    // Neue Oberflächenfarbe (Farbregler auf der About-Seite): Karte mitfärben
    window.addEventListener('mampf-hue', () => map.setOptions({ styles: mapStyles(currentHue()) }));
    map.addListener('dragstart', () =>
      this.zone.run(() => (this.mapMoving = true))
    );
    map.addListener('dragend', () =>
      this.zone.run(() => (this.mapMoving = false))
    );
    // Ohne "anchor" setzt Google den Ankerpunkt unten in die Mitte (wie bei
    // einer Stecknadel), dann sitzt die Kugel über dem echten Standort.
    // Das Bild ist 26x26px, die Mitte also bei 13/13.
    // In zone.run, damit Angular den Punkt sofort zeichnet (nicht erst bei der ersten Berührung)
    this.zone.run(() => {
      this.positionIcon = {
        url: 'assets/marker/position.svg',
        anchor: new google.maps.Point(13, 13),
      };
    });
    this.headingOverlay = createHeadingOverlay(map);
    if (this.positionReceived) this.headingOverlay.setPosition(this.locationMarkerPosition);
    if (this.compassHeading !== null) this.headingOverlay.setHeading(this.compassHeading);
    this.placesOverlay = createPlacesOverlay(map, pin =>
      this.zone.run(() => this.onPinClicked(pin))
    );
    this.placesOverlay.setHidden(this.placing);
    this.placesOverlay.update(this.pins());
  }

  /** Karte auf einen Ort ausrichten (z.B. zurück vom Login). Danach nicht mehr zum eigenen Standort springen. */
  showPlace(position: google.maps.LatLngLiteral): void {
    this.skipAutoLocate = true;
    this.goToPosition(position);
  }

  locate(): void {
    // iPhone: Blickrichtung erst nach Erlaubnis, und fragen darf man nur beim Antippen
    this.compass.requestPermission();
    if (this.positionReceived) {
      this.goToPosition(this.locationMarkerPosition);
    }
  }

  onPinClicked(pin: PlacePin) {
    // Nur hinschieben, die Zoomstufe bleibt wie sie ist
    this.map?.panTo(pin.position);
    this.placeClicked.emit(pin.place);
  }

  private onPositionUpdate(
    position: google.maps.LatLngLiteral,
    accuracy: number
  ): void {
    this.locationMarkerPosition = { ...position };
    this.headingOverlay?.setPosition(position);

    this.accuracyCircleCenter = { ...position };
    this.accuracyCircleRadius =
      accuracy > this.MAX_ACCURACY_RADIUS ? 0 : accuracy;

    if (!this.positionReceived) {
      this.positionReceived = true;
      if (!this.skipAutoLocate) this.locate();
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
