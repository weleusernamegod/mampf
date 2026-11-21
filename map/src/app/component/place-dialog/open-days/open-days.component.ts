import { Component, Input } from '@angular/core';
import { Opening } from '../../../dto/opening';
import { SLOTS, WEEKDAYS, hasOpening } from '../../../util/place-util';

/** Zusammenhängende offene Tageszeiten, als Index in SLOTS (0 = Morgen ... 2 = Abend). */
interface Run {
  start: number;
  end: number;
}

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

  /**
   * Grüne Abschnitte eines Tages. Beispiele:
   * nur Mittag -> [1–1] (ein Kreis), Mittag + Abend -> [1–2] (ein Balken),
   * Morgen + Abend -> [0–0], [2–2] (zwei einzelne Kreise).
   */
  runs(day: number): Run[] {
    const runs: Run[] = [];
    SLOTS.forEach((slot, index) => {
      if (!hasOpening(this.opening, day, slot.value)) return;
      const last = runs[runs.length - 1];
      if (last && last.end === index - 1) {
        last.end = index;
      } else {
        runs.push({ start: index, end: index });
      }
    });
    return runs;
  }

  /** Für Screenreader, z.B. "Montag: Mittag, Abend" oder "Montag: geschlossen". */
  label(day: number, dayName: string): string {
    const open = SLOTS.filter(slot => hasOpening(this.opening, day, slot.value)).map(
      slot => slot.name
    );
    return `${dayName}: ${open.length > 0 ? open.join(', ') : 'geschlossen'}`;
  }
}
