import { Component, EventEmitter, Output } from '@angular/core';

@Component({
  selector: 'mampf-navigation',
  standalone: true,
  imports: [],
  templateUrl: './navigation.component.html',
  styleUrl: './navigation.component.scss',
})
export class NavigationComponent {
  @Output() locateClicked: EventEmitter<void> = new EventEmitter<void>();
  @Output() aboutClicked: EventEmitter<void> = new EventEmitter<void>();
  @Output() addClicked: EventEmitter<void> = new EventEmitter<void>();

  onLocateClicked() {
    this.locateClicked.emit();
  }

  onAboutClicked() {
    this.aboutClicked.emit();
  }

  onAddClicked() {
    this.addClicked.emit();
  }
}
