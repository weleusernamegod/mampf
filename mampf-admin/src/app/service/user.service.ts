import { Injectable } from '@angular/core';
import { User } from '../dto/user';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  private user: User | undefined;

  constructor() {}

  fetchUser(callback: (user: User) => void): void {
    fetch('assets/tmp/user.json')
      .then(response => response.json())
      .then(data => {
        if (data) {
          this.user = data;
          callback(data);
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
