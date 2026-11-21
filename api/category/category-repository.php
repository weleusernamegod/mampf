<?php
/**
 * Kategorien (tbl_category) und ihre Zuordnung zu Orten (tbl_place_category).
 */

/**
 * Die Gruppen in der Reihenfolge, wie sie im Filter und im Admin erscheinen.
 * single = genau eine Auswahl pro Ort (sonst mehrere).
 */
function category_groups()
{
    return [
        ['key' => 'art', 'name' => 'Art des Lokals', 'single' => TRUE],
        ['key' => 'kueche', 'name' => 'Küche', 'single' => FALSE],
        ['key' => 'gericht', 'name' => 'Gerichte', 'single' => FALSE],
        ['key' => 'praeferenz', 'name' => 'Präferenzen', 'single' => FALSE],
        ['key' => 'wartezeit', 'name' => 'Wartezeit', 'single' => TRUE],
    ];
}

function category_group_keys()
{
    return array_column(category_groups(), 'key');
}

function single_category_group_keys()
{
    return array_column(array_filter(category_groups(), fn($group) => $group['single']), 'key');
}

/** Alle Kategorien, sortiert. $only_active = ausgeblendete weglassen. */
function find_categories($only_active)
{
    global $mysqli;

    $where = $only_active ? 'WHERE aktiv = 1' : '';
    $result = $mysqli->query("SELECT id, gruppe, name, reihenfolge, aktiv FROM tbl_category $where ORDER BY gruppe, reihenfolge, name");

    $categories = array();
    while ($row = $result->fetch_assoc()) {
        $categories[] = _map_row_to_category($row);
    }
    return $categories;
}

function find_category_by_id($id)
{
    global $mysqli;

    $statement = $mysqli->prepare("SELECT id, gruppe, name, reihenfolge, aktiv FROM tbl_category WHERE id = ? LIMIT 1");
    $statement->bind_param("i", $id);
    $statement->execute();
    $row = $statement->get_result()->fetch_assoc();
    $statement->close();

    return $row ? _map_row_to_category($row) : NULL;
}

/** Neue Kategorie kommt ans Ende ihrer Gruppe. */
function create_category($group, $name, $active)
{
    global $mysqli;

    $statement = $mysqli->prepare("SELECT COALESCE(MAX(reihenfolge), 0) + 10 AS next FROM tbl_category WHERE gruppe = ?");
    $statement->bind_param("s", $group);
    $statement->execute();
    $order = intval($statement->get_result()->fetch_assoc()['next']);
    $statement->close();

    $activeInt = $active ? 1 : 0;
    $statement = $mysqli->prepare("INSERT INTO tbl_category (gruppe, name, reihenfolge, aktiv) VALUES (?, ?, ?, ?)");
    $statement->bind_param("ssii", $group, $name, $order, $activeInt);
    $statement->execute();
    $statement->close();

    return find_category_by_id($mysqli->insert_id);
}

/** Gibt es den Namen in der Gruppe schon (Gross-/Kleinschreibung egal)? */
function category_name_taken($group, $name, $exclude_id)
{
    global $mysqli;

    $statement = $mysqli->prepare("SELECT 1 FROM tbl_category WHERE gruppe = ? AND name = ? AND id <> ? LIMIT 1");
    $statement->bind_param("ssi", $group, $name, $exclude_id);
    $statement->execute();
    $taken = $statement->get_result()->fetch_assoc() !== NULL;
    $statement->close();
    return $taken;
}

/** Umbenennen und ein-/ausblenden (die Gruppe bleibt). */
function update_category($id, $name, $active)
{
    global $mysqli;

    $activeInt = $active ? 1 : 0;
    $statement = $mysqli->prepare("UPDATE tbl_category SET name = ?, aktiv = ? WHERE id = ?");
    $statement->bind_param("sii", $name, $activeInt, $id);
    $statement->execute();
    $statement->close();

    return find_category_by_id($id);
}

/** Reihenfolge innerhalb einer Gruppe: $ids in der gewünschten Reihenfolge. */
function update_category_order($group, $ids)
{
    global $mysqli;

    $statement = $mysqli->prepare("UPDATE tbl_category SET reihenfolge = ? WHERE id = ? AND gruppe = ?");
    foreach ($ids as $index => $id) {
        $order = ($index + 1) * 10;
        $statement->bind_param("iis", $order, $id, $group);
        $statement->execute();
    }
    $statement->close();
}

/** Kategorie-IDs pro Ort (nur sichtbare Kategorien): [place_id => [id, id, …]] */
function find_active_category_ids_by_place_ids($place_ids)
{
    global $mysqli;

    $byPlace = array();
    if (count($place_ids) === 0) {
        return $byPlace;
    }
    $ids = implode(',', array_map('intval', $place_ids));
    $result = $mysqli->query("SELECT pc.place_id, pc.category_id FROM tbl_place_category pc JOIN tbl_category c ON c.id = pc.category_id WHERE c.aktiv = 1 AND pc.place_id IN ($ids) ORDER BY c.gruppe, c.reihenfolge");
    while ($row = $result->fetch_assoc()) {
        $byPlace[intval($row['place_id'])][] = intval($row['category_id']);
    }
    return $byPlace;
}

/**
 * Kategorien eines Ortes ersetzen. Zuordnungen zu ausgeblendeten Kategorien
 * bleiben erhalten (der Admin sieht sie nicht und kann sie darum nicht
 * abwählen). Kommen sie später zurück, sind sie wieder da.
 */
function save_place_categories($place_id, $category_ids)
{
    global $mysqli;

    $statement = $mysqli->prepare("DELETE pc FROM tbl_place_category pc JOIN tbl_category c ON c.id = pc.category_id WHERE pc.place_id = ? AND c.aktiv = 1");
    $statement->bind_param("i", $place_id);
    $statement->execute();
    $statement->close();

    $statement = $mysqli->prepare("INSERT IGNORE INTO tbl_place_category (place_id, category_id) VALUES (?, ?)");
    foreach ($category_ids as $category_id) {
        $statement->bind_param("ii", $place_id, $category_id);
        $statement->execute();
    }
    $statement->close();
}

/**
 * Prüft eine Auswahl für einen Ort: Alle IDs gibt es und sind sichtbar,
 * und aus Gruppen mit "genau einer Auswahl" ist höchstens eine dabei.
 */
function validate_place_categories($category_ids)
{
    if (count($category_ids) === 0) {
        return TRUE;
    }
    $active = array();
    foreach (find_categories(TRUE) as $category) {
        $active[$category['id']] = $category;
    }
    $perGroup = array();
    foreach ($category_ids as $id) {
        if (!isset($active[$id])) {
            return FALSE;
        }
        $group = $active[$id]['group'];
        $perGroup[$group] = ($perGroup[$group] ?? 0) + 1;
    }
    foreach (single_category_group_keys() as $group) {
        if (($perGroup[$group] ?? 0) > 1) {
            return FALSE;
        }
    }
    return TRUE;
}

function _map_row_to_category($row)
{
    return [
        'id' => intval($row['id']),
        'group' => $row['gruppe'],
        'name' => $row['name'],
        'order' => intval($row['reihenfolge']),
        'active' => boolval($row['aktiv'])
    ];
}
?>
