<?php
function hash_password($password)
{
  return hash("sha256", $password);
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