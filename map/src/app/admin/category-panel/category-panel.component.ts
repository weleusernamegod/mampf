import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { CategoryGroup } from '../../dto/category';
import { fetchOwnUser } from '../own-user';

/** Kategorie, wie sie die Verwaltung sieht (auch ausgeblendete). */
interface Category {
  id: number;
  group: string;
  name: string;
  order: number;
  /** false = ausgeblendet */
  active?: boolean;
}

interface CategoryList {
  groups: CategoryGroup[];
  categories: Category[];
}

/** Eine Zeile in der Liste: Kategorie plus Name, wie er gerade im Feld steht. */
interface Row {
  category: Category;
  editName: string;
}

/**
 * Panel "Kategorien" über der Karte (Adresse /kategorien, nur für Admins):
 * hinzufügen, umbenennen, Reihenfolge ändern, ausblenden. Gelöscht wird nie,
 * damit die Zuordnungen zu den Orten erhalten bleiben.
 * Ersetzt /admin/categories der alten Admin-App.
 */
@Component({
  selector: 'mampf-category-panel',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './category-panel.component.html',
  styleUrl: './category-panel.component.scss',
  host: { class: 'block full-height' },
})
export class CategoryPanelComponent implements OnInit {
  isAdmin = false;
  isLoading = true;
  groups: CategoryGroup[] = [];
  rows = new Map<string, Row[]>();
  /** Eingabefeld "Neue Kategorie" pro Gruppe. */
  newNames: Record<string, string> = {};
  message: { text: string; error: boolean } | undefined;

  constructor(private router: Router) {}

  ngOnInit(): void {
    fetchOwnUser().then(user => {
      this.isAdmin = !!user?.admin;
      if (this.isAdmin) {
        this.load();
      } else {
        this.isLoading = false;
      }
    });
  }

  onBack(): void {
    this.router.navigate(['/meine-orte']);
  }

  rowsOf(group: CategoryGroup): Row[] {
    return this.rows.get(group.key) ?? [];
  }

  isChanged(row: Row): boolean {
    return row.editName.trim() !== row.category.name;
  }

  rename(row: Row) {
    const name = row.editName.trim();
    if (!name || !this.isChanged(row)) return;
    this.save(
      { id: row.category.id, name, active: row.category.active ?? true },
      `"${row.category.name}" heisst jetzt "${name}".`
    );
  }

  toggleActive(row: Row) {
    const active = !(row.category.active ?? true);
    this.save(
      { id: row.category.id, name: row.category.name, active },
      active
        ? `"${row.category.name}" ist wieder sichtbar.`
        : `"${row.category.name}" ist ausgeblendet.`
    );
  }

  add(group: CategoryGroup) {
    const name = (this.newNames[group.key] ?? '').trim();
    if (!name) return;
    this.save(
      { id: -1, group: group.key, name, active: true },
      `"${name}" wurde zu ${group.name} hinzugefügt.`,
      () => (this.newNames[group.key] = '')
    );
  }

  /** Eine Position nach oben (-1) oder unten (+1) schieben. */
  move(group: CategoryGroup, index: number, direction: -1 | 1) {
    const rows = [...this.rowsOf(group)];
    const target = index + direction;
    if (target < 0 || target >= rows.length) return;
    [rows[index], rows[target]] = [rows[target], rows[index]];
    this.rows.set(group.key, rows);

    this.post('/api/post-category-order.php', {
      group: group.key,
      ids: rows.map(row => row.category.id),
    }).then(response => {
      if (!response.ok) {
        this.showMessage('Reihenfolge konnte nicht gespeichert werden.', true);
        this.load();
      }
    });
  }

  private save(body: object, successText: string, onSuccess?: () => void) {
    this.post('/api/post-category.php', body).then(response => {
      if (response.ok) {
        this.showMessage(successText, false);
        onSuccess?.();
        this.load();
      } else if (response.status === 409) {
        this.showMessage('Diesen Namen gibt es in der Gruppe schon.', true);
      } else {
        this.showMessage('Speichern hat nicht geklappt.', true);
      }
    });
  }

  private post(url: string, body: object): Promise<Response> {
    return fetch(url, {
      method: 'post',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
    }).catch(() => new Response(null, { status: 500 }));
  }

  private showMessage(text: string, error: boolean) {
    this.message = { text, error };
  }

  private load() {
    fetch('/api/get-categories.php?all=1')
      .then(response => response.json())
      .then((data: CategoryList) => {
        this.groups = data.groups;
        this.rows = new Map(
          data.groups.map(group => [
            group.key,
            data.categories
              .filter(category => category.group === group.key)
              .sort((a, b) => a.order - b.order)
              .map(category => ({ category, editName: category.name })),
          ])
        );
        this.isLoading = false;
      })
      .catch(error => console.error('Could not fetch categories', error));
  }
}
