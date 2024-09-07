import { Component, Input } from '@angular/core';
import { OpenDays } from '../../../dto/open-days';

@Component({
  selector: 'mampf-open-days',
  standalone: true,
  imports: [],
  templateUrl: './open-days.component.html',
  styleUrl: './open-days.component.scss',
})
export class OpenDaysComponent {
  @Input() openDays: OpenDays | undefined = undefined;
}
