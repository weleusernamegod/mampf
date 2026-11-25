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
import { categoriesOf, groupCategories } from '../../util/category-filter';
import { OpenDaysComponent } from './open-days/open-days.component';
import { CommentsComponent } from './comments/comments.component';
import { WEEKDAYS } from '../../util/place-util';
import { priceText } from '../../util/price';
import { Category } from '../../dto/category';

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
  imports: [OpenDaysComponent, CommentsComponent],
  templateUrl: './place-dialog.component.html',
  styleUrl: './place-dialog.component.scss',
})
export class PlaceDialogComponent implements OnChanges {
  @Input() place: Place | undefined = undefined;
  /** Im Slider gewählter Wochentag (0 = Sonntag, 1 = Montag, ...). */
  @Input() day: number = new Date().getDay();
  /** Alle Kategorien, um die Namen anzuzeigen. */
  @Input() categoryList: CategoryList = { groups: [], categories: [] };
  /** Nach dem Login zurück: gleich aufgeklappt mit offenem Kommentarfeld. */
  @Input() startComment = false;
  /** Klick auf das kleine X */
  @Output() closed: EventEmitter<void> = new EventEmitter<void>();

  @ViewChild('dialog', { static: true }) dialog!: ElementRef<HTMLElement>;
  @ViewChild('wrapper', { static: true }) wrapper!: ElementRef<HTMLElement>;
  @ViewChild('summary', { static: true }) summary!: ElementRef<HTMLElement>;
  @ViewChild('description', { static: true }) description!: ElementRef<HTMLElement>;
  @ViewChild('waitingChip') waitingChip: ElementRef<HTMLElement> | undefined;

  /** Aufgeschoben (alle Infos sichtbar)? */
  expanded = false;
  /** Erst nach dem Aufschieben scrollbar, falls der Inhalt zu hoch ist. */
  scrollable = false;

  /** Nur bei mehreren Standorten, z.B. "Mo Helvetiaplatz · Fr Bahnhof Altstetten". */
  locations: string | undefined;
  pictureUrl: string | undefined;
  /** Art des Lokals als erster Chip, z.B. "Imbiss-Stand". */
  kind: string | undefined;
  /** Bild gross über die ganze Infobox? */
  photoOpen = false;
  /** Preis als Chip neben der Art, z.B. "CHF 13–18". */
  price: string | undefined;
  /** Küche, Gerichte und Präferenzen als Chips beim Aufschieben. */
  kitchen: Category[] = [];
  dishes: Category[] = [];
  preferences: Category[] = [];
  /** z.B. "5–15 Min": als Chip, wenn Platz ist, sonst erst aufgeklappt. */
  waitingTime: string | undefined;
  /** Beschreibung passt zugeklappt nicht auf eine Zeile ("… mehr")? */
  descriptionTruncated = false;
  /** Gekürzte Beschreibung für zugeklappt, an einer Wortgrenze abgeschnitten. */
  shortDescription = '';
  /** Passt die Wartezeit noch neben Art und Preis? (wird nach dem Anzeigen gemessen) */
  waitingFits = true;
  /** Link kurz angezeigt, ohne https:// und www., z.B. "pizza-paolo.ch/menu". */
  websiteText = '';
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
      this.locations = this.generateLocations(this.place);
      this.pictureUrl = this.place.pictureUrl ?? 'assets/marktstand.svg';
      const groups = groupCategories(
        this.categoryList,
        categoriesOf(this.place, this.categoryList)
      );
      const group = (key: string) =>
        groups.find(group => group.key === key)?.categories ?? [];
      this.kind = group('art')[0]?.name;
      this.kitchen = group('kueche');
      this.dishes = group('gericht');
      this.preferences = group('praeferenz');
      this.waitingTime = group('wartezeit')
        .map(category => category.name)
        .join(', ') || undefined;
      const [year, month, day] = (this.place.created ?? '').split('-');
      this.createdText = day ? `${day}.${month}.${year}` : undefined;
      this.reportHint = false;
      this.websiteText = (this.place.website ?? '')
        .replace(/^https?:\/\//i, '')
        .replace(/^www\./i, '')
        .replace(/\/$/, '');
      this.price =
        this.place.priceMin != null && this.place.priceMax != null
          ? priceText(this.place.priceMin, this.place.priceMax)
          : undefined;
    }
    this.photoOpen = false;
    // Neuer Ort: wieder zugeklappt anfangen. Die Höhe erst messen, wenn der
    // neue Text auf der Seite steht (kurz danach).
    this.expanded = false;
    this.scrollable = false;
    setTimeout(() => {
      this.waitingFits = this.measureWaitingFits();
      this.shortenDescription();
      document.fonts?.ready.then(() => this.shortenDescription());
      if (this.startComment) {
        this.setExpanded(true);
      } else if (!this.expanded) {
        this.setHeight(this.minimizedHeight());
      }
    });
  }

  /**
   * Zugeklappt hat die Beschreibung nur eine Zeile. Ist sie zu lang, wird sie
   * an einer Wortgrenze gekürzt, damit "… mehr" (grau, kursiv) noch dahinter passt.
   */
  private shortenDescription(): void {
    const text = this.place?.description ?? '';
    const box = this.description.nativeElement;
    const available = box.clientWidth;
    const style = getComputedStyle(box);
    const context = document.createElement('canvas').getContext('2d');
    if (!context || available === 0) {
      this.descriptionTruncated = false;
      return;
    }
    const font = `${style.fontSize} ${style.fontFamily}`;
    const width = (value: string, italic = false) => {
      context.font = (italic ? 'italic ' : '') + font;
      return context.measureText(value).width;
    };

    if (width(text) <= available) {
      this.descriptionTruncated = false;
      return;
    }
    const space = available - width('… mehr', true) - 2;
    let words = text.split(' ');
    while (words.length > 1 && width(words.join(' ')) > space) {
      words = words.slice(0, -1);
    }
    let short = words.join(' ');
    // Ein einziges sehr langes Wort: dann halt mitten im Wort kürzen
    while (short.length > 1 && width(short) > space) {
      short = short.slice(0, -1);
    }
    this.shortDescription = short.replace(/[\s,;:.\-–]+$/, ''); // kein Komma vor "…"
    this.descriptionTruncated = true;
  }

  /** Steht der Wartezeit-Chip noch auf der ersten Zeile (oder ist er umgebrochen)? */
  private measureWaitingFits(): boolean {
    const chip = this.waitingChip?.nativeElement;
    if (!chip) return true;
    const row = chip.parentElement as HTMLElement;
    return chip.offsetTop - row.offsetTop < chip.offsetHeight / 2;
  }

  /** Platzhalter: Melden kommt später, bis dahin nur ein kurzer Hinweis. */
  onReportClicked(event: Event): void {
    event.stopPropagation(); // Infobox nicht zuklappen
    this.reportHint = true;
    clearTimeout(this.reportTimer);
    this.reportTimer = setTimeout(() => (this.reportHint = false), 2500);
  }

  /** Inhalt hat sich geändert (z.B. Kommentare geladen): aufgeklappt neu messen. */
  onContentChanged(): void {
    if (!this.expanded || this.photoOpen) return;
    const element = this.dialog.nativeElement;
    const target = this.maximizedHeight();
    if (Math.round(element.offsetHeight) === Math.round(target)) {
      this.scrollable = element.scrollHeight > element.clientHeight;
    }
    this.setHeight(target);
  }

  /** Antippen / Klicken: auf- bzw. zuklappen. */
  onClick(): void {
    if (this.ignoreClick) return;
    this.setExpanded(!this.expanded);
  }

  /** Klick aufs kleine Bild: gross über die ganze Infobox (quadratisch). */
  openPhoto(event: Event): void {
    event.stopPropagation(); // nicht zusätzlich auf-/zuklappen
    if (this.ignoreClick) return;
    const element = this.dialog.nativeElement;
    element.scrollTop = 0;
    this.scrollable = false;
    this.photoOpen = true;
    // So hoch wie breit, damit das Bild quadratisch Platz hat (höchstens so hoch wie Platz da ist)
    const available = this.wrapper.nativeElement.clientHeight;
    this.setHeight(Math.min(Math.max(element.offsetWidth, element.offsetHeight), available));
  }

  /** Klick aufs grosse Bild: wieder klein, Infobox wie vorher. */
  closePhoto(event: Event): void {
    event.stopPropagation();
    this.setExpanded(this.expanded);
  }

  private setExpanded(expanded: boolean): void {
    const element = this.dialog.nativeElement;
    this.photoOpen = false;
    this.expanded = expanded;
    this.scrollable = false;

    // Klasse gleich setzen (nicht erst beim nächsten Angular-Durchlauf), damit
    // die Höhe mit dem richtigen Layout gemessen wird: aufgeklappt ist die
    // Beschreibung mehrzeilig, zugeklappt nur eine Zeile.
    element.classList.toggle('expanded', expanded);
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
    return Math.min(this.naturalHeight(), available);
  }

  /**
   * Wie hoch wäre der Inhalt ohne feste Höhe? (scrollHeight allein wird nie
   * kleiner als die aktuelle Höhe, z.B. nach "Abbrechen" beim Kommentar.)
   * Kurz ohne Animation auf "auto" messen, dann alles wie vorher.
   */
  private naturalHeight(): number {
    const element = this.dialog.nativeElement;
    const height = element.style.height;
    const transition = element.style.transition;
    element.style.transition = 'none';
    element.style.height = 'auto';
    const natural = element.offsetHeight;
    element.style.height = height;
    void element.offsetHeight; // alte Höhe festhalten, damit die Animation von dort startet
    element.style.transition = transition;
    return natural;
  }

  private setHeight(px: number) {
    if (this.dialog) this.dialog.nativeElement.style.height = `${px}px`;
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
