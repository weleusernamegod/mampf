import { Place } from '../../dto/place';
import { isPlaceOpenOnDay } from '../../util/place-util';

/**
 * Eigene HTML-Marker für die Shops, als Ebene über der Google-Karte.
 *
 * Die normalen Google-Marker sind nur Bilder und lassen sich nicht animieren.
 * Diese Marker sind normale HTML-Elemente: Aussehen per CSS (siehe
 * map.component.scss, Klasse .place-marker), Animation per JavaScript.
 */
export interface PlacesOverlay {
  /** Zeigt die Shops an: offene grün und gross, geschlossene grau und klein. */
  update(places: Place[], day: number): void;
}

interface Marker {
  place: Place;
  latLng: google.maps.LatLng;
  element: HTMLElement; // wird auf der Karte positioniert
  dot: HTMLElement; // der sichtbare Punkt, wird animiert
  open: boolean | undefined;
}

/** Zufällige Verzögerung bis max. so viele ms, damit nicht alle exakt gleichzeitig ploppen. */
const MAX_DELAY = 90;

/** Punkt schrumpft auf nichts zusammen ... */
const SHRINK: Keyframe[] = [{ transform: 'scale(1)' }, { transform: 'scale(0)' }];
/** ... und ploppt von ganz klein wieder auf, etwas über das Ziel hinaus. */
const POP: Keyframe[] = [
  { transform: 'scale(0)' },
  { transform: 'scale(1.3)', offset: 0.6 },
  { transform: 'scale(1)' },
];

export function createPlacesOverlay(
  map: google.maps.Map,
  onClick: (place: Place) => void
): PlacesOverlay {
  // Die Klasse kann erst hier definiert werden, weil google.maps vorher noch
  // nicht geladen ist.
  class Overlay extends google.maps.OverlayView implements PlacesOverlay {
    private container = document.createElement('div');
    private markers = new Map<number, Marker>();

    override onAdd() {
      this.getPanes()?.overlayMouseTarget.appendChild(this.container);
    }

    override onRemove() {
      this.container.remove();
    }

    override draw() {
      const projection = this.getProjection();
      if (!projection) return;
      for (const marker of this.markers.values()) {
        const point = projection.fromLatLngToDivPixel(marker.latLng);
        if (!point) continue;
        marker.element.style.left = `${point.x}px`;
        marker.element.style.top = `${point.y}px`;
      }
    }

    update(places: Place[], day: number) {
      const ids = new Set(places.map(place => place.id));
      for (const [id, marker] of this.markers) {
        if (!ids.has(id)) {
          this.markers.delete(id);
          this.removeAnimated(marker);
        }
      }

      for (const place of places) {
        const marker = this.markers.get(place.id) ?? this.createMarker(place);
        marker.place = place;
        const open = isPlaceOpenOnDay(place, day);
        if (open !== marker.open) {
          this.animate(marker, open);
        }
      }

      this.draw();
    }

    private createMarker(place: Place): Marker {
      const element = document.createElement('div');
      element.className = 'place-marker';
      element.title = place.name;
      const dot = document.createElement('div');
      dot.className = 'dot';
      element.appendChild(dot);

      const marker: Marker = {
        place,
        latLng: new google.maps.LatLng(place.position),
        element,
        dot,
        open: undefined,
      };

      // Zoomen und Verschieben der Karte soll auch über einem Marker gehen.
      // Darum nur reagieren, wenn wirklich geklickt und nicht gezogen wurde.
      let downX = 0;
      let downY = 0;
      element.addEventListener('pointerdown', event => {
        downX = event.clientX;
        downY = event.clientY;
      });
      element.addEventListener('click', event => {
        event.stopPropagation();
        const moved = Math.hypot(event.clientX - downX, event.clientY - downY);
        if (moved < 6) onClick(marker.place);
      });

      this.container.appendChild(element);
      this.markers.set(place.id, marker);
      return marker;
    }

    /** Punkt wegschrumpfen und danach aus der Karte entfernen. */
    private removeAnimated(marker: Marker) {
      marker.dot.getAnimations().forEach(animation => animation.cancel());
      marker.element.style.pointerEvents = 'none';
      const shrink = marker.dot.animate(SHRINK, {
        duration: 180,
        easing: 'ease-in',
        delay: Math.random() * MAX_DELAY,
        fill: 'forwards',
      });
      shrink.onfinish = () => marker.element.remove();
    }

    /** Alten Punkt wegschrumpfen, dann den neuen von ganz klein aufploppen lassen. */
    private animate(marker: Marker, open: boolean) {
      const firstTime = marker.open === undefined;
      marker.open = open;
      marker.dot.getAnimations().forEach(animation => animation.cancel());

      const delay = Math.random() * MAX_DELAY;
      const pop = () => {
        // Aussehen erst wechseln, wenn der Punkt unsichtbar klein ist.
        marker.element.classList.toggle('open', marker.open);
        marker.dot.animate(POP, {
          duration: 380,
          easing: 'ease-out',
          delay: firstTime ? delay : 0,
          fill: 'backwards',
        });
      };

      if (firstTime) {
        pop();
        return;
      }

      const shrink = marker.dot.animate(SHRINK, {
        duration: 140,
        easing: 'ease-in',
        delay,
        fill: 'forwards',
      });
      shrink.onfinish = () => {
        pop();
        shrink.cancel();
      };
    }
  }

  const overlay = new Overlay();
  overlay.setMap(map);
  return overlay;
}
