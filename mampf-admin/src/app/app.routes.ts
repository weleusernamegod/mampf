import { Routes } from '@angular/router';
import { MyPlacesListComponent } from './component/my-places-list/my-places-list.component';
import { MyPlacesDetailComponent } from './component/my-places-detail/my-places-detail.component';

export const routes: Routes = [
    { path: '/', redirectTo: '/my-places' },
    { path: 'my-places', component: MyPlacesListComponent },
    { path: 'my-places/detail', component: MyPlacesDetailComponent },
];
