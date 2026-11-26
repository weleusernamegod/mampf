import {
  AfterViewInit,
  Component,
  ElementRef,
  OnInit,
  ViewChild,
} from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { MapActionsService } from '../map-actions.service';
import { fetchOwnUser } from '../own-user';

type Mode = 'login' | 'register';

/**
 * Fenster "Anmelden" / "Registrieren" über der Karte (Adressen /anmelden und /registrieren).
 * Ersetzt die früheren Seiten login/index.html und login/register.html.
 *
 * ?zurueck=karte  -> nach dem Anmelden zurück zur Karte (z.B. zum Kommentieren)
 * ?zurueck=/profil -> nach dem Anmelden zu dieser Seite der Karte
 * sonst           -> nach dem Anmelden zu "Meine Orte"
 */
@Component({
  selector: 'mampf-auth-panel',
  standalone: true,
  imports: [FormsModule, RouterLink],
  templateUrl: './auth-panel.component.html',
  styleUrl: './auth-panel.component.scss',
  host: { class: 'block full-height' },
})
export class AuthPanelComponent implements OnInit, AfterViewInit {
  @ViewChild('logo') logo?: ElementRef<HTMLElement>;

  mode: Mode = 'login';
  mail = '';
  name = '';
  password = '';
  password2 = '';
  busy = false;
  message: { text: string; error: boolean } | undefined;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private mapActions: MapActionsService
  ) {
    // Gerade registriert? (von der Registrierung mitgegeben)
    const state = this.router.getCurrentNavigation()?.extras.state;
    if (state?.['registered']) {
      this.mail = state['mail'] ?? '';
      this.message = {
        text: 'Registrierung erfolgreich. Melde dich jetzt an.',
        error: false,
      };
    }
  }

  ngOnInit(): void {
    this.mode =
      this.route.snapshot.data['mode'] === 'register' ? 'register' : 'login';
    if (this.mode === 'register') loadRandomNameScript();
  }

  ngAfterViewInit(): void {
    if (this.logo) window.MampfSlogan?.attach(this.logo.nativeElement);
  }

  onRandomName(): void {
    if (!window.mampfRandomName) return;
    this.name = window.mampfRandomName();
  }

  onClose(): void {
    this.router.navigate(['/']);
  }

  onSubmit(): void {
    if (this.busy) return;
    this.message = undefined;
    if (this.mode === 'login') {
      this.login();
    } else {
      this.register();
    }
  }

  private login() {
    this.busy = true;
    this.post('/api/post-login.php', {
      mail: this.mail,
      password: this.password,
    })
      .then(ok => {
        if (!ok) {
          this.message = {
            text: 'Anmelden hat nicht geklappt. Stimmen E-Mail und Passwort?',
            error: true,
          };
          return;
        }
        fetchOwnUser(true);
        this.goBack();
      })
      .finally(() => (this.busy = false));
  }

  private register() {
    const name = this.name.trim().replace(/\s+/g, ' ');
    if (this.password !== this.password2) {
      this.message = {
        text: 'Die beiden Passwörter sind nicht gleich.',
        error: true,
      };
      return;
    }
    this.busy = true;
    this.post('/api/post-register.php', {
      mail: this.mail.trim(),
      name,
      password: this.password,
    })
      .then(ok => {
        if (!ok) {
          this.message = {
            text: 'Registrieren hat nicht geklappt. Gibt es die E-Mail vielleicht schon?',
            error: true,
          };
          return;
        }
        this.router.navigate(['/anmelden'], {
          queryParamsHandling: 'preserve',
          replaceUrl: true,
          state: { registered: true, mail: this.mail.trim() },
        });
      })
      .finally(() => (this.busy = false));
  }

  /** Nach dem Anmelden: dorthin, woher man kam. Nur Adressen von mampf selbst. */
  private goBack() {
    const back = this.route.snapshot.queryParams['zurueck'];
    if (back === 'karte') {
      this.mapActions.loggedIn.next();
    } else if (typeof back === 'string' && /^\/[a-z0-9]/i.test(back)) {
      this.router.navigateByUrl(back, { replaceUrl: true });
    } else {
      this.router.navigate(['/meine-orte'], { replaceUrl: true });
    }
  }

  private post(url: string, body: object): Promise<boolean> {
    return fetch(url, {
      method: 'post',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(body),
    })
      .then(response => response.ok)
      .catch(() => false);
  }
}

/** random-name.js nur einmal und erst bei Bedarf laden. */
function loadRandomNameScript() {
  if (window.mampfRandomName || document.getElementById('random-name-script'))
    return;
  const script = document.createElement('script');
  script.id = 'random-name-script';
  script.src = '/assets/random-name.js';
  document.head.appendChild(script);
}
