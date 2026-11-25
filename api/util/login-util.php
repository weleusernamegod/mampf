<?php
function hash_password($password)
{
  return hash("sha256", $password);
}

function is_admin()
{
  return $_SESSION['admin'];
}

/**
 * Vorübergehend: Dürfen alle angemeldeten Benutzer alle Orte bearbeiten?
 * true  = ja, jeder Ort kann von allen bearbeitet werden (nicht löschen).
 * false = normal: nur eigene Orte, Admins alle.
 */
const ALLE_DUERFEN_ALLES_BEARBEITEN = true;

/** Darf der angemeldete Benutzer diesen Ort bearbeiten? (Session muss offen sein) */
function can_edit_place($place)
{
  return $place && ($place->userId === $_SESSION['user_id'] || is_admin() || ALLE_DUERFEN_ALLES_BEARBEITEN);
}

function assert_logged_in()
{
  session_start();
  if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    exit;
  }
}
?>