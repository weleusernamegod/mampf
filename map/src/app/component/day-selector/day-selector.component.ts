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
const THUMB = 41;
/** Abstand vom Rand des Menüs bis zum grünen Punkt auf Montag (Padding 5px + Rand 3px). */
const OFFSET = 8;
/**
 * Wie weit man ziehen muss, bis der Punkt zum nächsten Tag springt
 * (Anteil einer Spalte). Über 0.5 = "sticky": Der Punkt bleibt etwas länger
 * stehen und springt nicht beim kleinsten Wackeln hin und her.
 */
const STICKY = 0.65;

interface Day {
  value: number; // wie Date.getDay(): 0 = Sonntag, 1 = Montag, ...
  label: string;
  name: string;
  weekend?: boolean;
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
    { value: 6, label: 'SA', name: 'Samstag', weekend: true },
    { value: 0, label: 'SO', name: 'Sonntag', weekend: true },
  ];

  /** Position im Menü (0 = Montag ... 6 = Sonntag). */
  index: number = (new Date().getDay() + 6) % 7;

  dragging = false;
  /** Wo der Finger beim Antippen war und auf welchem Tag der Punkt da stand. */
  private startX = 0;
  private startIndex = 0;

  @ViewChild('track', { static: true }) track!: ElementRef<HTMLElement>;

  @Output() daySelected: EventEmitter<number> = new EventEmitter<number>();

  /** Horizontale Verschiebung des grünen Punkts in px – immer genau auf einem Tag. */
  get thumbX(): number {
    return this.index * STEP;
  }

  onPointerDown(event: PointerEvent) {
    if (event.button !== 0) return;
    event.preventDefault();

    const x = this.pointerX(event);
    const thumbLeft = this.index * STEP;
    const onThumb = x >= thumbLeft && x <= thumbLeft + THUMB;

    // Daneben geklickt: direkt auf den nächstgelegenen Tag springen.
    // Wie genau man den Tag getroffen hat, spielt keine Rolle.
    if (!onThumb) {
      this.select(this.clamp(Math.round((x - THUMB / 2) / STEP)));
    }

    // Ab hier zählt nur noch, wie weit der Finger von hier aus geschoben wird.
    this.startX = x;
    this.startIndex = this.index;
    this.dragging = true;
    this.track.nativeElement.setPointerCapture(event.pointerId);
  }

  onPointerMove(event: PointerEvent) {
    if (!this.dragging) return;

    // Geschobene Strecke, umgerechnet in "Tage" (z.B. 1.3 = gut ein Tag nach rechts).
    const position =
      this.startIndex + (this.pointerX(event) - this.startX) / STEP;

    // Erst springen, wenn man deutlich über die Mitte zum Nachbartag gezogen hat.
    let index = this.index;
    while (position > index + STICKY && index < this.days.length - 1) index++;
    while (position < index - STICKY && index > 0) index--;
    this.select(index);
  }

  onPointerUp() {
    this.dragging = false;
  }

  onKeyDown(event: KeyboardEvent) {
    const keys: Record<string, number> = {
      ArrowLeft: this.index - 1,
      ArrowDown: this.index - 1,
      ArrowRight: this.index + 1,
      ArrowUp: this.index + 1,
      Home: 0,
      End: this.days.length - 1,
    };
    if (!(event.key in keys)) return;
    event.preventDefault();
    this.select(this.clamp(keys[event.key]));
  }

  private pointerX(event: PointerEvent): number {
    const rect = this.track.nativeElement.getBoundingClientRect();
    return event.clientX - rect.left - OFFSET;
  }

  private clamp(index: number): number {
    return Math.min(this.days.length - 1, Math.max(0, index));
  }

  private select(index: number) {
    if (index === this.index) return;
    this.index = index;
    this.daySelected.emit(this.days[index].value);
  }
}
