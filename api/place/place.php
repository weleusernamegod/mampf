<?php
class Place
{
    public $id;
    public $userId;
    public $pictureId;
    public $name;
    public $description;
    public $lat;
    public $lng;
    public $openSunday;
    public $openMonday;
    public $openTuesday;
    public $openWednesday;
    public $openThursday;
    public $openFriday;
    public $openSaturday;
    public $openMorning;
    public $openNoon;
    public $openEvening;
    public $openNight;
    public $createTime;
    public $lastUpdateTime;

    public function __construct($id, $userId, $pictureId, $name, $description, $lat, $lng, $openSunday, $openMonday, $openTuesday, $openWednesday, $openThursday, $openFriday, $openSaturday, $openMorning, $openNoon, $openEvening, $openNight, $createTime, $lastUpdateTime)
    {
        $this->id = $id;
        $this->userId = $userId;
		$this->pictureId = $pictureId;
        $this->name = $name;
        $this->description = $description;
        $this->lat = $lat;
        $this->lng = $lng;
        $this->openSunday = $openSunday;
        $this->openMonday = $openMonday;
        $this->openTuesday = $openTuesday;
        $this->openWednesday = $openWednesday;
        $this->openThursday = $openThursday;
        $this->openFriday = $openFriday;
        $this->openSaturday = $openSaturday;
        $this->openMorning = $openMorning;
        $this->openNoon = $openNoon;
        $this->openEvening = $openEvening;
        $this->openNight = $openNight;
        $this->createTime = $createTime;
        $this->lastUpdateTime = $lastUpdateTime;
    }
}
?>