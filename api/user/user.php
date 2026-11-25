<?php
class User
{
    public $id;
    public $mail;
    /** Anzeigename bei Kommentaren (NULL = noch keiner gewählt) */
    public $name;
    public $passwordHash;
    public $admin;
    public $registrationTime;
    public $lastLoginTime;

    public function __construct($id, $mail, $passwordHash, $admin, $registrationTime, $lastLoginTime, $name = NULL)
    {
        $this->id = $id;
        $this->mail = $mail;
        $this->passwordHash = $passwordHash;
        $this->admin = $admin;
        $this->registrationTime = $registrationTime;
        $this->lastLoginTime = $lastLoginTime;
        $this->name = $name;
    }
}

/** Name bereinigen: Leerzeichen am Rand weg, mehrere Leerzeichen zu einem. */
function normalize_user_name($name)
{
    return is_string($name) ? trim(preg_replace('/\s+/u', ' ', $name)) : NULL;
}

/** Anzeigename: 2–30 Zeichen */
function is_valid_user_name($name)
{
    return is_string($name) && mb_strlen($name) >= 2 && mb_strlen($name) <= 30;
}
?>