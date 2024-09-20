import {
  Component,
  EventEmitter,
  Input,
  OnChanges,
  OnInit,
  Output,
  SimpleChanges,
} from '@angular/core';

@Component({
  selector: 'mampf-picture-input',
  standalone: true,
  imports: [],
  templateUrl: './picture-input.component.html',
  styleUrl: './picture-input.component.scss',
})
export class PictureInputComponent implements OnChanges {
  readonly MAX_SIDE = 512;
  readonly MIN_SIDE = 128;

  @Input() originalPictureId: number | undefined;
  @Output() pictureDeleted = new EventEmitter<void>();
  @Output() pictureUploaded = new EventEmitter<string>();

  imageUrl: string | undefined;

  ngOnChanges(changes: SimpleChanges): void {
    this.imageUrl = this.originalPictureId
      ? `api/get-public-picture.php?id=${this.originalPictureId}`
      : undefined;
  }

  onPictureDeleted() {
    this.imageUrl = undefined;
    this.pictureDeleted.emit();
  }

  onFileSelected(event: Event) {
    const element = event.currentTarget as HTMLInputElement;
    const file = element?.files?.[0];
    if (!file) {
      return;
    }

    if (!file.type.startsWith('image')) {
      return;
    }

    this.resizeImage(file, blob => {
      this.imageUrl = URL.createObjectURL(blob);

      this.blobToBase64(blob, base64Data => {
        this.pictureUploaded.emit(base64Data);
      });
    });
  }

  private resizeImage(imageFile: File, callback: (blob: Blob) => void): void {
    const image = new Image();
    image.onload = () => {
      const sourceSize = Math.min(image.width, image.height);
      if (sourceSize < this.MIN_SIDE) {
        return;
      }
      const sourceX = (image.width - sourceSize) / 2;
      const sourceY = (image.height - sourceSize) / 2;
      const targetSize = Math.min(sourceSize, this.MAX_SIDE);

      const canvas = new OffscreenCanvas(targetSize, targetSize);
      const context = canvas.getContext('2d');
      context?.drawImage(
        image,
        sourceX,
        sourceY,
        sourceSize,
        sourceSize,
        0,
        0,
        targetSize,
        targetSize
      );
      canvas
        .convertToBlob({ type: 'image/jpeg', quality: 0.8 })
        .then(blob => callback(blob));
    };
    image.src = URL.createObjectURL(imageFile);
  }

  private blobToBase64(
    blob: Blob,
    callback: (base64Data: string) => void
  ): void {
    const fileReader = new FileReader();
    fileReader.onloadend = () => {
      callback(fileReader.result as string);
    };
    fileReader.readAsDataURL(blob);
  }
}
