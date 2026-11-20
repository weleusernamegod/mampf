import { Component, OnInit } from '@angular/core';
import {
  Router,
  RouterLink,
  RouterLinkActive,
  RouterOutlet,
} from '@angular/router';
import { PlaceDetailComponent } from './component/place-detail/place-detail.component';
import { MyPlacesListComponent } from './component/my-places-list/my-places-list.component';
import { UserService } from './service/user.service';
import { User } from './dto/user';
import { LoadingSpinnerComponent } from './component/loading-spinner/loading-spinner.component';
import { hasPendingPosition } from './util/pending-position';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    RouterOutlet,
    RouterLink,
    RouterLinkActive,
    PlaceDetailComponent,
    MyPlacesListComponent,
    LoadingSpinnerComponent,
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent implements OnInit {
  user: User | undefined = undefined;

  constructor(
    private userService: UserService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.userService.fetchUser(user => {
      this.user = user;

      // Nach dem Login landet man auf der Startseite des Admin-Bereichs.
      // Wurde vorher auf der Karte ein Ort platziert: direkt zum Formular.
      const path = window.location.pathname.replace(/\/+$/, '');
      const onStartPage = path.endsWith('/admin') || path.endsWith('/my-places');
      if (hasPendingPosition() && onStartPage) {
        this.router.navigate(['/place/new']);
      }
    });
  }

  onSignOutClicked(): void {
    window.location.href = '/api/get-logout.php';
  }
}
