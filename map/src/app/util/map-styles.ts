/**
 * Kartenstil (ursprünglich von Snazzy Maps), passend zur Oberflächenfarbe.
 *
 * Die Farbtöne unten gelten für mampf-Grün (Farbton 175.5). Wählt jemand auf der
 * About-Seite eine andere Oberflächenfarbe, werden alle farbigen Werte (hue und
 * Wasser) um gleich viel auf dem Farbkreis gedreht. Grautöne bleiben, wie sie sind.
 */
import { DEFAULT_HUE, rotateHue } from './color';

/** Kartenstil für einen Farbton der Oberfläche (0–360). */
export function mapStyles(hue: number): google.maps.MapTypeStyle[] {
  const shift = hue - DEFAULT_HUE;
  if (shift === 0) return MAP_STYLES;
  return MAP_STYLES.map(style => ({
    ...style,
    stylers: style.stylers?.map(styler => {
      const rotated: Record<string, unknown> = { ...styler };
      for (const key of ['hue', 'color'] as const) {
        const value = rotated[key];
        if (typeof value === 'string') rotated[key] = rotateHue(value, shift);
      }
      return rotated;
    }),
  }));
}

const MAP_STYLES = [
  {
    featureType: 'landscape.man_made',
    elementType: 'geometry.fill',
    stylers: [
      { weight: '1' },
      { saturation: '-30' },
      { hue: '#ff002d' },
    ],
  },
  {
    featureType: 'landscape.natural',
    elementType: 'all',
    stylers: [
      { weight: '1.00' },
    ],
  },
  {
    featureType: 'landscape.natural',
    elementType: 'geometry',
    stylers: [
      { hue: '#00ffe8' },
    ],
  },
  {
    featureType: 'landscape.natural',
    elementType: 'labels',
    stylers: [
      { visibility: 'off' },
    ],
  },
  {
    featureType: 'poi',
    elementType: 'geometry',
    stylers: [
      { hue: '#00ffea' },
    ],
  },
  {
    featureType: 'poi',
    elementType: 'labels',
    stylers: [
      { visibility: 'on' },
    ],
  },
  {
    featureType: 'poi.attraction',
    elementType: 'all',
    stylers: [
      { visibility: 'off' },
    ],
  },
  {
    featureType: 'poi.business',
    elementType: 'all',
    stylers: [
      { visibility: 'off' },
    ],
  },
  {
    featureType: 'poi.government',
    elementType: 'all',
    stylers: [
      { visibility: 'off' },
    ],
  },
  {
    featureType: 'poi.medical',
    elementType: 'all',
    stylers: [
      { visibility: 'off' },
    ],
  },
  {
    featureType: 'poi.park',
    elementType: 'all',
    stylers: [
      { hue: '#00ffea' },
    ],
  },
  {
    featureType: 'poi.school',
    elementType: 'all',
    stylers: [
      { visibility: 'off' },
    ],
  },
  {
    featureType: 'poi.sports_complex',
    elementType: 'all',
    stylers: [
      { hue: '#00ffea' },
      { visibility: 'off' },
    ],
  },
  {
    featureType: 'road',
    elementType: 'all',
    stylers: [
      { visibility: 'simplified' },
    ],
  },
  {
    featureType: 'road',
    elementType: 'labels',
    stylers: [
      { visibility: 'off' },
    ],
  },
  {
    featureType: 'road.highway',
    elementType: 'all',
    stylers: [
      { visibility: 'on' },
    ],
  },
  {
    featureType: 'road.highway',
    elementType: 'geometry.fill',
    stylers: [
      { color: '#d3d3d3' },
    ],
  },
  {
    featureType: 'road.highway',
    elementType: 'geometry.stroke',
    stylers: [
      { color: '#b7b7b7' },
    ],
  },
  {
    featureType: 'road.highway',
    elementType: 'labels.icon',
    stylers: [
      { visibility: 'off' },
    ],
  },
  {
    featureType: 'road.local',
    elementType: 'geometry',
    stylers: [
      { hue: '#00ffea' },
      { visibility: 'on' },
    ],
  },
  {
    featureType: 'road.local',
    elementType: 'geometry.stroke',
    stylers: [
      { weight: '0.50' },
    ],
  },
  {
    featureType: 'road.local',
    elementType: 'labels.text',
    stylers: [
      { visibility: 'on' },
    ],
  },
  {
    featureType: 'transit.line',
    elementType: 'all',
    stylers: [
      { hue: '#ff002d' },
    ],
  },
  {
    featureType: 'transit.line',
    elementType: 'labels.text.stroke',
    stylers: [
      { color: '#f0f0f0' },
    ],
  },
  {
    featureType: 'transit.station',
    elementType: 'all',
    stylers: [
      { hue: '#ff002d' },
    ],
  },
  {
    featureType: 'water',
    elementType: 'geometry',
    stylers: [
      { visibility: 'on' },
      { color: '#459299' },
    ],
  },
  {
    featureType: 'water',
    elementType: 'labels',
    stylers: [
      { visibility: 'off' },
    ],
  },
] as google.maps.MapTypeStyle[];
