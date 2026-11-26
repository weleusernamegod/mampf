import { Component, OnInit } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { PlaceSummary } from '../place-summary';
import { MapActionsService } from '../map-actions.service';
import { fetchOwnUser } from '../own-user';

const FALLBACK_PICTURE = 'assets/marktstand.svg';

/**
 * Panel "Meine Orte" über der Karte (Adresse /meine-orte).
 */
@Component({
  selector: 'mampf-my-places-panel',
  standalone: true,
  imports: [RouterLink],
  templateUrl: './my-places-panel.component.html',
  styleUrl: './my-places-panel.component.scss',
  host: { class: 'block full-height' },
})
export class MyPlacesPanelComponent implements OnInit {
  /** undefined = wird noch geladen */
  places: PlaceSummary[] | undefined = undefined;
  loadError = false;
  /** Admins sehen zusätzlich "Kategorien". */
  isAdmin = false;

  constructor(
    private router: Router,
    private mapActions: MapActionsService
  ) {}

  ngOnInit(): void {
    fetchOwnUser().then(user => (this.isAdmin = !!user?.admin));
    fetch('/api/get-own-places.php')
      .then(response => {
        if (!response.ok) throw new Error('HTTP ' + response.status);
        return response.json();
      })
      .then((data: PlaceSummary[]) => {
        this.places = [...data].sort((a, b) =>
          a.name.localeCompare(b.name, 'de')
        );
      })
      .catch(error => {
        console.error('Could not fetch my places', error);
        this.loadError = true;
        this.places = [];
      });
  }

  /** Ort antippen: Panel zu, Karte springt hin, Infobox offen. */
  onPlaceClicked(place: PlaceSummary) {
    this.mapActions.showPlace.next(place.id);
  }

  onAddClicked() {
    this.mapActions.startPlacing.next();
  }

  onCloseClicked() {
    this.router.navigate(['/']);
  }

  pictureUrl(place: PlaceSummary) {
    return place.pictureUrl ?? FALLBACK_PICTURE;
  }

  /** Bild fehlt (z.B. lokal, die Bilder liegen nur auf dem Server): Marktstand zeigen. */
  onPictureError(event: Event) {
    const img = event.target as HTMLImageElement;
    if (!img.src.endsWith(FALLBACK_PICTURE)) img.src = FALLBACK_PICTURE;
  }
}
