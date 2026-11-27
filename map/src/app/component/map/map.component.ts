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

/** Luftlinie zwischen zwei Punkten in Metern. */
function distanceInMeters(a: google.maps.LatLngLiteral, b: google.maps.LatLngLiteral): number {
  const rad = Math.PI / 180;
  const dLat = (b.lat - a.lat) * rad;
  const dLng = (b.lng - a.lng) * rad;
  const h =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(a.lat * rad) * Math.cos(b.lat * rad) * Math.sin(dLng / 2) ** 2;
  return 2 * 6371000 * Math.asin(Math.sqrt(h));
}

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
  /** Würfel: so weit (Meter) darf ein zufälliger Ort höchstens weg sein. */
  readonly RANDOM_RADIUS = 250;
  /** Würfel: nichts im Umkreis? Dann unter so vielen nächsten Orten auswählen. */
  readonly RANDOM_NEAREST = 10;
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
  /** Startansicht: Stadt Zürich (bis man auf Lokalisieren tippt). */
  mapZoom = 12;
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
  /** Ort mit offener Infobox: sein Punkt wird hervorgehoben. */
  @Input() selectedPlaceId: number | undefined = undefined;
  /** Klick auf eine leere Stelle der Karte (nicht auf einen Shop). */
  @Output() mapClicked: EventEmitter<void> = new EventEmitter<void>();
  @Output() placeClicked: EventEmitter<Place> = new EventEmitter<Place>();

  /** Läuft die Standort-Abfrage schon (watchPosition)? */
  private tracking = false;
  /** Lokalisieren wurde angetippt, die Position kommt aber erst noch: dann hinspringen. */
  private locateWhenReady = false;

  ngOnInit(): void {
    // Nach Standort und Blickrichtung wird erst gefragt, wenn man auf Lokalisieren tippt.
    // Hat man den Standort früher schon erlaubt, gleich anzeigen (ohne Rückfrage).
    navigator.permissions
      ?.query({ name: 'geolocation' })
      .then(status => {
        if (status.state === 'granted') {
          this.startTracking();
          // Android & Co.: Kompass braucht keine Erlaubnis. iOS fragt erst beim Antippen.
          this.compass.startWithoutAsking();
        }
      })
      .catch(() => {
        // Browser kennt die Abfrage nicht: warten, bis Lokalisieren angetippt wird
      });
  }

  /** Standort laufend verfolgen (fragt beim ersten Mal nach der Erlaubnis). */
  private startTracking(): void {
    if (this.tracking) return;
    this.tracking = true;
    if (FIXED_LOCATION) {
      this.onPositionUpdate(FIXED_LOCATION, FIXED_ACCURACY);
      return;
    }
    if (!navigator.geolocation) return;
    navigator.geolocation.watchPosition(
      (geolocationPosition: GeolocationPosition) => {
        this.zone.run(() => {
          this.onPositionUpdate(
            this.toLatLngLiteral(geolocationPosition),
            geolocationPosition.coords.accuracy
          );
          // Ohne Kompass: beim Gehen/Fahren zeigt das GPS die Bewegungsrichtung
          const { heading, speed } = geolocationPosition.coords;
          if (this.compassHeading === null && heading !== null && (speed ?? 0) > 0.5) {
            this.headingOverlay?.setHeading(heading);
          }
        });
      },
      () => {
        // Abgelehnt oder kein Empfang: beim nächsten Antippen nochmals versuchen
        this.tracking = false;
        this.locateWhenReady = false;
      },
      { enableHighAccuracy: true }
    );
  }

  /** Wird die Karte gerade verschoben? Dann hebt sich der rote Punkt leicht an. */
  mapMoving = false;
  private map: google.maps.Map | undefined = undefined;

  ngOnChanges(): void {
    // Beim Platzieren bleiben die anderen Orte sichtbar (man sieht, was schon da ist)
    this.placesOverlay?.update(this.pins());
    this.placesOverlay?.setSelected(this.selectedPlaceId);
  }

  /** Punkte für den gewählten Tag (Foodtrucks am Standort dieses Tages). */
  private pins(): PlacePin[] {
    return pinsForDay(this.places, this.day, this.slots);
  }

  /**
   * Zufälliger offener Ort in der Nähe (passend zu Tag, Tageszeit und Filter).
   * Nähe = um den eigenen Standort, sonst um die Kartenmitte. Zuerst im Umkreis
   * von RANDOM_RADIUS; gibt es dort keinen, unter den RANDOM_NEAREST nächsten.
   * Der gerade offene Ort (excludeId) kommt nicht nochmals dran, ausser er ist der einzige.
   */
  randomNearbyPin(excludeId?: number): PlacePin | undefined {
    const center = this.positionReceived ? this.locationMarkerPosition : this.getCenter();
    const open = this.pins().filter(pin => pin.open);
    if (!center || open.length === 0) return undefined;
    const byDistance = open
      .map(pin => ({ pin, distance: distanceInMeters(center, pin.position) }))
      .sort((a, b) => a.distance - b.distance);
    let candidates = byDistance.filter(entry => entry.distance <= this.RANDOM_RADIUS);
    if (candidates.length === 0) candidates = byDistance.slice(0, this.RANDOM_NEAREST);
    const others = candidates.filter(entry => entry.pin.place.id !== excludeId);
    const pool = others.length > 0 ? others : candidates;
    // Der Punkt (nicht nur der Ort): beim Foodtruck der heutige Standort
    return pool[Math.floor(Math.random() * pool.length)].pin;
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
    this.placesOverlay.update(this.pins());
    this.placesOverlay.setSelected(this.selectedPlaceId);
  }

  /**
   * Karte auf einen Ort ausrichten (z.B. zurück vom Login). Danach nicht mehr zum eigenen Standort springen.
   * Mit "free" (Bildschirm-Pixel von oben/unten): den Punkt in die Mitte dieser
   * freien Fläche schieben statt in die Mitte der ganzen Karte.
   */
  showPlace(position: google.maps.LatLngLiteral, free?: { top: number; bottom: number }): void {
    this.skipAutoLocate = true;
    const projection = this.map?.getProjection();
    if (!this.map || !projection || !free) {
      this.goToPosition(position);
      return;
    }
    const rect = this.map.getDiv().getBoundingClientRect();
    // So viele Pixel soll der Punkt unter (+) bzw. über (-) der Kartenmitte stehen
    const offset = (free.top + free.bottom) / 2 - (rect.top + rect.height / 2);
    const scale = 2 ** this.DETAIL_ZOOM;
    const point = projection.fromLatLngToPoint(position)!;
    const center = projection.fromPointToLatLng(
      new google.maps.Point(point.x, point.y - offset / scale)
    )!;
    this.map.setZoom(this.DETAIL_ZOOM);
    this.map.panTo(center);
  }

  /** Lokalisieren angetippt: Standort und Blickrichtung gleichzeitig abfragen, dann hinspringen. */
  locate(): void {
    // Beides direkt aus dem Antippen heraus, sonst lehnt das iPhone ab
    this.compass.requestPermission();
    this.startTracking();
    if (this.positionReceived) {
      this.goToPosition(this.locationMarkerPosition);
    } else {
      this.locateWhenReady = true;
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
      if (this.locateWhenReady || !this.skipAutoLocate) this.goToPosition(position);
    }
    this.locateWhenReady = false;
  }

  private toLatLngLiteral(
    geolocationPosition: GeolocationPosition
  ): google.maps.LatLngLiteral {
    return {
      lat: geolocationPosition.coords.latitude,
      lng: geolocationPosition.coords.longitude,
    };
  }

  /** Karte auf eine Position mit der Detail-Zoomstufe ausrichten (immer gleich, auch mehrmals). */
  private goToPosition(position: google.maps.LatLngLiteral) {
    if (this.map) {
      this.map.setZoom(this.DETAIL_ZOOM);
      this.map.panTo(position);
      return;
    }
    // Karte noch nicht bereit: Startwerte setzen
    this.mapZoom = this.DETAIL_ZOOM;
    this.mapCenter = { ...position };
  }
}
