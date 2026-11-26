import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';

/**
 * Admin-Fenster nur mit Login. Ohne Login öffnet sich das Fenster "Anmelden",
 * danach geht es wieder zurück an dieselbe Stelle (Parameter "zurueck").
 */
export const loginGuard: CanActivateFn = async (_route, state) => {
  const router = inject(Router);
  const loggedIn = await fetch('/api/get-login-status.php', {
    cache: 'no-store',
  })
    .then(response => response.json())
    .then(data => !!data.loggedIn)
    .catch(() => false);
  return (
    loggedIn ||
    router.createUrlTree(['/anmelden'], { queryParams: { zurueck: state.url } })
  );
};
