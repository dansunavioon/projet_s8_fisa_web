<?php
require_once __DIR__ . '/db_connect.php';

header('Content-Type: application/json; charset=utf-8');

// Get tree ID
$tree_id = null;
if (isset($_GET['tree_id'])) {
    $tree_id = (int)$_GET['tree_id'];
} elseif (isset($_POST['tree_id'])) {
    $tree_id = (int)$_POST['tree_id'];
}
if (!$tree_id) {
    http_response_code(400);
    echo json_encode([ 'error' => 'Paramètre tree_id manquant' ]);
    exit;
}

// Build path to python wrapper
$wrapper = realpath(__DIR__ . '/../wrappers/predict_risk.py');
if (!$wrapper || !file_exists($wrapper)) {
    http_response_code(500);
    echo json_encode([ 'error' => 'Wrapper Python introuvable' ]);
    exit;
}

try {
    // Fetch tree and associated names
    $sql = 'SELECT
        t.height_total,
        t.trunk_diam,
        t.age_est,
        ds.name   AS fk_stadedev,
        p.name    AS fk_port,
        f.name    AS fk_pied,
        -- Pour la situation, nous n’avons pas de table dédiée : on utilisera une constante dans l’API
        rev.name  AS fk_revetement,
        t.remarkable,
        feu.name  AS feuillage,
        q.name    AS clc_quartier,
        se.name   AS clc_secteur
    FROM trees t
    LEFT JOIN development_stages ds ON ds.id = t.stage_id
    LEFT JOIN ports p ON p.id = t.port_id
    LEFT JOIN feet f ON f.id = t.foot_id
    LEFT JOIN revetements rev ON rev.id = t.revetement_id
    LEFT JOIN feuillages feu ON feu.id = t.feuillage_id
    LEFT JOIN quartiers q ON q.id = t.quartier_id
    LEFT JOIN secteurs se ON se.id = t.secteur_id
    WHERE t.id = :id';
    $stmt = $pdo->prepare($sql);
    $stmt->execute([ ':id' => $tree_id ]);
    $row = $stmt->fetch();

    if (!$row) {
        http_response_code(404);
        echo json_encode([ 'error' => 'Arbre introuvable' ]);
        exit;
    }

    // Build command-line arguments
    // Préparer les arguments pour le script Python. Les encoders attendent des valeurs
    // spécifiques : les boolean "remarkable" doivent être transformés en 'Oui' ou 'Non'.
    $remarkable = ($row['remarkable'] ? 'Oui' : 'Non');
    // La variable fk_situation n’est pas stockée dans la base : on fournit une constante 'Isole'
    $args = [
        $row['height_total'],
        $row['trunk_diam'],
        $row['age_est'],
        $row['fk_stadedev']   ?? 'missing',
        $row['fk_port']       ?? 'missing',
        $row['fk_pied']       ?? 'missing',
        'Isole',
        $row['fk_revetement'] ?? 'missing',
        $remarkable,
        $row['feuillage']     ?? 'missing',
        $row['clc_quartier']  ?? 'missing',
        $row['clc_secteur']   ?? 'missing'
    ];

    $python = '/var/www/html/projet_s8_fisa4/.venv/bin/python3';
    $cmd = [$python, $wrapper];
    foreach ($args as $arg) {
        $cmd[] = $arg;
    }
    $escaped = array_map('escapeshellarg', $cmd);
    $cmdline = implode(' ', $escaped);
    
    $output = shell_exec($cmdline . " 2>&1");

    if (!$output) {
        throw new Exception("Aucune sortie Python. Commande : " . $cmdline);
    }

    $data = json_decode($output, true);

    if (!$data) {
        throw new Exception("Sortie Python invalide : " . $output . " | Commande : " . $cmdline);
    }




    if (!$data || isset($data['error'])) {
        throw new Exception($data['error'] ?? 'Erreur lors de la prédiction');
    }

    $prediction = (int)$data['prediction'];
    $proba_abattu = $data['proba_abattu'] ?? null;
    // Update tree
    $upd = $pdo->prepare('UPDATE trees SET risk_pred = :pred, risk_proba = :proba WHERE id = :id');
    $upd->execute([
        ':pred'  => $prediction,
        ':proba' => $proba_abattu,
        ':id'    => $tree_id
    ]);

    echo json_encode([
        'success' => true,
        'prediction' => $prediction,
        'proba_abattu' => $proba_abattu,
        'proba_en_place' => $data['proba_en_place'] ?? null
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([ 'error' => $e->getMessage() ]);
}

?>