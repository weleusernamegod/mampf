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
    /** Öffnungszeiten: Liste von ['weekday' => 0–6, 'slot' => 'morning'|'noon'|'evening'] */
    public $opening;
    /** Standorte pro Wochentag (nur bei "Mehrere Standorte", sonst leer):
     *  Liste von ['weekday' => 0–6, 'lat' => …, 'lng' => …, 'label' => string|null] */
    public $locations;
    public $createTime;
    public $lastUpdateTime;

    public function __construct($id, $userId, $pictureId, $name, $description, $lat, $lng, $createTime, $lastUpdateTime, $opening = [], $locations = [])
    {
        $this->id = $id;
        $this->userId = $userId;
        $this->pictureId = $pictureId;
        $this->name = $name;
        $this->description = $description;
        $this->lat = $lat;
        $this->lng = $lng;
        $this->createTime = $createTime;
        $this->lastUpdateTime = $lastUpdateTime;
        $this->opening = $opening;
        $this->locations = $locations;
    }
}
?>