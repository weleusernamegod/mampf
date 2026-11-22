import {
  Component,
  ElementRef,
  EventEmitter,
  Input,
  OnChanges,
  Output,
  ViewChild,
} from '@angular/core';
import { Place } from '../../dto/place';
import { CategoryList } from '../../dto/category';
import { GroupedCategories, categoriesOf, groupCategories } from '../../util/category-filter';
import { OpenDaysComponent } from './open-days/open-days.component';
import { SLOTS, WEEKDAYS, hasOpening } from '../../util/place-util';

/** Abstand unter dem Inhalt der zugeklappten Infobox in px (wie padding-bottom im SCSS). */
const BOTTOM_PADDING = 15;
/** Ab so vielen px Fingerbewegung gilt es als Ziehen (statt Antippen). */
const DRAG_START = 8;
/** Zugeklappt so weit nach unten gezogen: Infobox schliessen. */
const CLOSE_DISTANCE = 60;
/** Schneller Wisch (px pro ms): Richtung entscheidet, egal wie weit. */
const FLICK_SPEED = 0.4;

/** Zustand während der Finger auf der Infobox liegt. */
interface Drag {
  startY: number;
  startHeight: number;
  lastY: number;
  lastTime: number;
  /** px pro ms, positiv = nach unten */
  speed: number;
  /** Erst true, wenn sich der Finger genug bewegt hat. */
  active: boolean;
}

@Component({
  selector: 'mampf-place-dialog',
  standalone: true,
  imports: [OpenDaysComponent],
  templateUrl: './place-dialog.component.html',
  styleUrl: './place-dialog.component.scss',
})
export class PlaceDialogComponent implements OnChanges {
  @Input() place: Place | undefined = undefined;
  /** Im Slider gewählter Wochentag (0 = Sonntag, 1 = Montag, ...). */
  @Input() day: number = new Date().getDay();
  /** Alle Kategorien, um die Namen anzuzeigen. */
  @Input() categoryList: CategoryList = { groups: [], categories: [] };
  /** Klick auf das kleine X */
  @Output() closed: EventEmitter<void> = new EventEmitter<void>();

  @ViewChild('dialog', { static: true }) dialog!: ElementRef<HTMLElement>;
  @ViewChild('wrapper', { static: true }) wrapper!: ElementRef<HTMLElement>;
  @ViewChild('summary', { static: true }) summary!: ElementRef<HTMLElement>;

  /** Aufgeschoben (alle Infos sichtbar)? */
  expanded = false;
  /** Erst nach dem Aufschieben scrollbar, falls der Inhalt zu hoch ist. */
  scrollable = false;

  /** Kurz für den gewählten Tag, z.B. "Heute: Mittag, Abend". */
  openingHours: string | undefined;
  /** Nur bei mehreren Standorten, z.B. "Mo Helvetiaplatz · Fr Bahnhof Altstetten". */
  locations: string | undefined;
  pictureUrl: string | undefined;
  /** Kategorien des Shops nach Gruppe (ohne Wartezeit). */
  categoryGroups: GroupedCategories[] = [];
  /** z.B. "5–15 Minuten" */
  waitingTime: string | undefined;
  /** Erstellungsdatum, z.B. "12.11.2026". */
  createdText: string | undefined;
  /** "Missbrauch melden" gibt es noch nicht: kurz "kommt bald" anzeigen. */
  reportHint = false;
  private reportTimer: ReturnType<typeof setTimeout> | undefined;

  private drag: Drag | undefined = undefined;
  /** Nach dem Ziehen keinen zusätzlichen Klick auswerten. */
  private ignoreClick = false;

  ngOnChanges(): void {
    if (this.place) {
      this.openingHours = this.generateOpeningHours(this.place, this.day);
      this.locations = this.generateLocations(this.place);
      this.pictureUrl = this.place.pictureId
        ? `api/get-public-picture.php?id=${this.place.pictureId}`
        : 'assets/no-picture.jpg';
      const groups = groupCategories(
        this.categoryList,
        categoriesOf(this.place, this.categoryList)
      );
      this.categoryGroups = groups.filter(group => group.key !== 'wartezeit');
      const [year, month, day] = (this.place.created ?? '').split('-');
      this.createdText = day ? `${day}.${month}.${year}` : undefined;
      this.reportHint = false;
      this.waitingTime = groups
        .find(group => group.key === 'wartezeit')
        ?.categories.map(category => category.name)
        .join(', ');
    }
    // Neuer Ort: wieder zugeklappt anfangen. Die Höhe erst messen, wenn der
    // neue Text auf der Seite steht (kurz danach).
    this.expanded = false;
    this.scrollable = false;
    setTimeout(() => {
      if (!this.expanded) this.setHeight(this.minimizedHeight());
    });
  }

  /** Platzhalter: Melden kommt später, bis dahin nur ein kurzer Hinweis. */
  onReportClicked(event: Event): void {
    event.stopPropagation(); // Infobox nicht zuklappen
    this.reportHint = true;
    clearTimeout(this.reportTimer);
    this.reportTimer = setTimeout(() => (this.reportHint = false), 2500);
  }

  /** Antippen / Klicken: auf- bzw. zuklappen. */
  onClick(): void {
    if (this.ignoreClick) return;
    this.setExpanded(!this.expanded);
  }

  private setExpanded(expanded: boolean): void {
    const element = this.dialog.nativeElement;
    this.expanded = expanded;
    this.scrollable = false;

    const target = expanded ? this.maximizedHeight() : this.minimizedHeight();
    if (!expanded) element.scrollTop = 0;
    if (Math.round(element.offsetHeight) === Math.round(target)) {
      // Höhe stimmt schon (z.B. genau bis oben gezogen): es gibt keine Animation
      this.scrollable = expanded && element.scrollHeight > element.clientHeight;
    }
    this.setHeight(target);
  }

  // --- Mit dem Finger hochziehen / runterziehen -------------------------

  onTouchStart(event: TouchEvent): void {
    if (event.touches.length !== 1) {
      this.drag = undefined;
      return;
    }
    const y = event.touches[0].clientY;
    this.drag = {
      startY: y,
      startHeight: this.dialog.nativeElement.offsetHeight,
      lastY: y,
      lastTime: event.timeStamp,
      speed: 0,
      active: false,
    };
  }

  onTouchMove(event: TouchEvent): void {
    const drag = this.drag;
    if (!drag || event.touches.length !== 1) return;
    const element = this.dialog.nativeElement;
    const y = event.touches[0].clientY;
    const dy = y - drag.startY; // positiv = nach unten

    if (!drag.active) {
      if (Math.abs(dy) < DRAG_START) return;
      // Aufgeklappt mit langem Inhalt: normal scrollen. Nur wenn ganz oben
      // nach unten gezogen wird, klappt die Infobox wieder zu.
      if (this.scrollable && (dy < 0 || element.scrollTop > 0)) {
        this.drag = undefined;
        return;
      }
      drag.active = true;
      element.classList.add('dragging'); // keine Animation, folgt direkt dem Finger
    }

    event.preventDefault();
    const dt = event.timeStamp - drag.lastTime;
    if (dt > 0) drag.speed = (y - drag.lastY) / dt;
    drag.lastY = y;
    drag.lastTime = event.timeStamp;

    const min = this.minimizedHeight();
    const max = this.maximizedHeight();
    let height = drag.startHeight - dy;
    if (height < min) {
      height = min - (min - height) * 0.4; // unten etwas gebremst
    }
    this.setHeight(Math.min(height, max));
  }

  onTouchEnd(): void {
    const drag = this.drag;
    this.drag = undefined;
    if (!drag?.active) return;

    const element = this.dialog.nativeElement;
    element.classList.remove('dragging');
    this.ignoreClick = true;
    setTimeout(() => (this.ignoreClick = false), 400);

    const dy = drag.lastY - drag.startY;
    const min = this.minimizedHeight();
    const max = this.maximizedHeight();

    // Zugeklappt nach unten gewischt: schliessen
    if (!this.expanded && (dy > CLOSE_DISTANCE || drag.speed > FLICK_SPEED)) {
      this.closed.emit();
      return;
    }

    let expand: boolean;
    if (drag.speed < -FLICK_SPEED) {
      expand = true;
    } else if (drag.speed > FLICK_SPEED) {
      expand = false;
    } else {
      expand = element.offsetHeight > (min + max) / 2;
    }
    this.setExpanded(expand);
  }

  onTransitionEnd(event: TransitionEvent) {
    if (event.target !== this.dialog.nativeElement || event.propertyName !== 'height') {
      return;
    }
    const element = this.dialog.nativeElement;
    this.scrollable = this.expanded && element.scrollHeight > element.clientHeight;
  }

  /**
   * Höhe der zugeklappten Infobox: so hoch, dass Bild, Name, Beschreibung und
   * Öffnungszeiten ganz sichtbar sind, auch wenn der Text mehrzeilig ist.
   */
  private minimizedHeight(): number {
    const summary = this.summary.nativeElement;
    return summary.offsetTop + summary.offsetHeight + BOTTOM_PADDING;
  }

  /** Höhe aufgeklappt: ganzer Inhalt, höchstens so hoch wie Platz da ist. */
  private maximizedHeight(): number {
    const available = this.wrapper.nativeElement.clientHeight;
    return Math.min(this.dialog.nativeElement.scrollHeight, available);
  }

  private setHeight(px: number) {
    if (this.dialog) this.dialog.nativeElement.style.height = `${px}px`;
  }

  /** Öffnungszeiten am gewählten Tag, bei Foodtrucks mit dem Standort dieses Tages. */
  private generateOpeningHours(place: Place, day: number): string {
    const dayName =
      day === new Date().getDay()
        ? 'Heute'
        : WEEKDAYS.find(weekday => weekday.value === day)?.name ?? '';
    const slots = SLOTS.filter(slot => hasOpening(place.opening, day, slot.value)).map(
      slot => slot.name
    );
    const labels = place.locations
      .filter(location => location.weekday === day && location.label)
      .map(location => location.label);

    if (slots.length === 0) {
      return `${dayName} geschlossen`;
    }
    const text = `${dayName}: ${slots.join(', ')}`;
    return labels.length > 0 ? `${text} · ${labels.join(' / ')}` : text;
  }

  /**
   * Standorte eines Foodtrucks, Tage mit gleichem Standort zusammengefasst:
   * "Mo, Mi Helvetiaplatz · Fr Bahnhof Altstetten".
   */
  private generateLocations(place: Place): string | undefined {
    if (place.locations.length === 0) {
      return undefined;
    }
    const groups = new Map<string, string[]>();
    for (const weekday of WEEKDAYS) {
      for (const location of place.locations) {
        if (location.weekday !== weekday.value) continue;
        const label = location.label ?? '(ohne Bezeichnung)';
        const days = groups.get(label) ?? [];
        if (!days.includes(weekday.short)) days.push(weekday.short);
        groups.set(label, days);
      }
    }
    return [...groups.entries()]
      .map(([label, days]) => `${days.join(', ')} ${label}`)
      .join(' · ');
  }
}
