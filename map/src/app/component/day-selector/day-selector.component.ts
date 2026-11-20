import {
  Component,
  ElementRef,
  EventEmitter,
  Output,
  ViewChild,
} from '@angular/core';

/** Breite einer Tages-Spalte in px (muss zu grid-template-columns im SCSS passen). */
const STEP = 47;
/** Durchmesser des grünen Punkts in px. */
const THUMB = 37;
/** Abstand vom Rand des Menüs bis zum ersten Punkt (Padding 5px + Margin 5px). */
const OFFSET = 10;

interface Day {
  value: number; // wie Date.getDay(): 0 = Sonntag, 1 = Montag, ...
  label: string;
  name: string;
}

@Component({
  selector: 'mampf-day-selector',
  standalone: true,
  imports: [],
  templateUrl: './day-selector.component.html',
  styleUrl: './day-selector.component.scss',
})
export class DaySelectorComponent {
  readonly days: Day[] = [
    { value: 1, label: 'MO', name: 'Montag' },
    { value: 2, label: 'DI', name: 'Dienstag' },
    { value: 3, label: 'MI', name: 'Mittwoch' },
    { value: 4, label: 'DO', name: 'Donnerstag' },
    { value: 5, label: 'FR', name: 'Freitag' },
    { value: 6, label: 'SA', name: 'Samstag' },
    { value: 0, label: 'SO', name: 'Sonntag' },
  ];

  /** Position im Menü (0 = Montag ... 6 = Sonntag). */
  index: number = (new Date().getDay() + 6) % 7;

  dragging = false;
  private dragX = 0;
  private grabOffset = THUMB / 2;

  @ViewChild('track', { static: true }) track!: ElementRef<HTMLElement>;

  @Output() daySelected: EventEmitter<number> = new EventEmitter<number>();

  /** Horizontale Verschiebung des grünen Punkts in px. */
  get thumbX(): number {
    return this.dragging ? this.dragX : this.index * STEP;
  }

  onPointerDown(event: PointerEvent) {
    if (event.button !== 0) return;
    event.preventDefault();

    const x = this.pointerX(event);
    const thumbLeft = this.index * STEP;

    // Punkt direkt angefasst: Abstand zum Finger beibehalten, damit er nicht springt.
    // Daneben geklickt: Punkt springt mittig unter den Finger.
    this.grabOffset =
      x >= thumbLeft && x <= thumbLeft + THUMB ? x - thumbLeft : THUMB / 2;

    this.dragging = true;
    this.track.nativeElement.setPointerCapture(event.pointerId);
    this.moveTo(x);
  }

  onPointerMove(event: PointerEvent) {
    if (!this.dragging) return;
    this.moveTo(this.pointerX(event));
  }

  onPointerUp() {
    // Loslassen: Punkt rastet auf dem nächsten Tag ein.
    this.dragging = false;
  }

  onKeyDown(event: KeyboardEvent) {
    const last = this.days.length - 1;
    const keys: Record<string, number> = {
      ArrowLeft: this.index - 1,
      ArrowDown: this.index - 1,
      ArrowRight: this.index + 1,
      ArrowUp: this.index + 1,
      Home: 0,
      End: last,
    };
    if (!(event.key in keys)) return;
    event.preventDefault();
    this.select(Math.min(last, Math.max(0, keys[event.key])));
  }

  private pointerX(event: PointerEvent): number {
    const rect = this.track.nativeElement.getBoundingClientRect();
    return event.clientX - rect.left - OFFSET;
  }

  private moveTo(x: number) {
    const max = (this.days.length - 1) * STEP;
    this.dragX = Math.min(max, Math.max(0, x - this.grabOffset));
    this.select(Math.round(this.dragX / STEP));
  }

  private select(index: number) {
    if (index === this.index) return;
    this.index = index;
    this.daySelected.emit(this.days[index].value);
  }
}
