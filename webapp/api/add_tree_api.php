<?php
require_once __DIR__ . '/db_connect.php';

header('Content-Type: application/json; charset=utf-8');

// Accept only POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([ 'error' => 'Méthode non autorisée' ]);
    exit;
}

// Retrieve POST data safely
$data = json_decode(file_get_contents('php://input'), true);
if (!$data) {
    // Fallback to form encoded data
    $data = $_POST;
}

// Define required fields
$required = [
    'species','height_total','trunk_diam','age_est','trunk_height',
    'remarkable','lat','lon','state_id','stage_id','port_id','foot_id',
    'revetement_id','feuillage_id','quartier_id','secteur_id'
];

foreach ($required as $field) {
    if (!isset($data[$field]) || $data[$field] === '') {
        http_response_code(400);
        echo json_encode([ 'error' => "Champ manquant : $field" ]);
        exit;
    }
}

try {
    $stmt = $pdo->prepare(
        'INSERT INTO trees (
            species, height_total, trunk_diam, age_est, trunk_height,
            remarkable, lat, lon, state_id, stage_id, port_id, foot_id,
            revetement_id, feuillage_id, quartier_id, secteur_id
        ) VALUES (
            :species, :height_total, :trunk_diam, :age_est, :trunk_height,
            :remarkable, :lat, :lon, :state_id, :stage_id, :port_id, :foot_id,
            :revetement_id, :feuillage_id, :quartier_id, :secteur_id
        )'
    );

    // Cast booleans and numbers properly
    $params = [
        ':species'      => $data['species'],
        ':height_total' => (float)$data['height_total'],
        ':trunk_diam'   => (float)$data['trunk_diam'],
        ':age_est'      => (float)$data['age_est'],
        ':trunk_height' => (float)$data['trunk_height'],
        ':remarkable'   => filter_var($data['remarkable'], FILTER_VALIDATE_BOOLEAN),
        ':lat'          => (float)$data['lat'],
        ':lon'          => (float)$data['lon'],
        ':state_id'     => (int)$data['state_id'],
        ':stage_id'     => (int)$data['stage_id'],
        ':port_id'      => (int)$data['port_id'],
        ':foot_id'      => (int)$data['foot_id'],
        ':revetement_id'=> (int)$data['revetement_id'],
        ':feuillage_id' => (int)$data['feuillage_id'],
        ':quartier_id'  => (int)$data['quartier_id'],
        ':secteur_id'   => (int)$data['secteur_id'],
    ];

    $stmt->execute($params);
    echo json_encode([ 'success' => true, 'id' => $pdo->lastInsertId() ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([ 'error' => $e->getMessage() ]);
}

?>