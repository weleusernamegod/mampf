import {
  Component,
  ElementRef,
  EventEmitter,
  Input,
  OnChanges,
  Output,
  SimpleChanges,
  ViewChild,
  inject,
} from '@angular/core';
import { Router } from '@angular/router';
import { PlaceComment, CommentList } from '../../../dto/comment';
import { savePendingComment } from '../../../util/pending-comment';

/** Höchstlänge eines Kommentars (der Server prüft das auch). */
const MAX_LENGTH = 130;

/**
 * Kommentare zu einem Ort: Liste für alle.
 *
 * Darüber ein Knopf "Kommentar abgeben":
 * - angemeldet: wird beim Klick zum Textfeld (erst einzeilig, wächst mit)
 * - nicht angemeldet: wird beim ersten Klick weiss und bittet ums Anmelden,
 *   der zweite Klick führt zum Login und danach hierher zurück.
 */
@Component({
  selector: 'mampf-comments',
  standalone: true,
  imports: [],
  templateUrl: './comments.component.html',
  styleUrl: './comments.component.scss',
})
export class CommentsComponent implements OnChanges {
  private router = inject(Router);
  @Input() placeId: number | undefined;
  /** Nach dem Login zurück: Textfeld gleich öffnen. */
  @Input() startComposing = false;
  /** Die Liste ist länger oder kürzer geworden (Infobox muss neu messen). */
  @Output() changed = new EventEmitter<void>();

  @ViewChild('textarea') textarea: ElementRef<HTMLTextAreaElement> | undefined;

  readonly maxLength = MAX_LENGTH;

  comments: PlaceComment[] = [];
  loggedIn = false;
  loading = true;
  failed = false;

  /** Knopf ist zum Textfeld geworden. */
  composing = false;
  /** Nicht angemeldet, Knopf einmal geklickt: jetzt weiss mit "Anmelden". */
  askLogin = false;
  text = '';
  sending = false;
  error: string | undefined;

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['placeId']) {
      this.text = '';
      this.error = undefined;
      this.composing = false;
      this.askLogin = false;
      this.load(this.startComposing);
    }
  }

  /** Zeichen zählen wie der Server: 🌮 oder ä zählt als 1. */
  get length(): number {
    return [...this.text.trim()].length;
  }

  get tooLong(): boolean {
    return this.length > MAX_LENGTH;
  }

  get canSend(): boolean {
    return !this.sending && this.length > 0 && !this.tooLong;
  }

  onButtonClicked(event: Event): void {
    event.stopPropagation(); // Infobox nicht zuklappen
    if (this.loggedIn) {
      this.openComposer();
    } else if (!this.askLogin) {
      this.askLogin = true;
    } else if (this.placeId !== undefined) {
      // Nach dem Login (oder der Registrierung) zurück zu diesem Ort
      savePendingComment(this.placeId);
      this.router.navigate(['/anmelden'], { queryParams: { zurueck: 'karte' } });
    }
  }

  onText(event: Event): void {
    const textarea = event.target as HTMLTextAreaElement;
    this.text = textarea.value;
    this.error = undefined;
    this.fitHeight(textarea);
  }

  /** Enter schickt ab, Shift+Enter macht eine neue Zeile. Escape bricht ab. */
  onKeydown(event: KeyboardEvent): void {
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault();
      this.send();
    } else if (event.key === 'Escape') {
      this.cancel();
    }
  }

  cancel(): void {
    this.composing = false;
    this.text = '';
    this.error = undefined;
    setTimeout(() => this.changed.emit());
  }

  send(): void {
    if (!this.canSend || this.placeId === undefined) return;
    this.sending = true;
    this.error = undefined;

    fetch('api/post-comment.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ placeId: this.placeId, text: this.text.trim() }),
    })
      .then(response => {
        if (response.status === 401) {
          this.loggedIn = false;
          this.composing = false;
          throw new Error('Bitte zuerst anmelden.');
        }
        if (response.status === 429) {
          throw new Error('Moment, nicht so schnell – gleich nochmals versuchen.');
        }
        if (!response.ok) throw new Error('Speichern hat nicht geklappt.');
        this.text = '';
        this.composing = false;
        this.load();
      })
      .catch(error => (this.error = error.message))
      .finally(() => (this.sending = false));
  }

  remove(comment: PlaceComment): void {
    if (!confirm('Kommentar löschen?')) return;
    fetch('api/delete-comment.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ id: comment.id }),
    }).then(response => {
      if (response.ok) this.load();
    });
  }

  /** "gerade eben", "vor 5 Min", "vor 3 Std", "gestern", sonst "12.11.2026". */
  when(created: string): string {
    const date = new Date(created);
    const minutes = Math.floor((Date.now() - date.getTime()) / 60000);
    if (minutes < 1) return 'gerade eben';
    if (minutes < 60) return `vor ${minutes} Min`;
    if (minutes < 24 * 60) return `vor ${Math.floor(minutes / 60)} Std`;
    if (minutes < 48 * 60) return 'gestern';
    const pad = (n: number) => String(n).padStart(2, '0');
    return `${pad(date.getDate())}.${pad(date.getMonth() + 1)}.${date.getFullYear()}`;
  }

  private openComposer(): void {
    this.composing = true;
    this.askLogin = false;
    setTimeout(() => {
      const textarea = this.textarea?.nativeElement;
      if (!textarea) return;
      textarea.focus({ preventScroll: true });
      this.changed.emit();
      // Erst nachdem die Infobox gewachsen ist ins Bild holen
      setTimeout(() => textarea.scrollIntoView({ block: 'nearest', behavior: 'smooth' }), 400);
    });
  }

  /** Feld wächst mit dem Text mit (anfangs eine Zeile). */
  private fitHeight(textarea: HTMLTextAreaElement): void {
    const before = textarea.offsetHeight;
    // Kurz auf "auto" messen, dann wieder die alte Höhe setzen, damit die
    // Animation (transition im SCSS) von alt nach neu laufen kann.
    textarea.style.height = 'auto';
    const target = textarea.scrollHeight + 2; // + Rahmen
    textarea.style.height = `${before}px`;
    if (target === before) return;
    void textarea.offsetHeight; // Browser merkt sich die alte Höhe
    textarea.style.height = `${target}px`;
    // Infobox erst nach der Animation neu messen
    setTimeout(() => this.changed.emit(), 160);
  }

  private load(compose = false): void {
    const placeId = this.placeId;
    if (placeId === undefined) return;
    this.loading = true;
    this.failed = false;
    fetch(`api/get-comments.php?place=${placeId}`)
      .then(response => {
        if (!response.ok) throw new Error();
        return response.json() as Promise<CommentList>;
      })
      .then(list => {
        if (placeId !== this.placeId) return; // inzwischen anderer Ort
        this.comments = list.comments;
        this.loggedIn = list.loggedIn;
        if (compose && this.loggedIn) this.openComposer();
      })
      .catch(() => (this.failed = true))
      .finally(() => {
        this.loading = false;
        setTimeout(() => this.changed.emit());
      });
  }
}
