import { Component, OnInit } from '@angular/core';
import { RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { PlaceDetailComponent } from './component/place-detail/place-detail.component';
import { MyPlacesListComponent } from './component/my-places-list/my-places-list.component';
import { UserService } from './service/user.service';
import { User } from './dto/user';
import { LoadingSpinnerComponent } from './component/loading-spinner/loading-spinner.component';

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

  constructor(private userService: UserService) {}

  ngOnInit(): void {
    this.userService.fetchUser(user => {
      this.user = user;
    });
  }

  onSignOutClicked(): void {
    window.location.href = '/api/get-logout.php';
  }
}
