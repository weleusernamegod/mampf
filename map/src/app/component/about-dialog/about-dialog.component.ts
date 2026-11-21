import { AfterViewInit, Component, ElementRef, OnDestroy, ViewChild } from '@angular/core';
import { VERSION } from '../../version';

/** Vom Browser angebotene Installation als App (nur Chrome/Android, mit Web-App-Manifest). */
interface InstallPromptEvent extends Event {
  prompt(): Promise<void>;
}

let installPrompt: InstallPromptEvent | undefined;
window.addEventListener('beforeinstallprompt', event => {
  event.preventDefault();
  installPrompt = event as InstallPromptEvent;
});

/** Zufallsspruch unter dem Logo, aus assets/slogan.js (in index.html geladen). */
declare global {
  interface Window {
    MampfSlogan?: { attach(element: Element): Promise<unknown> };
  }
}

/** Die Zeilen im Dialog. */
type Row = 'share' | 'home' | 'language' | 'color';

@Component({
  selector: 'mampf-about-dialog',
  standalone: true,
  imports: [],
  templateUrl: './about-dialog.component.html',
  styleUrl: './about-dialog.component.scss',
})
export class AboutDialogComponent implements AfterViewInit, OnDestroy {
  readonly version = VERSION;

  @ViewChild('logo') logo?: ElementRef<HTMLElement>;

  /** Kurzer Hinweis, der für ein paar Sekunden den Text einer Zeile ersetzt. */
  hint: { row: Row; text: string } | undefined = undefined;

  private timer: ReturnType<typeof setTimeout> | undefined;

  ngAfterViewInit(): void {
    if (this.logo) window.MampfSlogan?.attach(this.logo.nativeElement);
  }

  ngOnDestroy(): void {
    clearTimeout(this.timer);
  }

  async share(event: Event) {
    event.stopPropagation(); // Dialog nicht schliessen
    const url = window.location.origin;
    if (navigator.share) {
      try {
        await navigator.share({
          title: 'mampf',
          text: 'Foodtrucks und Imbisse auf der Karte',
          url,
        });
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

  async addToHomeScreen(event: Event) {
    event.stopPropagation();
    if (installPrompt) {
      await installPrompt.prompt();
      installPrompt = undefined;
      return;
    }
    // Ohne Installations-Angebot des Browsers: kurze Anleitung
    const iOS = /iPhone|iPad|iPod/.test(navigator.userAgent);
    this.showHint('home', iOS ? 'Teilen → Zum Home-Bildschirm' : 'Menü ⋮ → Zum Startbildschirm', 5000);
  }

  /** Platzhalter für Funktionen, die es noch nicht gibt. */
  showSoon(event: Event, row: 'language' | 'color') {
    event.stopPropagation();
    this.showHint(row, 'folgt bald');
  }

  private showHint(row: Row, text: string, duration = 3000) {
    clearTimeout(this.timer);
    this.hint = { row, text };
    this.timer = setTimeout(() => (this.hint = undefined), duration);
  }
}
