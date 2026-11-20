import { Injectable } from '@angular/core';
import { User } from '../dto/user';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  private user: User | undefined;

  constructor() {}

  fetchUser(callback: (user: User) => void): void {
    fetch('/api/get-own-user.php')
      .then(response => {
        if (response.ok) {
          response.json().then(data => {
            this.user = data;
            callback(data);
          });
        } else if (response.status === 401) {
          window.location.href = '/login/'; // mit / am Ende, sonst fehlen der Login-Seite die Styles
        }
      })
      .catch(error => {
        console.error('Could not fetch user', error);
      });
  }

  getUser(): User {
    if (!this.user) {
      throw new Error('User is not available');
    }
    return this.user;
  }
}
