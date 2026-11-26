import { Component, EventEmitter, Input, Output } from '@angular/core';
import { Opening, Slot, WEEKDAYS } from '../../place-edit';

const SLOTS: { value: Slot; name: string }[] = [
  { value: 'morning', name: 'Morgen' },
  { value: 'noon', name: 'Mittag' },
  { value: 'evening', name: 'Abend' },
];

/**
 * Öffnungszeiten als Gitter zum Anklicken: Wochentage × Morgen/Mittag/Abend.
 * Klick auf einen Tag bzw. eine Tageszeit schaltet die ganze Zeile/Spalte.
 */
@Component({
  selector: 'mampf-opening-input',
  standalone: true,
  imports: [],
  templateUrl: './opening-input.component.html',
  styleUrl: './opening-input.component.scss',
})
export class OpeningInputComponent {
  readonly weekdays = WEEKDAYS;
  readonly slots = SLOTS;

  @Input() opening: Opening[] = [];
  @Output() openingChange = new EventEmitter<Opening[]>();

  isOpen(weekday: number, slot: Slot): boolean {
    return this.opening.some(o => o.weekday === weekday && o.slot === slot);
  }

  /** Mindestens ein Kreuz an diesem Tag (Tag wird dann dunkel angezeigt). */
  isDayOpen(weekday: number): boolean {
    return this.opening.some(o => o.weekday === weekday);
  }

  toggle(weekday: number, slot: Slot) {
    this.emit(
      this.isOpen(weekday, slot)
        ? this.opening.filter(o => !(o.weekday === weekday && o.slot === slot))
        : [...this.opening, { weekday, slot }]
    );
  }

  /** Ganzer Tag: alles an, oder alles aus, wenn schon alles an ist. */
  toggleDay(weekday: number) {
    const allOpen = this.slots.every(slot => this.isOpen(weekday, slot.value));
    const others = this.opening.filter(o => o.weekday !== weekday);
    this.emit(
      allOpen
        ? others
        : [
            ...others,
            ...this.slots.map(slot => ({ weekday, slot: slot.value })),
          ]
    );
  }

  /** Ganze Tageszeit (z.B. jeden Mittag): alles an, oder alles aus. */
  toggleSlot(slot: Slot) {
    const allOpen = this.weekdays.every(day => this.isOpen(day.value, slot));
    const others = this.opening.filter(o => o.slot !== slot);
    this.emit(
      allOpen
        ? others
        : [
            ...others,
            ...this.weekdays.map(day => ({ weekday: day.value, slot })),
          ]
    );
  }

  private emit(opening: Opening[]) {
    this.opening = opening;
    this.openingChange.emit(opening);
  }
}
