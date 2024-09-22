<?php
class Picture
{
    public $id;
    public $data;
    public $type;
    public $width;
    public $height;

    public function __construct($id, $data, $type, $width, $height)
    {
        $this->id = $id;
        $this->data = $data;
        $this->type = $type;
        $this->width = $width;
        $this->height = $height;
    }
}
?>