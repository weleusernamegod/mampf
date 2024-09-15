import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { MyPlacesDetailComponent } from "./component/my-places-detail/my-places-detail.component";
import { MyPlacesListComponent } from "./component/my-places-list/my-places-list.component";

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, MyPlacesDetailComponent, MyPlacesListComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent {}
