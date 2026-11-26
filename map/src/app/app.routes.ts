import { Routes } from '@angular/router';
import { loginGuard } from './admin/login-guard';

/**
 * Unterseiten der Karte. Die Admin-Panels liegen über der Karte (wie die About-Seite).
 * Ihr Code wird erst geladen, wenn jemand sie öffnet ("Lazy Loading"),
 * damit die Karte für normale Besucher gleich schnell bleibt.
 * Die alten Adressen /admin/... leiten auf diese hier weiter (map/public/admin/.htaccess).
 */
export const routes: Routes = [
  { path: '', children: [] },
  {
    path: 'meine-orte',
    canActivate: [loginGuard],
    loadComponent: () =>
      import('./admin/my-places-panel/my-places-panel.component').then(
        m => m.MyPlacesPanelComponent
      ),
  },
  {
    path: 'ort/neu',
    canActivate: [loginGuard],
    loadComponent: () =>
      import('./admin/place-form/place-form.component').then(
        m => m.PlaceFormComponent
      ),
  },
  {
    path: 'ort/:id',
    canActivate: [loginGuard],
    loadComponent: () =>
      import('./admin/place-form/place-form.component').then(
        m => m.PlaceFormComponent
      ),
  },
  // Frühere Adresse /profil (Seite heisst jetzt "Konto")
  { path: 'profil', redirectTo: 'konto' },
  {
    path: 'konto',
    canActivate: [loginGuard],
    loadComponent: () =>
      import('./admin/profile-panel/profile-panel.component').then(
        m => m.ProfilePanelComponent
      ),
  },
  {
    path: 'kategorien',
    canActivate: [loginGuard],
    loadComponent: () =>
      import('./admin/category-panel/category-panel.component').then(
        m => m.CategoryPanelComponent
      ),
  },
  {
    path: 'anmelden',
    data: { mode: 'login' },
    loadComponent: () =>
      import('./admin/auth-panel/auth-panel.component').then(m => m.AuthPanelComponent),
  },
  {
    path: 'registrieren',
    data: { mode: 'register' },
    loadComponent: () =>
      import('./admin/auth-panel/auth-panel.component').then(m => m.AuthPanelComponent),
  },
  // Unbekannte Adresse: einfach die Karte
  { path: '**', redirectTo: '' },
];
