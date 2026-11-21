import {
  Component,
  ElementRef,
  EventEmitter,
  Input,
  OnChanges,
  Output,
  ViewChild,
} from '@angular/core';
import { Place } from '../../dto/place';
import { Cuisine, cuisinesOf } from '../../util/cuisine-filter';
import { OpenDaysComponent } from './open-days/open-days.component';
import { SLOTS, WEEKDAYS, hasOpening } from '../../util/place-util';

/** Abstand unter dem Inhalt der zugeklappten Infobox in px (wie padding-bottom im SCSS). */
const BOTTOM_PADDING = 15;

@Component({
  selector: 'mampf-place-dialog',
  standalone: true,
  imports: [OpenDaysComponent],
  templateUrl: './place-dialog.component.html',
  styleUrl: './place-dialog.component.scss',
})
export class PlaceDialogComponent implements OnChanges {
  @Input() place: Place | undefined = undefined;
  /** Im Slider gewählter Wochentag (0 = Sonntag, 1 = Montag, ...). */
  @Input() day: number = new Date().getDay();
  /** Klick auf das kleine X */
  @Output() closed: EventEmitter<void> = new EventEmitter<void>();

  @ViewChild('dialog', { static: true }) dialog!: ElementRef<HTMLElement>;
  @ViewChild('wrapper', { static: true }) wrapper!: ElementRef<HTMLElement>;
  @ViewChild('summary', { static: true }) summary!: ElementRef<HTMLElement>;

  /** Aufgeschoben (alle Infos sichtbar)? */
  expanded = false;
  /** Erst nach dem Aufschieben scrollbar, falls der Inhalt zu hoch ist. */
  scrollable = false;

  /** Kurz für den gewählten Tag, z.B. "Heute: Mittag, Abend". */
  openingHours: string | undefined;
  /** Nur bei mehreren Standorten, z.B. "Mo Helvetiaplatz · Fr Bahnhof Altstetten". */
  locations: string | undefined;
  pictureUrl: string | undefined;
  cuisines: Cuisine[] = [];

  ngOnChanges(): void {
    if (this.place) {
      this.openingHours = this.generateOpeningHours(this.place, this.day);
      this.locations = this.generateLocations(this.place);
      this.pictureUrl = this.place.pictureId
        ? `api/get-public-picture.php?id=${this.place.pictureId}`
        : 'assets/no-picture.jpg';
      this.cuisines = cuisinesOf(this.place);
    }
    // Neuer Ort: wieder zugeklappt anfangen. Die Höhe erst messen, wenn der
    // neue Text auf der Seite steht (kurz danach).
    this.expanded = false;
    this.scrollable = false;
    setTimeout(() => {
      if (!this.expanded) this.setHeight(this.minimizedHeight());
    });
  }

  toggleSize(): void {
    const element = this.dialog.nativeElement;
    this.expanded = !this.expanded;
    this.scrollable = false;

    if (this.expanded) {
      // Bis zur vollen Höhe des Inhalts aufschieben, höchstens so hoch wie Platz da ist
      const available = this.wrapper.nativeElement.clientHeight;
      this.setHeight(Math.min(element.scrollHeight, available));
    } else {
      element.scrollTop = 0;
      this.setHeight(this.minimizedHeight());
    }
  }

  onTransitionEnd(event: TransitionEvent) {
    if (event.target !== this.dialog.nativeElement || event.propertyName !== 'height') {
      return;
    }
    const element = this.dialog.nativeElement;
    this.scrollable = this.expanded && element.scrollHeight > element.clientHeight;
  }

  /**
   * Höhe der zugeklappten Infobox: so hoch, dass Bild, Name, Beschreibung und
   * Öffnungszeiten ganz sichtbar sind, auch wenn der Text mehrzeilig ist.
   */
  private minimizedHeight(): number {
    const summary = this.summary.nativeElement;
    return summary.offsetTop + summary.offsetHeight + BOTTOM_PADDING;
  }

  private setHeight(px: number) {
    if (this.dialog) this.dialog.nativeElement.style.height = `${px}px`;
  }

  /** Öffnungszeiten am gewählten Tag, bei Foodtrucks mit dem Standort dieses Tages. */
  private generateOpeningHours(place: Place, day: number): string {
    const dayName =
      day === new Date().getDay()
        ? 'Heute'
        : WEEKDAYS.find(weekday => weekday.value === day)?.name ?? '';
    const slots = SLOTS.filter(slot => hasOpening(place.opening, day, slot.value)).map(
      slot => slot.name
    );
    const labels = place.locations
      .filter(location => location.weekday === day && location.label)
      .map(location => location.label);

    if (slots.length === 0) {
      return `${dayName} geschlossen`;
    }
    const text = `${dayName}: ${slots.join(', ')}`;
    return labels.length > 0 ? `${text} · ${labels.join(' / ')}` : text;
  }

  /**
   * Standorte eines Foodtrucks, Tage mit gleichem Standort zusammengefasst:
   * "Mo, Mi Helvetiaplatz · Fr Bahnhof Altstetten".
   */
  private generateLocations(place: Place): string | undefined {
    if (place.locations.length === 0) {
      return undefined;
    }
    const groups = new Map<string, string[]>();
    for (const weekday of WEEKDAYS) {
      for (const location of place.locations) {
        if (location.weekday !== weekday.value) continue;
        const label = location.label ?? '(ohne Bezeichnung)';
        const days = groups.get(label) ?? [];
        if (!days.includes(weekday.short)) days.push(weekday.short);
        groups.set(label, days);
      }
    }
    return [...groups.entries()]
      .map(([label, days]) => `${days.join(', ')} ${label}`)
      .join(' · ');
  }
}
