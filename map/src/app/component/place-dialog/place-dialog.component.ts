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
  /** Klick auf das kleine X */
  @Output() closed: EventEmitter<void> = new EventEmitter<void>();

  @ViewChild('dialog', { static: true }) dialog!: ElementRef<HTMLElement>;
  @ViewChild('wrapper', { static: true }) wrapper!: ElementRef<HTMLElement>;
  @ViewChild('summary', { static: true }) summary!: ElementRef<HTMLElement>;

  /** Aufgeschoben (alle Infos sichtbar)? */
  expanded = false;
  /** Erst nach dem Aufschieben scrollbar, falls der Inhalt zu hoch ist. */
  scrollable = false;

  openingHours: string | undefined;
  pictureUrl: string | undefined;
  cuisines: Cuisine[] = [];

  ngOnChanges(): void {
    if (this.place) {
      this.openingHours = this.generateOpeningHours(this.place);
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

  private generateOpeningHours(place: Place): string {
    const array = [];
    if (place.openingHours.morning) {
      array.push('Morgens');
    }
    if (place.openingHours.noon) {
      array.push('Mittags');
    }
    if (place.openingHours.evening) {
      array.push('Abends');
    }
    if (place.openingHours.night) {
      array.push('Nachts');
    }
    return array.join(', ');
  }
}
