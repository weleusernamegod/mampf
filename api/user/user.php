<?php
  class User {
    public $id;
    public $mail;
    public $passwordHash;
    public $admin;
    public $registrationTime;
    public $lastLoginTime;

    public function __construct($id, $mail, $passwordHash, $admin, $registrationTime, $lastLoginTime)
    {
        $this->id = $id;
        $this->mail = $mail;
        $this->passwordHash = $passwordHash;
        $this->admin = $admin;
        $this->registrationTime = $registrationTime;
        $this->lastLoginTime = $lastLoginTime;
    }
  }
?>