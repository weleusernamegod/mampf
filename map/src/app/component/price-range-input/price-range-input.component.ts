import { Component, EventEmitter, Input, Output } from '@angular/core';
import { PRICE_MAX, PRICE_MIN } from '../../util/price';

/**
 * Preisspanne mit zwei Reglern (unterer und oberer Betrag).
 * Die Spanne zwischen den beiden Reglern ist im Farbton, der Rest grau.
 * min/max = null heisst: Preis unbekannt. Sobald man einen Regler bewegt,
 * gilt der Preis als angegeben.
 * Wird im Admin (Ort erfassen) und im Filter der Karte verwendet.
 */
@Component({
  selector: 'mampf-price-range-input',
  standalone: true,
  templateUrl: './price-range-input.component.html',
  styleUrl: './price-range-input.component.scss',
})
export class PriceRangeInputComponent {
  readonly PRICE_MIN = PRICE_MIN;
  readonly PRICE_MAX = PRICE_MAX;

  @Input() min: number | null = null;
  @Input() max: number | null = null;
  @Output() minChange = new EventEmitter<number | null>();
  @Output() maxChange = new EventEmitter<number | null>();
  /** Admin: "Preis entfernen" bzw. Hinweis darunter zeigen. Im Filter nicht. */
  @Input() clearable = true;

  get isSet(): boolean {
    return this.min !== null && this.max !== null;
  }

  get low(): number {
    return this.min ?? PRICE_MIN;
  }

  get high(): number {
    return this.max ?? PRICE_MAX;
  }

  /** Position auf dem Regler in Prozent. */
  percent(value: number): number {
    return ((value - PRICE_MIN) / (PRICE_MAX - PRICE_MIN)) * 100;
  }

  /** Unterer Betrag, z.B. "15.–", ganz links "10.– oder weniger". */
  get lowText(): string {
    return this.low === PRICE_MIN ? `${PRICE_MIN}.– oder weniger` : `${this.low}.–`;
  }

  /** Oberer Betrag, z.B. "20.–", ganz rechts "30.– oder mehr". */
  get highText(): string {
    return this.high === PRICE_MAX ? `${PRICE_MAX}.– oder mehr` : `${this.high}.–`;
  }

  onLowInput(event: Event) {
    const input = event.target as HTMLInputElement;
    // Unterer Regler darf nicht über den oberen
    const value = Math.min(Number(input.value), this.high);
    input.value = String(value);
    this.emit(value, this.high);
  }

  onHighInput(event: Event) {
    const input = event.target as HTMLInputElement;
    const value = Math.max(Number(input.value), this.low);
    input.value = String(value);
    this.emit(this.low, value);
  }

  clear() {
    this.min = null;
    this.max = null;
    this.minChange.emit(null);
    this.maxChange.emit(null);
  }

  private emit(low: number, high: number) {
    this.min = low;
    this.max = high;
    this.minChange.emit(low);
    this.maxChange.emit(high);
  }
}
