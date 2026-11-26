import { Component, Input } from '@angular/core';
import { ActionStatus } from './action-status';

@Component({
  selector: 'mampf-status-modal',
  standalone: true,
  imports: [],
  templateUrl: './status-modal.component.html',
  styleUrl: './status-modal.component.scss',
})
/** Grauer Hintergrund mit Kasten: wird gespeichert / Hoppla (Fehler). */
export class StatusModalComponent {
  readonly ActionStatus = ActionStatus;

  @Input() status: ActionStatus = ActionStatus.NoOperation;
  @Input() title = 'Bitte warten';

  resetModal(): void {
    this.status = ActionStatus.NoOperation;
  }
}
