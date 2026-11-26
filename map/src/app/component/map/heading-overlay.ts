/**
 * Blickrichtung des Nutzers, wie bei Google Maps: ein dezenter blauer Lichtkegel,
 * der beim eigenen Standort schon so breit wie der Punkt beginnt und schnell
 * verblasst. Zeigt in die Richtung, in die das Handy schaut. Liegt unter dem blauen Punkt.
 * Aussehen per CSS (map.component.scss, Klasse .heading-beam).
 */
export interface HeadingOverlay {
  setPosition(position: google.maps.LatLngLiteral): void;
  /** Grad im Uhrzeigersinn ab Norden, null = unbekannt (Fächer ausblenden). */
  setHeading(heading: number | null): void;
}

export function createHeadingOverlay(map: google.maps.Map): HeadingOverlay {
  // Die Klasse kann erst hier definiert werden, weil google.maps vorher noch
  // nicht geladen ist.
  class Overlay extends google.maps.OverlayView implements HeadingOverlay {
    private element = document.createElement('div');
    private position: google.maps.LatLng | undefined;
    /** Fortlaufender Winkel (kann über 360 gehen), damit die Drehung nie den langen Weg nimmt. */
    private rotation: number | undefined;

    constructor() {
      super();
      this.element.className = 'heading-beam';
      this.element.hidden = true;
    }

    override onAdd() {
      this.getPanes()?.overlayLayer.appendChild(this.element);
    }

    override onRemove() {
      this.element.remove();
    }

    override draw() {
      const projection = this.getProjection();
      if (!projection || !this.position) return;
      const point = projection.fromLatLngToDivPixel(this.position);
      if (!point) return;
      this.element.style.left = `${point.x}px`;
      this.element.style.top = `${point.y}px`;
    }

    setPosition(position: google.maps.LatLngLiteral) {
      this.position = new google.maps.LatLng(position);
      this.draw();
    }

    setHeading(heading: number | null) {
      if (heading === null || !Number.isFinite(heading)) {
        this.element.hidden = true;
        return;
      }
      if (this.rotation === undefined) {
        this.rotation = heading;
      } else {
        // Kürzester Weg: z.B. von 350° nach 10° über Norden, nicht zurück über Süden
        const delta = ((heading - this.rotation) % 360 + 540) % 360 - 180;
        this.rotation += delta;
      }
      this.element.style.rotate = `${this.rotation}deg`;
      this.element.hidden = false;
    }
  }

  const overlay = new Overlay();
  overlay.setMap(map);
  return overlay;
}

/** iOS: Kompass-Richtung direkt vom Gerät. */
interface IosOrientationEvent extends DeviceOrientationEvent {
  webkitCompassHeading?: number;
}

/** iOS will vor dem Kompass eine Erlaubnis (nur nach einem Antippen möglich). */
interface OrientationEventWithPermission {
  requestPermission?: () => Promise<'granted' | 'denied'>;
}

/**
 * Liest die Himmelsrichtung, in die das Handy zeigt, und ruft callback damit auf
 * (Grad im Uhrzeigersinn ab Norden). Auf dem Computer passiert einfach nichts.
 */
export class CompassWatcher {
  private started = false;

  constructor(private callback: (heading: number) => void) {}

  /** Läuft gerade eine Anfrage (iOS zeigt dann den Erlaubnis-Dialog)? */
  private asking = false;
  /** Erlaubnis erteilt oder abgelehnt: nicht mehr fragen. */
  private answered = false;

  /**
   * Android & Co.: ohne Erlaubnis starten.
   * iOS: Die Erlaubnis darf nur nach einem Antippen abgefragt werden. Darum
   * beim ersten Antippen irgendwo auf der Seite automatisch fragen.
   */
  start(): void {
    if (!this.permissionFunction()) {
      this.listen();
      return;
    }
    const onTap = () => {
      this.requestPermission();
      if (this.answered || this.started) {
        document.removeEventListener('click', onTap, true);
        document.removeEventListener('touchend', onTap, true);
      }
    };
    document.addEventListener('click', onTap, true);
    document.addEventListener('touchend', onTap, true);
  }

  /** Muss direkt aus einem Antippen kommen, sonst lehnt iOS ab. */
  requestPermission(): void {
    const permission = this.permissionFunction();
    if (!permission || this.started || this.answered || this.asking) return;
    this.asking = true;
    permission
      .call(window.DeviceOrientationEvent)
      .then(result => {
        this.answered = true;
        if (result === 'granted') this.listen();
      })
      .catch(() => {
        // Nicht aus einem Antippen (z.B. Karte nur gezogen): beim nächsten Mal nochmals
      })
      .finally(() => (this.asking = false));
  }

  private permissionFunction() {
    return (window.DeviceOrientationEvent as unknown as OrientationEventWithPermission | undefined)
      ?.requestPermission;
  }

  private listen(): void {
    if (this.started || !('DeviceOrientationEvent' in window)) return;
    this.started = true;
    let frame: number | undefined;
    let latest: number | undefined;
    const handle = (event: Event) => {
      const heading = this.headingOf(event as IosOrientationEvent);
      if (heading === undefined) return;
      latest = heading;
      // Höchstens einmal pro Bild neu zeichnen
      if (frame === undefined) {
        frame = requestAnimationFrame(() => {
          frame = undefined;
          if (latest !== undefined) this.callback(latest);
        });
      }
    };
    // Chrome (Android): "absolute" = bezogen auf Norden. iOS: normales Ereignis mit webkitCompassHeading.
    const target: EventTarget = window;
    const absolute = 'ondeviceorientationabsolute' in target;
    target.addEventListener(absolute ? 'deviceorientationabsolute' : 'deviceorientation', handle);
  }

  private headingOf(event: IosOrientationEvent): number | undefined {
    // Handy quer gehalten: Bildschirm-Drehung dazuzählen
    const screenAngle = screen.orientation?.angle ?? 0;
    if (typeof event.webkitCompassHeading === 'number') {
      return (event.webkitCompassHeading + screenAngle) % 360;
    }
    if (event.absolute && typeof event.alpha === 'number') {
      // alpha zählt gegen den Uhrzeigersinn
      return (360 - event.alpha + screenAngle) % 360;
    }
    return undefined;
  }
}
