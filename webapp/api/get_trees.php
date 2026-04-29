<?php
require_once __DIR__ . '/db_connect.php';

header('Content-Type: application/json; charset=utf-8');

try {
    $sql = "SELECT
        t.id,
        t.species,
        t.height_total,
        t.trunk_diam,
        t.age_est,
        t.trunk_height,
        t.remarkable,
        t.lat,
        t.lon,
        s.name AS state,
        ds.name AS stage,
        p.name AS port,
        f.name AS foot,
        r.name AS revetement,
        fe.name AS feuillage,
        q.name AS quartier,
        se.name AS secteur,
        t.cluster_id,
        t.risk_pred,
        t.risk_proba
    FROM trees t
    LEFT JOIN states s ON t.state_id = s.id
    LEFT JOIN development_stages ds ON t.stage_id = ds.id
    LEFT JOIN ports p ON t.port_id = p.id
    LEFT JOIN feet f ON t.foot_id = f.id
    LEFT JOIN revetements r ON t.revetement_id = r.id
    LEFT JOIN feuillages fe ON t.feuillage_id = fe.id
    LEFT JOIN quartiers q ON t.quartier_id = q.id
    LEFT JOIN secteurs se ON t.secteur_id = se.id
    ORDER BY t.id";

    $stmt = $pdo->query($sql);
    $rows = $stmt->fetchAll();
    echo json_encode($rows);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([ 'error' => $e->getMessage() ]);
}
?>