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

$opening = _normalize_opening($data['opening']);
$locations = _normalize_locations($data['locations']);

$categoryIds = array_values(array_unique($data['categories']));

$mysqli = create_db_connection();

if (!validate_place_categories($categoryIds)) {
	http_response_code(400);
	exit();
}

$mysqli->begin_transaction();

// update place
if ($data['id'] === -1) {
	// create new palce
	$place = new Place(-1, $_SESSION['user_id'], NULL, $data['name'], $data['description'], $data['lat'], $data['lng'], date("Y-m-d H:i:s"), NULL);
	$place->priceMin = $data['priceMin'] ?? NULL;
	$place->priceMax = $data['priceMax'] ?? NULL;
	$place = create_place($place);
} else {
	// update exiting place
	$place = find_place_by_id($data['id']);

	$allowed = $place && ($place->userId === $_SESSION['user_id'] || is_admin());
	if (!$allowed) {
		$mysqli->rollback();
		http_response_code(404);
		exit();
	}

	$place->name = $data['name'];
	$place->description = $data['description'];
	$place->lat = $data['lat'];
	$place->lng = $data['lng'];
	$place->priceMin = $data['priceMin'] ?? NULL;
	$place->priceMax = $data['priceMax'] ?? NULL;
	$place->lastUpdateTime = date("Y-m-d H:i:s");
	$place = update_place($place);
}

// Öffnungszeiten und Standorte
$place->opening = $opening;
$place->locations = $locations;
save_place_schedule($place);
save_place_categories($place->id, $categoryIds);

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

$mysqli->commit();
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
	if (!_validate_price($data['priceMin'] ?? NULL, $data['priceMax'] ?? NULL)) {
		return FALSE;
	}
	if (!isset($data['opening']) || !_validate_opening($data['opening'])) {
		return FALSE;
	}
	if (!isset($data['locations']) || !_validate_locations($data['locations'])) {
		return FALSE;
	}
	if (!isset($data['categories']) || !_is_list($data['categories']) || count($data['categories']) > 150) {
		return FALSE;
	}
	foreach ($data['categories'] as $categoryId) {
		if (!is_int($categoryId)) {
			return FALSE;
		}
	}
	return TRUE;
}

/** Preisspanne in CHF: beide leer, oder ganze Zahlen 10–30 mit min <= max */
function _validate_price($min, $max)
{
	if (is_null($min) && is_null($max)) {
		return TRUE;
	}
	return is_int($min) && is_int($max) && $min >= 10 && $max <= 30 && $min <= $max;
}

/** Einfache Liste [a, b, c] (kein Objekt mit eigenen Schlüsseln) */
function _is_list($value)
{
	return is_array($value) && array_keys($value) === range(0, count($value) - 1) || $value === [];
}

function _is_weekday($value)
{
	return is_int($value) && $value >= 0 && $value <= 6;
}

/** Öffnungszeiten: Liste von {weekday: 0–6, slot: "morning"|"noon"|"evening"} */
function _validate_opening($opening)
{
	if (!is_array($opening) || !_is_list($opening) || count($opening) > 21) {
		return FALSE;
	}
	foreach ($opening as $entry) {
		if (!is_array($entry) || !isset($entry['weekday'], $entry['slot'])) {
			return FALSE;
		}
		if (!_is_weekday($entry['weekday']) || !in_array($entry['slot'], ['morning', 'noon', 'evening'], TRUE)) {
			return FALSE;
		}
	}
	return TRUE;
}

/** Standorte: Liste von {weekday: 0–6, lat, lng, label: string|null}, höchstens 14 */
function _validate_locations($locations)
{
	if (!is_array($locations) || !_is_list($locations) || count($locations) > 14) {
		return FALSE;
	}
	foreach ($locations as $entry) {
		if (!is_array($entry) || !isset($entry['weekday'], $entry['lat'], $entry['lng'])) {
			return FALSE;
		}
		if (!_is_weekday($entry['weekday']) || !is_numeric($entry['lat']) || !is_numeric($entry['lng'])) {
			return FALSE;
		}
		$label = $entry['label'] ?? NULL;
		if (!is_null($label) && (!is_string($label) || mb_strlen($label) > 50)) {
			return FALSE;
		}
	}
	return TRUE;
}

/** Doppelte Kreuze entfernen */
function _normalize_opening($opening)
{
	$unique = array();
	foreach ($opening as $entry) {
		$unique[$entry['weekday'] . '-' . $entry['slot']] = ['weekday' => $entry['weekday'], 'slot' => $entry['slot']];
	}
	return array_values($unique);
}

/** Leere Bezeichnung = keine Bezeichnung */
function _normalize_locations($locations)
{
	return array_map(function ($entry) {
		$label = trim($entry['label'] ?? '');
		return [
			'weekday' => $entry['weekday'],
			'lat' => floatval($entry['lat']),
			'lng' => floatval($entry['lng']),
			'label' => $label === '' ? NULL : $label
		];
	}, $locations);
}
?>