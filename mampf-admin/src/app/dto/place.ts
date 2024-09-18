export interface Place {
  id: number;
  pictureId: number | undefined;
  name: string;
  description: string;
  lat: number;
  lng: number;
  openSunday: boolean;
  openMonday: boolean;
  openTuesday: boolean;
  openWednesday: boolean;
  openThursday: boolean;
  openFriday: boolean;
  openSaturday: boolean;
  openMorning: boolean;
  openNoon: boolean;
  openEvening: boolean;
  openNight: boolean;
}
