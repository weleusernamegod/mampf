import { Component, Input } from '@angular/core';
import { Opening, Slot } from '../../../dto/opening';
import { SLOTS, WEEKDAYS, hasOpening } from '../../../util/place-util';

/** Öffnungszeiten als kleine Matrix: Wochentage × Morgen/Mittag/Abend. */
@Component({
  selector: 'mampf-open-days',
  standalone: true,
  imports: [],
  templateUrl: './open-days.component.html',
  styleUrl: './open-days.component.scss',
})
export class OpenDaysComponent {
  readonly weekdays = WEEKDAYS;
  readonly slots = SLOTS;

  @Input() opening: Opening[] = [];
  /** Gewählter Tag im Slider, wird hervorgehoben. */
  @Input() day: number | undefined = undefined;

  isOpen(day: number, slot: Slot): boolean {
    return hasOpening(this.opening, day, slot);
  }
}
