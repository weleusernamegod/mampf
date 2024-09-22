<?php
include('config.php');
include('util/db-util.php');
include('util/api-util.php');
include('util/login-util.php');
include('place/place-repository.php');
include('picture/picture-repository.php');

require_once('place/place.php');
require_once('picture/picture.php');

assert_logged_in();

$data = get_post_body_as_json();
$pictureData = _load_picture($data);

if (!_validate_payload($data) || !_validate_picture($pictureData)) {
	http_response_code(400);
	exit();
}

$mysqli = create_db_connection();

// update place
if ($data['id'] === -1) {
	// create new palce
	$place = new Place(-1, $_SESSION['user_id'], NULL, $data['name'], $data['description'], $data['lat'], $data['lng'], $data['openSunday'], $data['openMonday'], $data['openTuesday'], $data['openWednesday'], $data['openThursday'], $data['openFriday'], $data['openSaturday'], $data['openMorning'], $data['openNoon'], $data['openEvening'], $data['openNight'], date("Y-m-d H:i:s"), NULL);
	$place = create_place($place);
} else {
	// update exiting place
	$place = find_place_by_id($data['id']);

	$allowed = $place->userId === $_SESSION['user_id'] || is_admin();
	if (!$place || !$allowed) {
		http_response_code(404);
		exit();
	}

	$place->name = $data['name'];
	$place->description = $data['description'];
	$place->lat = $data['lat'];
	$place->lng = $data['lng'];
	$place->openSunday = $data['openSunday'];
	$place->openMonday = $data['openMonday'];
	$place->openTuesday = $data['openTuesday'];
	$place->openWednesday = $data['openWednesday'];
	$place->openThursday = $data['openThursday'];
	$place->openFriday = $data['openFriday'];
	$place->openSaturday = $data['openSaturday'];
	$place->openMorning = $data['openMorning'];
	$place->openNoon = $data['openNoon'];
	$place->openEvening = $data['openEvening'];
	$place->openNight = $data['openNight'];
	$place->lastUpdateTime = date("Y-m-d H:i:s");
	$place = update_place($place);
}

// update picture
if ($data['updatePicture']) {
	if (!is_null($place->pictureId) && is_null($pictureData)) {
		// delete existing picture
		$pictureIdToDelete = $place->pictureId;

		$place->pictureId = NULL;
		$place = update_place($place);

		delete_picture_by_id($pictureIdToDelete);
	} else if (!is_null($place->pictureId) && !is_null($pictureData)) {
		// update existing picture
		$picture = find_picture_by_id($place->pictureId);

		$imageInfo = getimagesizefromstring($pictureData);

		$picture->data = $pictureData;
		$picture->width = $imageInfo[0];
		$picture->height = $imageInfo[1];
		$picture->type = $imageInfo['mime'];
		$picture = update_picture($picture);
	} else if (is_null($place->pictureId) && !is_null($pictureData)) {
		// create new picture
		$imageInfo = getimagesizefromstring($pictureData);

		$picture = new Picture(-1, $pictureData, $imageInfo['mime'], $imageInfo[0], $imageInfo[1]);
		$picture = create_picture($picture);

		$place->pictureId = $picture->id;
		$place = update_place($place);
	}
}

close_db_connection($mysqli);

function _load_picture($data)
{
	if (!isset($data['pictureData'])) {
		return NULL;
	}

	$base64DataWithHeader = $data['pictureData'];
	$base64Data = explode(',', $base64DataWithHeader, 2)[1];
	return base64_decode($base64Data);
}

function _validate_picture($pictureData)
{
	if (is_null($pictureData)) {
		return TRUE;
	}

	$imageInfo = getimagesizefromstring($pictureData);

	$imageWidth = $imageInfo[0];
	$imageHeight = $imageInfo[1];
	if ($imageWidth != $imageHeight || $imageWidth < 128 || $imageWidth > 512) {
		return FALSE;
	}

	$imageType = $imageInfo['mime'];
	if ($imageType !== "image/jpeg") {
		return FALSE;
	}

	return TRUE;
}

function _validate_payload($data)
{
	if (!isset($data['id']) || !is_numeric($data['id'])) {
		return FALSE;
	}
	if (!isset($data['updatePicture']) || !is_bool($data['updatePicture'])) {
		return FALSE;
	}
	if (!isset($data['name']) || !is_string($data['name']) || strlen($data['name']) < 2 || strlen($data['name']) > 30) {
		return FALSE;
	}
	if (!isset($data['description']) || !is_string($data['description']) || strlen($data['description']) < 2 || strlen($data['description']) > 50) {
		return FALSE;
	}
	if (!isset($data['lat']) || !is_numeric($data['lat'])) {
		return FALSE;
	}
	if (!isset($data['lng']) || !is_numeric($data['lng'])) {
		return FALSE;
	}
	if (!isset($data['openSunday']) || !is_bool($data['openSunday'])) {
		return FALSE;
	}
	if (!isset($data['openMonday']) || !is_bool($data['openMonday'])) {
		return FALSE;
	}
	if (!isset($data['openTuesday']) || !is_bool($data['openTuesday'])) {
		return FALSE;
	}
	if (!isset($data['openWednesday']) || !is_bool($data['openWednesday'])) {
		return FALSE;
	}
	if (!isset($data['openThursday']) || !is_bool($data['openThursday'])) {
		return FALSE;
	}
	if (!isset($data['openFriday']) || !is_bool($data['openFriday'])) {
		return FALSE;
	}
	if (!isset($data['openSaturday']) || !is_bool($data['openSaturday'])) {
		return FALSE;
	}
	if (!isset($data['openMorning']) || !is_bool($data['openMorning'])) {
		return FALSE;
	}
	if (!isset($data['openNoon']) || !is_bool($data['openNoon'])) {
		return FALSE;
	}
	if (!isset($data['openEvening']) || !is_bool($data['openEvening'])) {
		return FALSE;
	}
	if (!isset($data['openNight']) || !is_bool($data['openNight'])) {
		return FALSE;
	}
	return TRUE;
}
?>