import { Routes } from '@angular/router';
import { MyPlacesListComponent } from './component/my-places-list/my-places-list.component';
import { PlaceDetailComponent } from './component/place-detail/place-detail.component';
import { CategoryAdminComponent } from './component/category-admin/category-admin.component';

export const routes: Routes = [
  { path: '', redirectTo: 'my-places', pathMatch: 'full' },
  { path: 'my-places', component: MyPlacesListComponent },
  { path: 'place/new', component: PlaceDetailComponent },
  { path: 'place/:id', component: PlaceDetailComponent },
  { path: 'categories', component: CategoryAdminComponent },
];
