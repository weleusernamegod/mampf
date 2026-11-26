import { Routes } from '@angular/router';
import { loginGuard } from './admin/login-guard';

/**
 * Unterseiten der Karte. Die Admin-Panels liegen über der Karte (wie die About-Seite).
 * Ihr Code wird erst geladen, wenn jemand sie öffnet ("Lazy Loading"),
 * damit die Karte für normale Besucher gleich schnell bleibt.
 *
 * Achtung: /admin/... gehört noch der alten Admin-App (mampf-admin/).
 * Neue Adressen deshalb auf Deutsch, ohne /admin.
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
  {
    path: 'profil',
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
  // Unbekannte Adresse: einfach die Karte
  { path: '**', redirectTo: '' },
];
