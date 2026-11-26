import { CanActivateFn } from '@angular/router';

/**
 * Admin-Panels nur mit Login. Ohne Login geht es zur Login-Seite,
 * danach wieder zurück an dieselbe Stelle (login/index.html, Parameter "zurueck").
 */
export const loginGuard: CanActivateFn = async (_route, state) => {
  const loggedIn = await fetch('/api/get-login-status.php')
    .then(response => response.json())
    .then(data => !!data.loggedIn)
    .catch(() => false);
  if (!loggedIn) {
    window.location.href = '/login/?zurueck=' + encodeURIComponent(state.url);
  }
  return loggedIn;
};
