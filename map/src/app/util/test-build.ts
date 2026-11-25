/**
 * Läuft die Seite als Test-Build (nicht auf mampf.io live)?
 * Test-Build = lokal (localhost, 127.0.0.1, Heimnetz-Adressen wie 192.168.x.x)
 * oder eine Test-Subdomain (staging.… / test.…).
 */
export function isTestBuild(hostname = window.location.hostname): boolean {
  return (
    hostname === 'localhost' ||
    hostname.endsWith('.localhost') ||
    hostname.endsWith('.local') ||
    /^(127\.|10\.|192\.168\.|172\.(1[6-9]|2\d|3[01])\.)/.test(hostname) ||
    hostname === '[::1]' ||
    /^(staging|test)\./.test(hostname)
  );
}
