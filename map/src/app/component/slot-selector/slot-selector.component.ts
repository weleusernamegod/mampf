import { Component, EventEmitter, Input, Output } from '@angular/core';
import { Slot } from '../../dto/opening';

/**
 * Schalter Mittag / Abend über dem Tages-Slider.
 * "Morgen" gibt es hier bewusst nicht: wird nur gespeichert und in der
 * Infobox gezeigt, aber nicht gefiltert (siehe PLAN.md).
 */
@Component({
  selector: 'mampf-slot-selector',
  standalone: true,
  imports: [],
  templateUrl: './slot-selector.component.html',
  styleUrl: './slot-selector.component.scss',
})
export class SlotSelectorComponent {
  readonly options: { value: Slot; label: string }[] = [
    { value: 'noon', label: 'Mittag' },
    { value: 'evening', label: 'Abend' },
  ];

  @Input() slot: Slot = 'noon';
  @Output() slotSelected = new EventEmitter<Slot>();

  select(slot: Slot) {
    if (slot === this.slot) return;
    this.slotSelected.emit(slot);
  }
}
