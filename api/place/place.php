<?php
class Place
{
    public $id;
    public $userId;
    /** Altes Bild in tbl_picture (wird abgelöst durch pictureFile) */
    public $pictureId;
    /** Bilddatei in /bilder/orte/ auf dem Webserver, NULL = keine */
    public $pictureFile = NULL;
    public $name;
    public $description;
    public $lat;
    public $lng;
    /** Öffnungszeiten: Liste von ['weekday' => 0–6, 'slot' => 'morning'|'noon'|'evening'] */
    public $opening;
    /** Standorte pro Wochentag (nur bei "Mehrere Standorte", sonst leer):
     *  Liste von ['weekday' => 0–6, 'lat' => …, 'lng' => …, 'label' => string|null] */
    public $locations;
    /** Preisspanne in CHF (ganze Franken, 10–30; 10 = oder weniger, 30 = oder mehr), NULL = unbekannt */
    public $priceMin;
    public $priceMax;
    /** IDs der (sichtbaren) Kategorien */
    public $categories;
    public $createTime;
    public $lastUpdateTime;

    public function __construct($id, $userId, $pictureId, $name, $description, $lat, $lng, $createTime, $lastUpdateTime, $opening = [], $locations = [], $categories = [], $priceMin = NULL, $priceMax = NULL)
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
        $this->categories = $categories;
        $this->priceMin = $priceMin;
        $this->priceMax = $priceMax;
    }
}
?>