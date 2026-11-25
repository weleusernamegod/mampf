import { AfterViewInit, Component, OnInit, ElementRef, OnDestroy, ViewChild } from '@angular/core';
import { VERSION } from '../../version';
import { DEFAULT_HUE, currentHue, setHue } from '../../util/color';

/** Zufallsspruch unter dem Logo, aus assets/slogan.js (in index.html geladen). */
declare global {
  interface Window {
    MampfSlogan?: { attach(element: Element): Promise<unknown> };
  }
}

/** Die Zeilen im Dialog. */
type Row = 'share' | 'language';

/** Abstand der Regler-Enden zur Mitte des Knopfs in px (halbe Höhe des Reglers). */
const HUE_EDGE = 20;
/** So nah (in Grad) am Original-Grün rastet der Regler ein. */
const HUE_SNAP = 12;

@Component({
  selector: 'mampf-about-dialog',
  standalone: true,
  imports: [],
  templateUrl: './about-dialog.component.html',
  styleUrl: './about-dialog.component.scss',
})
export class AboutDialogComponent implements OnInit, AfterViewInit, OnDestroy {
  readonly version = VERSION;
  readonly DEFAULT_HUE = DEFAULT_HUE;

  @ViewChild('logo') logo?: ElementRef<HTMLElement>;
  @ViewChild('hueBar') hueBar?: ElementRef<HTMLElement>;

  /** Kurzer Hinweis, der für ein paar Sekunden den Text einer Zeile ersetzt. */
  hint: { row: Row; text: string } | undefined = undefined;

  /** Farbregler offen (Punkt zum Regler verbreitert). */
  picking = false;
  /** Farbton unter dem Finger, gilt erst beim Loslassen. */
  previewHue = currentHue();

  /** Angemeldet? Dann "meine Orte & Konto" statt "Login / Anmelden". */
  loggedIn = false;

  private timer: ReturnType<typeof setTimeout> | undefined;
  private collapseTimer: ReturnType<typeof setTimeout> | undefined;
  private dragging = false;
  private snapped = false;

  ngOnInit(): void {
    fetch('/api/get-login-status.php')
      .then(response => response.json())
      .then(data => (this.loggedIn = !!data.loggedIn))
      .catch(() => (this.loggedIn = false));
  }

  ngAfterViewInit(): void {
    if (this.logo) window.MampfSlogan?.attach(this.logo.nativeElement);
  }

  ngOnDestroy(): void {
    clearTimeout(this.timer);
    clearTimeout(this.collapseTimer);
  }

  async share(event: Event) {
    event.stopPropagation(); // Dialog nicht schliessen
    const url = window.location.origin + '/';
    if (navigator.share) {
      try {
        // Link und Seitentitel teilen, aber keinen eigenen Text: Mit Text würde das
        // iPhone nur den Text teilen statt einer Link-Vorschau. Das Icon kann eine
        // Webseite hier nicht mitgeben, das kann nur Safaris eigener Teilen-Knopf.
        await navigator.share({ title: document.title, url });
      } catch {
        // Teilen abgebrochen: nichts tun
      }
      return;
    }
    try {
      await navigator.clipboard.writeText(url);
      this.showHint('share', 'Link kopiert!');
    } catch {
      this.showHint('share', url);
    }
  }

  /** Erster Tipp auf die Zeile öffnet den Farbregler. */
  onColorRowClicked(event: Event) {
    event.stopPropagation(); // Dialog nicht schliessen
    if (!this.picking) {
      this.previewHue = currentHue();
      this.picking = true;
    }
  }

  onHuePointerDown(event: PointerEvent) {
    if (!this.picking) return; // Regler ist noch zu: der Tipp öffnet ihn nur
    event.preventDefault();
    clearTimeout(this.collapseTimer);
    this.dragging = true;
    (event.currentTarget as HTMLElement).setPointerCapture(event.pointerId);
    this.updatePreview(event);
  }

  onHuePointerMove(event: PointerEvent) {
    if (this.dragging) this.updatePreview(event);
  }

  /** Finger losgelassen: Farbe übernehmen, Regler kurz danach wieder zum Punkt. */
  onHuePointerUp() {
    if (!this.dragging) return;
    this.dragging = false;
    setHue(this.previewHue);
    this.collapseTimer = setTimeout(() => (this.picking = false), 700);
  }

  /** Gleiche Sättigung und Helligkeit wie --primary in vars.scss. */
  colorOf(hue: number): string {
    return `hsl(${hue} 53.8% 39%)`;
  }

  /** Farbton aus der Fingerposition: links 0, rechts 360, nahe beim Original rastet er ein. */
  private updatePreview(event: PointerEvent) {
    const bar = this.hueBar?.nativeElement;
    if (!bar) return;
    const rect = bar.getBoundingClientRect();
    const position = (event.clientX - rect.left - HUE_EDGE) / (rect.width - 2 * HUE_EDGE);
    let hue = Math.round(Math.min(1, Math.max(0, position)) * 360);
    const snapped = Math.abs(hue - DEFAULT_HUE) < HUE_SNAP;
    if (snapped) hue = DEFAULT_HUE;
    if (snapped && !this.snapped) navigator.vibrate?.(10); // kurzes Rütteln (nur Android)
    this.snapped = snapped;
    this.previewHue = hue;
  }

  /** Platzhalter für Funktionen, die es noch nicht gibt. */
  showSoon(event: Event, row: 'language') {
    event.stopPropagation();
    this.showHint(row, 'folgt bald');
  }

  private showHint(row: Row, text: string, duration = 3000) {
    clearTimeout(this.timer);
    this.hint = { row, text };
    this.timer = setTimeout(() => (this.hint = undefined), duration);
  }
}
