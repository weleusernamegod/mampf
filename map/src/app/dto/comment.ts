/** Ein Kommentar zu einem Ort (siehe api/get-comments.php). */
export interface PlaceComment {
  id: number;
  /** Selbst gewählter Name (die Mail wird nie angezeigt). */
  author: string;
  text: string;
  /** ISO-Zeit mit Zeitzone, z.B. "2026-11-25T14:03:00+00:00" */
  created: string;
  /** Eigener Kommentar (oder Admin): darf gelöscht werden. */
  deletable: boolean;
}

export interface CommentList {
  loggedIn: boolean;
  maxLength: number;
  comments: PlaceComment[];
}
