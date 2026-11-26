import { Injectable } from '@angular/core';
import { Subject } from 'rxjs';

/**
 * Damit die Admin-Panels der Karte etwas sagen können
 * (die Karte selbst hört in app.component.ts zu).
 */
@Injectable({ providedIn: 'root' })
export class MapActionsService {
  /** Diesen Ort auf der Karte zeigen und seine Infobox öffnen (Ort-ID). */
  readonly showPlace = new Subject<number>();
  /** Platzieren-Modus starten (neuen Ort mit dem Punkt in der Kartenmitte wählen). */
  readonly startPlacing = new Subject<void>();
  /** Ein Ort wurde gespeichert oder gelöscht: Panel zu, Orte neu laden.
   *  Mit Ort-ID: diesen Ort danach zeigen und seine Infobox öffnen. */
  readonly placesChanged = new Subject<number | undefined>();
  /** Ein Ort wurde gespeichert oder gelöscht, aber das Panel bleibt offen
   *  (z.B. zurück in "Meine Orte"): nur die Orte der Karte neu laden. */
  readonly placesReloaded = new Subject<void>();
  /** Angemeldet und zurück zur Karte (z.B. um zu kommentieren). */
  readonly loggedIn = new Subject<void>();
}
