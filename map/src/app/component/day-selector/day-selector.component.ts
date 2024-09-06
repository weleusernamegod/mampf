import { Component, EventEmitter, Output } from '@angular/core';

@Component({
  selector: 'mampf-day-selector',
  standalone: true,
  imports: [],
  templateUrl: './day-selector.component.html',
  styleUrl: './day-selector.component.scss',
})
export class DaySelectorComponent {
  selectedDay: number = new Date().getDay();

  @Output() daySelected: EventEmitter<number> = new EventEmitter<number>();

  onDaySelected(day: number) {
    this.selectedDay = day;
    this.daySelected.emit(day);
  }
}
