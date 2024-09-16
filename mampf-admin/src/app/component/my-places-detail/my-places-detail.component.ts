import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';

@Component({
  selector: 'mampf-my-places-detail',
  standalone: true,
  imports: [],
  templateUrl: './my-places-detail.component.html',
  styleUrl: './my-places-detail.component.scss',
})
export class MyPlacesDetailComponent implements OnInit {
  constructor(private route: ActivatedRoute) {}

  ngOnInit(): void {
    this.route.params.subscribe((params: Params) => {
      console.log(params);
    });
  }
}
