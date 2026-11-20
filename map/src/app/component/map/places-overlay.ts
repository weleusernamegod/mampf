import { Place } from '../../dto/place';
import { isPlaceOpenOnDay } from '../../util/place-util';

/**
 * Eigene HTML-Marker für die Shops, als Ebene über der Google-Karte.
 *
 * Die normalen Google-Marker sind nur Bilder und lassen sich nicht animieren.
 * Diese Marker sind normale HTML-Elemente: Aussehen per CSS (siehe
 * map.component.scss, Klassen .place-marker und .place-cluster),
 * Animation per JavaScript.
 *
 * Beim Rauszoomen werden nahe beieinander liegende offene Shops zu einer
 * Blase mit der Anzahl zusammengefasst ("Clustering").
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
  open: boolean | undefined; // undefined = noch nie angezeigt
  visible: boolean;
}

interface Cluster {
  element: HTMLElement;
  bubble: HTMLElement; // die sichtbare Blase, wird animiert
  members: Marker[];
}

/** Zufällige Verzögerung bis max. so viele ms, damit nicht alle exakt gleichzeitig ploppen. */
const MAX_DELAY = 90;
/** Shops, die näher als so viele Pixel beieinander liegen, werden zusammengefasst. */
const CLUSTER_RADIUS = 50;
/** Ab dieser Zoomstufe (Strassen-Ansicht) wird nichts mehr zusammengefasst. */
const CLUSTER_MAX_ZOOM = 16;

/** Punkt schrumpft auf nichts zusammen ... */
const SHRINK: Keyframe[] = [{ transform: 'scale(1)' }, { transform: 'scale(0)' }];
/** ... und ploppt von ganz klein wieder auf, etwas über das Ziel hinaus. */
const POP: Keyframe[] = [
  { transform: 'scale(0)' },
  { transform: 'scale(1.3)', offset: 0.6 },
  { transform: 'scale(1)' },
];

function stopAnimations(element: HTMLElement) {
  element.getAnimations().forEach(animation => animation.cancel());
}

function pop(element: HTMLElement, delay = 0) {
  element.animate(POP, {
    duration: 380,
    easing: 'ease-out',
    delay,
    fill: 'backwards',
  });
}

function shrink(element: HTMLElement, delay = 0): Animation {
  return element.animate(SHRINK, {
    duration: 160,
    easing: 'ease-in',
    delay,
    fill: 'forwards',
  });
}

/** Reagiert nur auf echte Klicks, nicht wenn die Karte gezogen wurde. */
function onTap(element: HTMLElement, callback: () => void) {
  let downX = 0;
  let downY = 0;
  element.addEventListener('pointerdown', event => {
    downX = event.clientX;
    downY = event.clientY;
  });
  element.addEventListener('click', event => {
    event.stopPropagation();
    const moved = Math.hypot(event.clientX - downX, event.clientY - downY);
    if (moved < 6) callback();
  });
}

export function createPlacesOverlay(
  map: google.maps.Map,
  onClick: (place: Place) => void
): PlacesOverlay {
  // Die Klasse kann erst hier definiert werden, weil google.maps vorher noch
  // nicht geladen ist.
  class Overlay extends google.maps.OverlayView implements PlacesOverlay {
    private container = document.createElement('div');
    private markers = new Map<number, Marker>();
    /** Sichtbare Blasen, Schlüssel = ID des ersten Shops darin. */
    private clusters = new Map<number, Cluster>();
    private lastZoom: number | undefined = undefined;

    override onAdd() {
      this.getPanes()?.overlayMouseTarget.appendChild(this.container);
    }

    override onRemove() {
      this.container.remove();
    }

    override draw() {
      // Nach dem Zoomen neu zusammenfassen, beim Verschieben nicht nötig.
      const zoom = map.getZoom();
      if (zoom !== this.lastZoom) {
        this.lastZoom = zoom;
        this.updateClusters();
      }
      this.position();
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
        this.setOpen(marker, isPlaceOpenOnDay(place, day));
      }

      this.updateClusters();
      this.position();
    }

    // ---------- Zusammenfassen ----------

    private updateClusters() {
      if (!this.getProjection() || !map.getProjection()) return;

      const groups = this.groupNearby();
      const hidden = new Set<Marker>();
      const keys = new Set<number>();

      for (const group of groups) {
        if (group.length < 2) continue;
        const key = group[0].place.id;
        keys.add(key);
        group.forEach(marker => hidden.add(marker));
        this.showCluster(key, group);
      }

      // Blasen, die es nicht mehr gibt, wegschrumpfen
      for (const [key, cluster] of this.clusters) {
        if (!keys.has(key)) {
          this.clusters.delete(key);
          stopAnimations(cluster.bubble);
          cluster.element.style.pointerEvents = 'none';
          shrink(cluster.bubble).onfinish = () => cluster.element.remove();
        }
      }

      // Geschlossene Shops verstecken, wenn sie unter einer Blase liegen
      const clusterPoints = [...this.clusters.values()].map(cluster =>
        this.worldPixel(this.center(cluster.members))
      );
      for (const marker of this.markers.values()) {
        if (marker.open) {
          this.setVisible(marker, !hidden.has(marker));
        } else {
          const point = this.worldPixel(marker.latLng);
          const underCluster = clusterPoints.some(
            other => this.distance(point, other) < CLUSTER_RADIUS
          );
          this.setVisible(marker, !underCluster);
        }
      }
    }

    /** Offene Shops in Gruppen einteilen, die nah beieinander liegen. */
    private groupNearby(): Marker[][] {
      const open = [...this.markers.values()]
        .filter(marker => marker.open)
        .sort((a, b) => a.place.id - b.place.id);

      if ((map.getZoom() ?? 0) >= CLUSTER_MAX_ZOOM) {
        return open.map(marker => [marker]);
      }

      const points = new Map(
        open.map(marker => [marker, this.worldPixel(marker.latLng)])
      );
      const groups: Marker[][] = [];
      const assigned = new Set<Marker>();
      for (const seed of open) {
        if (assigned.has(seed)) continue;
        const seedPoint = points.get(seed)!;
        const group = open.filter(
          marker =>
            !assigned.has(marker) &&
            this.distance(seedPoint, points.get(marker)!) < CLUSTER_RADIUS
        );
        group.forEach(marker => assigned.add(marker));
        groups.push(group);
      }
      return groups;
    }

    private showCluster(key: number, members: Marker[]) {
      let cluster = this.clusters.get(key);
      if (!cluster) {
        const element = document.createElement('div');
        element.className = 'place-cluster';
        const bubble = document.createElement('div');
        bubble.className = 'bubble';
        element.appendChild(bubble);
        cluster = { element, bubble, members };
        const created = cluster;
        onTap(element, () => this.zoomInto(created));
        this.container.appendChild(element);
        this.clusters.set(key, cluster);
        pop(bubble, Math.random() * MAX_DELAY);
      }
      cluster.members = members;
      cluster.bubble.textContent = String(members.length);
      // Grössere Gruppe = etwas grössere Blase
      const size = Math.round(30 + Math.min(14, Math.log2(members.length) * 4));
      cluster.bubble.style.width = `${size}px`;
      cluster.bubble.style.height = `${size}px`;
    }

    /** Klick auf eine Blase: so weit hineinzoomen, dass die Shops einzeln sichtbar sind. */
    private zoomInto(cluster: Cluster) {
      const bounds = new google.maps.LatLngBounds();
      cluster.members.forEach(marker => bounds.extend(marker.latLng));
      const zoomBefore = map.getZoom() ?? 0;
      map.fitBounds(bounds, 80);
      google.maps.event.addListenerOnce(map, 'idle', () => {
        const zoom = map.getZoom() ?? 0;
        if (zoom > CLUSTER_MAX_ZOOM + 1) {
          // Shops sehr nah beieinander: nicht unendlich weit hineinzoomen
          map.setZoom(CLUSTER_MAX_ZOOM + 1);
        } else if (zoom <= zoomBefore) {
          // Passte schon alles ins Bild: trotzdem eine Stufe näher
          map.setZoom(zoomBefore + 1);
        }
      });
    }

    // ---------- Positionieren ----------

    private position() {
      const projection = this.getProjection();
      if (!projection) return;
      for (const marker of this.markers.values()) {
        this.place(marker.element, this.pixel(projection, marker.latLng));
      }
      for (const cluster of this.clusters.values()) {
        const point = this.pixel(projection, this.center(cluster.members));
        this.place(cluster.element, point);
      }
    }

    private place(element: HTMLElement, point: google.maps.Point) {
      element.style.left = `${point.x}px`;
      element.style.top = `${point.y}px`;
    }

    private pixel(
      projection: google.maps.MapCanvasProjection,
      latLng: google.maps.LatLng
    ): google.maps.Point {
      return projection.fromLatLngToDivPixel(latLng) ?? new google.maps.Point(0, 0);
    }

    /**
     * Position in Pixeln bei der aktuellen Ziel-Zoomstufe. Anders als
     * pixel() stimmt das auch schon, während die Zoom-Animation noch läuft.
     */
    private worldPixel(latLng: google.maps.LatLng): google.maps.Point {
      const point = map.getProjection()?.fromLatLngToPoint(latLng);
      const scale = 2 ** (map.getZoom() ?? 0);
      return new google.maps.Point((point?.x ?? 0) * scale, (point?.y ?? 0) * scale);
    }

        private center(members: Marker[]): google.maps.LatLng {
      const lat = members.reduce((sum, m) => sum + m.latLng.lat(), 0) / members.length;
      const lng = members.reduce((sum, m) => sum + m.latLng.lng(), 0) / members.length;
      return new google.maps.LatLng(lat, lng);
    }

    private distance(a: google.maps.Point, b: google.maps.Point): number {
      return Math.hypot(a.x - b.x, a.y - b.y);
    }

    // ---------- Einzelne Shops ----------

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
        // Erst unsichtbar: updateClusters() entscheidet, ob der Shop einzeln
        // erscheint (aufploppen) oder in einer Blase steckt.
        visible: false,
      };
      element.style.visibility = 'hidden';
      element.style.pointerEvents = 'none';

      // Zoomen und Verschieben der Karte soll auch über einem Marker gehen.
      onTap(element, () => onClick(marker.place));

      this.container.appendChild(element);
      this.markers.set(place.id, marker);
      return marker;
    }

    /** Punkt wegschrumpfen und danach aus der Karte entfernen. */
    private removeAnimated(marker: Marker) {
      stopAnimations(marker.dot);
      marker.element.style.pointerEvents = 'none';
      shrink(marker.dot, Math.random() * MAX_DELAY).onfinish = () =>
        marker.element.remove();
    }

    /** Offen/geschlossen wechseln: wegschrumpfen, Aussehen ändern, aufploppen. */
    private setOpen(marker: Marker, open: boolean) {
      if (open === marker.open) return;
      const firstTime = marker.open === undefined;
      marker.open = open;
      stopAnimations(marker.dot);

      const swap = () => marker.element.classList.toggle('open', marker.open);

      if (firstTime || !marker.visible) {
        swap();
        return;
      }

      const animation = shrink(marker.dot, Math.random() * MAX_DELAY);
      animation.onfinish = () => {
        swap();
        pop(marker.dot);
        animation.cancel();
      };
    }

    /** Einblenden (aufploppen) oder ausblenden (wegschrumpfen), z.B. für Blasen. */
    private setVisible(marker: Marker, visible: boolean) {
      if (visible === marker.visible) return;
      marker.visible = visible;
      stopAnimations(marker.dot);
      marker.element.classList.toggle('open', marker.open);

      if (visible) {
        marker.element.style.visibility = '';
        marker.element.style.pointerEvents = '';
        pop(marker.dot, Math.random() * MAX_DELAY);
      } else {
        marker.element.style.pointerEvents = 'none';
        shrink(marker.dot).onfinish = () => {
          marker.element.style.visibility = 'hidden';
        };
      }
    }
  }

  const overlay = new Overlay();
  overlay.setMap(map);
  return overlay;
}
