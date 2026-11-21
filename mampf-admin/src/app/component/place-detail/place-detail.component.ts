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
import { takePendingPosition } from '../../util/pending-position';
import { OpeningInputComponent } from '../opening-input/opening-input.component';
import { Opening, PlaceLocation, WEEKDAYS } from '../../dto/opening';
import { Category, CategoryGroup, CategoryList } from '../../dto/category';

/** So viele Standorte pro Tag sind möglich (Sonderfall: zwei Orte am gleichen Tag). */
const MAX_LOCATIONS_PER_DAY = 2;

@Component({
  selector: 'mampf-place-detail',
  standalone: true,
  imports: [
    LoadingSpinnerComponent,
    PictureInputComponent,
    LocationInputComponent,
    OpeningInputComponent,
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
  /** Position kommt aus dem Platzieren-Modus der Karte. */
  positionFromMap = false;

  name = '';
  description = '';
  /** Kreuze in der Öffnungszeiten-Matrix. */
  opening: Opening[] = [];
  /** Foodtruck: pro Wochentag ein eigener Standort. */
  multipleLocations = false;
  /** Standorte pro Tag (nur bei multipleLocations). Kann auch Tage enthalten,
   *  die inzwischen geschlossen sind; gespeichert werden nur offene Tage. */
  locations: PlaceLocation[] = [];
  readonly MAX_LOCATIONS_PER_DAY = MAX_LOCATIONS_PER_DAY;
  /** Hinweis, wenn "Mehrere Standorte" an ist, aber kein Tag offen. */
  locationError = false;

  /** Alle sichtbaren Kategorien vom Server. */
  categoryList: CategoryList = { groups: [], categories: [] };
  /** Gewählte Kategorien (IDs). */
  selectedCategories = new Set<number>();

  constructor(private route: ActivatedRoute) {}

  ngOnInit(): void {
    fetch('/api/get-categories.php')
      .then(response => response.json())
      .then(data => (this.categoryList = data))
      .catch(error => console.error('Could not fetch categories', error));

    this.route.params.subscribe((params: Params) => {
      const id = params['id'];
      if (id) {
        this.initFromExistingPlace(id);
      } else {
        // Neuer Ort: auf der Karte gewählte Position übernehmen, falls vorhanden
        const position = takePendingPosition();
        if (position) {
          this.lat = position.lat;
          this.lng = position.lng;
          this.positionFromMap = true;
        }
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

  categoriesOf(group: CategoryGroup): Category[] {
    return this.categoryList.categories
      .filter(category => category.group === group.key)
      .sort((a, b) => a.order - b.order);
  }

  /** Bei "genau einer Auswahl": die gewählte ID oder null. */
  selectedIn(group: CategoryGroup): number | null {
    return (
      this.categoriesOf(group).find(category =>
        this.selectedCategories.has(category.id)
      )?.id ?? null
    );
  }

  selectSingle(group: CategoryGroup, id: number | null) {
    this.categoriesOf(group).forEach(category =>
      this.selectedCategories.delete(category.id)
    );
    if (id !== null) this.selectedCategories.add(id);
  }

  toggleCategory(id: number) {
    if (this.selectedCategories.has(id)) {
      this.selectedCategories.delete(id);
    } else {
      this.selectedCategories.add(id);
    }
  }

  /** Offene Tage (mindestens ein Kreuz), Montag bis Sonntag. */
  get openDays() {
    return WEEKDAYS.filter(day =>
      this.opening.some(entry => entry.weekday === day.value)
    );
  }

  locationsFor(weekday: number): PlaceLocation[] {
    return this.locations.filter(location => location.weekday === weekday);
  }

  onOpeningChanged(opening: Opening[]) {
    this.opening = opening;
    this.syncLocations();
  }

  onMultipleLocationsChanged(on: boolean) {
    this.multipleLocations = on;
    this.syncLocations();
  }

  /** Jeder offene Tag braucht einen Standort: neue Tage starten wie der Tag davor. */
  private syncLocations() {
    this.locationError = false;
    if (!this.multipleLocations) return;
    let previous: PlaceLocation | undefined;
    for (const day of this.openDays) {
      const existing = this.locationsFor(day.value);
      if (existing.length === 0) {
        this.locations = [
          ...this.locations,
          {
            weekday: day.value,
            lat: previous?.lat ?? this.lat,
            lng: previous?.lng ?? this.lng,
            label: previous?.label ?? null,
          },
        ];
      }
      previous = this.locationsFor(day.value)[0];
    }
  }

  /** Name des offenen Tages vor diesem (für den Knopf "wie Montag"). */
  previousOpenDay(weekday: number) {
    const days = this.openDays;
    const index = days.findIndex(day => day.value === weekday);
    return index > 0 ? days[index - 1] : undefined;
  }

  /** Knopf "wie Montag": Standort und Bezeichnung vom Tag davor übernehmen. */
  copyFromPreviousDay(location: PlaceLocation) {
    const previousDay = this.previousOpenDay(location.weekday);
    const source = previousDay && this.locationsFor(previousDay.value)[0];
    if (!source) return;
    location.lat = source.lat;
    location.lng = source.lng;
    location.label = source.label;
  }

  /** Sonderfall: zweiter Standort am gleichen Tag. */
  addLocation(weekday: number) {
    const first = this.locationsFor(weekday)[0];
    this.locations = [
      ...this.locations,
      {
        weekday,
        lat: first?.lat ?? this.lat,
        lng: first?.lng ?? this.lng,
        label: null,
      },
    ];
  }

  removeLocation(location: PlaceLocation) {
    this.locations = this.locations.filter(other => other !== location);
  }

  onFormSubmitted() {
    // Nur Standorte von offenen Tagen speichern
    const openWeekdays = this.openDays.map(day => day.value);
    const locations = this.multipleLocations
      ? this.locations.filter(location => openWeekdays.includes(location.weekday))
      : [];
    if (this.multipleLocations && locations.length === 0) {
      this.locationError = true;
      return;
    }
    if (locations.length > 0) {
      // Der normale Standort ist der erste Tages-Standort
      // (z.B. für die Liste der eigenen Orte).
      this.lat = locations[0].lat;
      this.lng = locations[0].lng;
    }

    this.actionStatus = ActionStatus.Loading;

    const savePlace = {
      id: this.place ? this.place.id : -1,
      updatePicture: this.pictureChanged,
      pictureData: this.newPictureData,
      name: this.name,
      description: this.description,
      lat: this.lat,
      lng: this.lng,
      opening: this.opening,
      locations: locations.map(location => ({
        ...location,
        label: location.label?.trim() || null,
      })),
      categories: [...this.selectedCategories],
    } as SavePlace;

    fetch('/api/post-place.php', {
      method: 'post',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(savePlace),
    })
      .then(response => {
        this.actionStatus = response.ok
          ? ActionStatus.CompletedSuccess
          : ActionStatus.CompletedError;
      })
      .catch(() => {
        this.actionStatus = ActionStatus.CompletedError;
      });
  }

  private initFromExistingPlace(id: number) {
    this.isLoading = true;

    fetch(`/api/get-place.php?id=${id}`)
      .then(response => response.json())
      .then(data => {
        this.place = data;
        this.name = data.name;
        this.description = data.description;
        this.lat = data.lat;
        this.lng = data.lng;
        this.opening = data.opening;
        this.locations = data.locations;
        this.multipleLocations = data.locations.length > 0;
        this.selectedCategories = new Set(data.categories);

        this.isLoading = false;
      })
      .catch(error => {
        console.error('Could not fetch place', error);
      });
  }
}
