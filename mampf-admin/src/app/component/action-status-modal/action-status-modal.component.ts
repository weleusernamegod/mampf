import { Component, Input } from '@angular/core';
import { ActionStatus } from './action-status';

@Component({
  selector: 'mampf-action-status-modal',
  standalone: true,
  imports: [],
  templateUrl: './action-status-modal.component.html',
  styleUrl: './action-status-modal.component.scss',
})
export class ActionStatusModalComponent {
  readonly ActionStatus = ActionStatus;

  @Input() status: ActionStatus = ActionStatus.NoOperation;
  @Input() title = 'Operation in progress';

  resetModal(): void {
    this.status = ActionStatus.NoOperation;
  }
}
