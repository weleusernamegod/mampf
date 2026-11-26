import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { PlaceSummary } from '../place-summary';
import { MapActionsService } from '../map-actions.service';
import { AccountTabsComponent } from '../account-tabs/account-tabs.component';

const FALLBACK_PICTURE = 'assets/marktstand.svg';

/**
 * Panel "Meine Orte" über der Karte (Adresse /meine-orte).
 */
@Component({
  selector: 'mampf-my-places-panel',
  standalone: true,
  imports: [AccountTabsComponent],
  templateUrl: './my-places-panel.component.html',
  styleUrl: './my-places-panel.component.scss',
  host: { class: 'block full-height' },
})
export class MyPlacesPanelComponent implements OnInit {
  /** undefined = wird noch geladen */
  places: PlaceSummary[] | undefined = undefined;
  loadError = false;

  constructor(
    private router: Router,
    private mapActions: MapActionsService
  ) {}

  ngOnInit(): void {
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

  /** Ort antippen: Formular "Ort bearbeiten" öffnen. */
  onPlaceClicked(place: PlaceSummary) {
    this.router.navigate(['/ort', place.id]);
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
