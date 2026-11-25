import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { UserService } from '../../service/user.service';

/** Aus /assets/random-name.js (in index.html geladen), z.B. "Knusprige Bratwurst". */
declare function mampfRandomName(): string;

/** Eigenes Profil: Anzeigename ändern (erscheint bei den Kommentaren). */
@Component({
  selector: 'mampf-profile',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './profile.component.html',
  styleUrl: './profile.component.scss',
})
export class ProfileComponent implements OnInit {
  mail = '';
  name = '';
  savedName = '';
  saving = false;
  message: { text: string; error: boolean } | undefined;

  constructor(private userService: UserService) {}

  ngOnInit(): void {
    const user = this.userService.getUser();
    this.mail = user.mail;
    this.name = user.name ?? '';
    this.savedName = this.name;
  }

  get changed(): boolean {
    return this.name.trim() !== this.savedName;
  }

  onRandomName(): void {
    this.name = mampfRandomName();
    this.message = undefined;
  }

  onSave(): void {
    const name = this.name.trim().replace(/\s+/g, ' ');
    if (name.length < 2 || name.length > 30) {
      this.message = { text: 'Der Name braucht 2 bis 30 Zeichen.', error: true };
      return;
    }
    this.saving = true;
    fetch('/api/post-own-user.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name }),
    })
      .then(response => {
        if (!response.ok) throw new Error();
        this.name = name;
        this.savedName = name;
        this.userService.getUser().name = name;
        this.message = { text: 'Gespeichert.', error: false };
      })
      .catch(() => (this.message = { text: 'Speichern hat nicht geklappt.', error: true }))
      .finally(() => (this.saving = false));
  }
}
