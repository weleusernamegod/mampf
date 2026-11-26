import { Component, Input, OnInit } from '@angular/core';
import { RouterLink } from '@angular/router';
import { fetchOwnUser } from '../own-user';

export type AccountTab = 'orte' | 'profil' | 'kategorien';

/**
 * Reiter "Meine Orte | Profil | (Kategorien) | Abmelden" im Kopf der Konto-Fenster.
 * Der aktuelle ist fett. Kategorien nur für Admins. Abmelden lädt die Karte neu.
 */
@Component({
  selector: 'mampf-account-tabs',
  standalone: true,
  imports: [RouterLink],
  template: `
    <nav class="tabs">
      <a routerLink="/meine-orte" [class.active]="active === 'orte'">Meine Orte</a>
      <a routerLink="/profil" [class.active]="active === 'profil'">Profil</a>
      @if (isAdmin) {
        <a routerLink="/kategorien" [class.active]="active === 'kategorien'">Kategorien</a>
      }
      <a href="/api/get-logout.php">Abmelden</a>
    </nav>
  `,
  styleUrl: './account-tabs.component.scss',
})
export class AccountTabsComponent implements OnInit {
  @Input() active: AccountTab = 'orte';
  isAdmin = false;

  ngOnInit(): void {
    fetchOwnUser().then(user => (this.isAdmin = !!user?.admin));
  }
}
