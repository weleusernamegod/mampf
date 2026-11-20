import { Component, OnDestroy } from '@angular/core';

/** Vom Browser angebotene Installation als App (nur Chrome/Android, mit Web-App-Manifest). */
interface InstallPromptEvent extends Event {
  prompt(): Promise<void>;
}

let installPrompt: InstallPromptEvent | undefined;
window.addEventListener('beforeinstallprompt', event => {
  event.preventDefault();
  installPrompt = event as InstallPromptEvent;
});

@Component({
  selector: 'mampf-about-dialog',
  standalone: true,
  imports: [],
  templateUrl: './about-dialog.component.html',
  styleUrl: './about-dialog.component.scss',
})
export class AboutDialogComponent implements OnDestroy {
  /** Kurzer Hinweis unter einem Eintrag, z.B. "Link kopiert". */
  shareHint = '';
  homeScreenHint = '';
  soonHint: 'language' | 'color' | '' = '';

  private timer: ReturnType<typeof setTimeout> | undefined;

  ngOnDestroy(): void {
    clearTimeout(this.timer);
  }

  async share(event: Event) {
    event.stopPropagation(); // Dialog nicht schliessen
    const url = window.location.origin;
    if (navigator.share) {
      try {
        await navigator.share({ title: 'mampf', text: 'Foodtrucks und Imbisse auf der Karte', url });
      } catch {
        // Teilen abgebrochen: nichts tun
      }
      return;
    }
    try {
      await navigator.clipboard.writeText(url);
      this.showHint(() => (this.shareHint = 'Link kopiert!'), () => (this.shareHint = ''));
    } catch {
      this.showHint(() => (this.shareHint = url), () => (this.shareHint = ''));
    }
  }

  async addToHomeScreen(event: Event) {
    event.stopPropagation();
    if (installPrompt) {
      await installPrompt.prompt();
      installPrompt = undefined;
      return;
    }
    // Ohne Installations-Angebot des Browsers: Anleitung anzeigen
    const iOS = /iPhone|iPad|iPod/.test(navigator.userAgent);
    const text = iOS
      ? 'Unten auf „Teilen“ tippen, dann „Zum Home-Bildschirm“.'
      : 'Im Browser-Menü ⋮ „Zum Startbildschirm hinzufügen“ wählen.';
    this.showHint(() => (this.homeScreenHint = text), () => (this.homeScreenHint = ''), 6000);
  }

  /** Platzhalter für Funktionen, die es noch nicht gibt. */
  showSoon(event: Event, which: 'language' | 'color') {
    event.stopPropagation();
    this.showHint(() => (this.soonHint = which), () => (this.soonHint = ''));
  }

  private showHint(show: () => void, hide: () => void, duration = 3000) {
    clearTimeout(this.timer);
    this.shareHint = '';
    this.homeScreenHint = '';
    this.soonHint = '';
    show();
    this.timer = setTimeout(hide, duration);
  }
}
