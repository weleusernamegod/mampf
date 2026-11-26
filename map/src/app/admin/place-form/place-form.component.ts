import { Component, OnInit, ViewEncapsulation } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { PictureInputComponent } from '../inputs/picture-input/picture-input.component';
import { LocationInputComponent } from '../inputs/location-input/location-input.component';
import { OpeningInputComponent } from '../inputs/opening-input/opening-input.component';
import { StatusModalComponent } from '../status-modal/status-modal.component';
import { ActionStatus } from '../status-modal/action-status';
import {
  EditPlace,
  Opening,
  PlaceLocation,
  SavePlace,
  WEEKDAYS,
} from '../place-edit';
import { Category, CategoryGroup, CategoryList } from '../../dto/category';
import { PriceRangeInputComponent } from '../../component/price-range-input/price-range-input.component';
import { MapActionsService } from '../map-actions.service';

/** Zweites Auslösen innerhalb dieser Zeit ignorieren (Antippen + Klick). */
const DOUBLE_SUBMIT_MS = 800;

/** So viele Standorte pro Tag sind möglich (Sonderfall: zwei Orte am gleichen Tag). */
const MAX_LOCATIONS_PER_DAY = 2;

/** Für die Suche: klein, ohne Akzente und Umlaut-Punkte (cafe findet Café). */
function normalize(text: string): string {
  return text
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLowerCase()
    .trim();
}

/**
 * Panel "Ort bearbeiten" / "Neuer Ort" über der Karte (Adressen /ort/123 und /ort/neu).
 * Ersetzt die Seite /admin/place/... der alten Admin-App.
 *
 * Die Formular-Stile (panel, chip, segmented ...) gelten auch in den Bausteinen
 * darin (Bild, Öffnungszeiten), deshalb ViewEncapsulation.None. Alle Regeln stehen
 * deshalb unter "mampf-place-form", damit sie nicht in die Karte auslaufen.
 */
@Component({
  selector: 'mampf-place-form',
  standalone: true,
  imports: [
    PictureInputComponent,
    LocationInputComponent,
    OpeningInputComponent,
    PriceRangeInputComponent,
    StatusModalComponent,
    FormsModule,
  ],
  templateUrl: './place-form.component.html',
  styleUrl: './place-form.component.scss',
  encapsulation: ViewEncapsulation.None,
})
export class PlaceFormComponent implements OnInit {
  /** Klick auf die Karte schliesst dieses Panel nicht (sonst wäre alles Eingetippte weg). */
  readonly closeOnMapClick = false;

  isLoading = false;
  actionStatus: ActionStatus = ActionStatus.NoOperation;

  place: EditPlace | undefined;

  pictureChanged = false;
  newPictureData: string | undefined;

  lat = 47.3769;
  lng = 8.5417;
  /** Position kommt aus dem Platzieren-Modus der Karte. */
  positionFromMap = false;

  name = '';
  description = '';
  /** Ort konnte nicht geladen werden. */
  loadError = false;
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
  /** Preisspanne in CHF (10–30), null = unbekannt. */
  priceMin: number | null = null;
  priceMax: number | null = null;
  /** Link zur Website oder zum Menü (freiwillig). */
  website = '';
  /** Suchfeld pro Gruppe (Küche, Gerichte ...): Gruppe -> eingetippter Text. */
  searchTerms: Partial<Record<string, string>> = {};

  /** Wann zuletzt gespeichert wurde (gegen doppeltes Speichern). */
  private lastSubmitTime = 0;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private mapActions: MapActionsService
  ) {}

  ngOnInit(): void {
    fetch('/api/get-categories.php')
      .then(response => response.json())
      .then(data => (this.categoryList = data))
      .catch(error => console.error('Could not fetch categories', error));

    const id = this.route.snapshot.params['id'];
    if (id) {
      this.initFromExistingPlace(id);
    } else {
      // Neuer Ort: Position aus dem Platzieren-Modus der Karte (?lat=..&lng=..)
      const query = this.route.snapshot.queryParams;
      const lat = Number(query['lat']);
      const lng = Number(query['lng']);
      if (query['lat'] && query['lng'] && isFinite(lat) && isFinite(lng)) {
        this.lat = lat;
        this.lng = lng;
        this.positionFromMap = true;
      }
    }
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

  /** Chips, die zum Suchtext passen. Gewählte bleiben immer sichtbar. */
  visibleCategoriesOf(group: CategoryGroup): Category[] {
    const term = normalize(this.searchTerms[group.key] ?? '');
    return this.categoriesOf(group).filter(
      category =>
        !term ||
        normalize(category.name).includes(term) ||
        this.selectedCategories.has(category.id)
    );
  }

  /** Kurzform für kleine Handys: "Unter 5 Min" -> "< 5 Min", "Über 15 Min" -> "> 15 Min".
   *  undefined, wenn es keine Kurzform gibt. */
  shortName(name: string): string | undefined {
    const short = name.replace(/^Unter\s+/i, '< ').replace(/^Über\s+/i, '> ');
    return short === name ? undefined : short;
  }

  /** Bei "genau einer Auswahl": wählen, oder abwählen, wenn schon gewählt. */
  toggleSingle(group: CategoryGroup, id: number) {
    const wasSelected = this.selectedCategories.has(id);
    this.categoriesOf(group).forEach(category =>
      this.selectedCategories.delete(category.id)
    );
    if (!wasSelected) this.selectedCategories.add(id);
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

  /** Abbrechen: zurück, woher man kam (Liste "Meine Orte" oder Karte). */
  onCancel() {
    const cameFromApp =
      !!this.router.lastSuccessfulNavigation?.previousNavigation;
    if (cameFromApp) {
      history.back();
    } else {
      this.router.navigate(['/']);
    }
  }

  /** Ort löschen (nur bestehende Orte), mit Rückfrage. */
  onDeleteClicked() {
    if (!this.place) return;
    if (
      !confirm(
        `"${this.place.name}" wirklich löschen? Das lässt sich nicht rückgängig machen.`
      )
    ) {
      return;
    }
    this.actionStatus = ActionStatus.Loading;
    fetch(`/api/delete-place.php?id=${this.place.id}`, { method: 'delete' })
      .then(response => {
        if (!response.ok) throw new Error('HTTP ' + response.status);
        this.actionStatus = ActionStatus.NoOperation;
        this.mapActions.placesChanged.next(undefined);
      })
      .catch(() => (this.actionStatus = ActionStatus.CompletedError));
  }

  /**
   * Handy: Speichern schon beim Loslassen des Fingers auslösen.
   * Ist noch die Tastatur offen, schliesst sie sich beim Antippen und die
   * Seite verschiebt sich, bevor der Klick ankommt. Dann landete der Klick
   * daneben und man musste zweimal tippen.
   */
  onSavePointerUp(event: PointerEvent, form: HTMLFormElement) {
    if (event.pointerType === 'mouse') return;
    form.requestSubmit();
  }

  onFormSubmitted() {
    // Antippen und Klick lösen beide aus: nur einmal speichern
    const now = Date.now();
    if (
      this.actionStatus === ActionStatus.Loading ||
      now - this.lastSubmitTime < DOUBLE_SUBMIT_MS
    ) {
      return;
    }
    this.lastSubmitTime = now;

    // Nur Standorte von offenen Tagen speichern
    const openWeekdays = this.openDays.map(day => day.value);
    const locations = this.multipleLocations
      ? this.locations.filter(location =>
          openWeekdays.includes(location.weekday)
        )
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
      priceMin: this.priceMin,
      priceMax: this.priceMax,
      website: this.website.trim() || null,
    } as SavePlace;

    fetch('/api/post-place.php', {
      method: 'post',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(savePlace),
    })
      .then(async response => {
        if (!response.ok) {
          this.actionStatus = ActionStatus.CompletedError;
          return;
        }
        const data = await response.json().catch(() => undefined);
        const id = Number(data?.id ?? this.place?.id);
        // Panel zu, Karte lädt die Orte neu und öffnet diesen
        this.actionStatus = ActionStatus.NoOperation;
        this.mapActions.placesChanged.next(id > 0 ? id : undefined);
      })
      .catch(() => {
        this.actionStatus = ActionStatus.CompletedError;
      });
  }

  private initFromExistingPlace(id: string) {
    this.isLoading = true;

    fetch(`/api/get-place.php?id=${encodeURIComponent(id)}`)
      .then(response => {
        if (!response.ok) throw new Error('HTTP ' + response.status);
        return response.json();
      })
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
        this.priceMin = data.priceMin ?? null;
        this.priceMax = data.priceMax ?? null;
        this.website = data.website ?? '';

        this.isLoading = false;
      })
      .catch(error => {
        console.error('Could not fetch place', error);
        this.isLoading = false;
        this.loadError = true;
      });
  }
}
