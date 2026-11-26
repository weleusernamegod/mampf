import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { fetchOwnUser } from '../own-user';
import { AccountTabsComponent } from '../account-tabs/account-tabs.component';

/** Aus /assets/random-name.js, z.B. "Knusprige Bratwurst". Wird erst hier geladen. */
declare global {
  interface Window {
    mampfRandomName?: () => string;
  }
}

/**
 * Panel "Profil" über der Karte (Adresse /profil): Anzeigename ändern
 * (erscheint bei den Kommentaren).
 */
@Component({
  selector: 'mampf-profile-panel',
  standalone: true,
  imports: [FormsModule, AccountTabsComponent],
  templateUrl: './profile-panel.component.html',
  styleUrl: './profile-panel.component.scss',
  host: { class: 'block full-height' },
})
export class ProfilePanelComponent implements OnInit {
  isLoading = true;
  mail = '';
  name = '';
  savedName = '';
  saving = false;
  message: { text: string; error: boolean } | undefined;

  constructor(private router: Router) {}

  ngOnInit(): void {
    loadRandomNameScript();
    fetchOwnUser(true).then(user => {
      this.isLoading = false;
      if (!user) {
        this.message = {
          text: 'Das Profil konnte nicht geladen werden.',
          error: true,
        };
        return;
      }
      this.mail = user.mail;
      this.name = user.name ?? '';
      this.savedName = this.name;
    });
  }

  get changed(): boolean {
    return this.name.trim() !== this.savedName;
  }

  onRandomName(): void {
    if (!window.mampfRandomName) return;
    this.name = window.mampfRandomName();
    this.message = undefined;
  }

  onClose(): void {
    this.router.navigate(['/']);
  }

  onSave(): void {
    const name = this.name.trim().replace(/\s+/g, ' ');
    if (name.length < 2 || name.length > 30) {
      this.message = {
        text: 'Der Name braucht 2 bis 30 Zeichen.',
        error: true,
      };
      return;
    }
    this.saving = true;
    fetch('/api/post-own-user.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name }),
    })
      .then(response => {
        if (!response.ok) throw new Error();
        this.name = name;
        this.savedName = name;
        this.message = { text: 'Gespeichert.', error: false };
      })
      .catch(
        () =>
          (this.message = {
            text: 'Speichern hat nicht geklappt.',
            error: true,
          })
      )
      .finally(() => (this.saving = false));
  }
}

/** random-name.js nur einmal und erst bei Bedarf laden (normale Besucher brauchen es nie). */
function loadRandomNameScript() {
  if (window.mampfRandomName || document.getElementById('random-name-script'))
    return;
  const script = document.createElement('script');
  script.id = 'random-name-script';
  script.src = '/assets/random-name.js';
  document.head.appendChild(script);
}
