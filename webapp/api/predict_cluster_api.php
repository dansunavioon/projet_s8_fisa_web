<?php
require_once __DIR__ . '/db_connect.php';

header('Content-Type: application/json; charset=utf-8');

// debug ligne : initialiser les logs de debug
$debugLogs = [];

// déterminer le nombre de clusters (2 ou 3)
$nb_clusters = 3;
if (isset($_GET['nb_clusters'])) {
    $nb_clusters = (int)$_GET['nb_clusters'];
} elseif (isset($_POST['nb_clusters'])) {
    $nb_clusters = (int)$_POST['nb_clusters'];
}
// debug ligne : valeur initiale de nb_clusters
$debugLogs[] = 'nb_clusters initial: ' . $nb_clusters;
// si la valeur n’est pas 2 ou 3, on la remet à 3
if (!in_array($nb_clusters, [2, 3])) {
    $nb_clusters = 3;
    // debug ligne : correction de nb_clusters si invalide
    $debugLogs[] = 'nb_clusters reset to 3';
}

// chemin absolu vers le wrapper Python
$wrapper = realpath(__DIR__ . '/../wrappers/predict_cluster.py');
if (!$wrapper || !file_exists($wrapper)) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error'   => 'Wrapper script not found',
        'debug'   => $debugLogs
    ]);
    exit;
}
// debug ligne : chemin du wrapper
$debugLogs[] = 'wrapper path: ' . $wrapper;

// déterminer le binaire Python (préférez le .venv)
$python = '/var/www/html/projet_s8_fisa4/.venv/bin/python3';
if (!file_exists($python)) {
    $python = 'python3';
    $debugLogs[] = 'python venv not found, using system python';
} else {
    $debugLogs[] = 'python path: ' . $python;
}

try {
    // récupérer les arbres ayant des valeurs non nulles
    $stmt = $pdo->query("
        SELECT id, height_total, trunk_diam, age_est, trunk_height
        FROM trees
        WHERE height_total IS NOT NULL
          AND trunk_diam  IS NOT NULL
          AND age_est     IS NOT NULL
          AND trunk_height IS NOT NULL
    ");
    $trees   = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $updates = [];

    foreach ($trees as $tree) {
        $id    = $tree['id'];
        $h_tot = (float)$tree['height_total'];
        $diam  = (float)$tree['trunk_diam'];
        $age   = (float)$tree['age_est'];
        $h_tr  = (float)$tree['trunk_height'];

        // debug ligne : afficher les entrées pour cet arbre
        $debugLogs[] = "tree {$id} inputs: height={$h_tot}, diam={$diam}, age={$age}, trunk_height={$h_tr}";

        // construire la commande à exécuter
        $cmd = [
            $python,
            $wrapper,
            $nb_clusters,
            $h_tot,
            $diam,
            $age,
            $h_tr
        ];
        $escaped = array_map('escapeshellarg', $cmd);
        $cmdline = implode(' ', $escaped);

        // debug ligne : afficher la commande construite
        $debugLogs[] = "tree {$id} cmd: {$cmdline}";

        // exécuter le wrapper
        $output = shell_exec($cmdline);
        // debug ligne : afficher la sortie brute
        $debugLogs[] = "tree {$id} raw output: {$output}";

        // analyser la sortie
        $data = json_decode($output, true);
        if (!$data) {
            $debugLogs[] = "tree {$id} failed to decode JSON";
            $cluster_id = null;
        } else {
            $cluster_id = isset($data['cluster_id']) ? (int)$data['cluster_id'] : null;
            $debugLogs[] = "tree {$id} cluster_id: " . var_export($cluster_id, true);
        }

        // si le cluster est valide (>= 0), mettre à jour la base
        if ($cluster_id !== null && $cluster_id >= 0) {
            $upd = $pdo->prepare('UPDATE trees SET cluster_id = :cluster WHERE id = :id');
            $upd->execute([ ':cluster' => $cluster_id, ':id' => $id ]);
            $updates[] = [ 'id' => $id, 'cluster_id' => $cluster_id ];
        } else {
            // debug ligne : cluster_id non valide
            $debugLogs[] = "tree {$id} cluster_id invalid, no update";
        }
    }

    // debug ligne : total d’arbres mis à jour
    $debugLogs[] = 'total updated: ' . count($updates);

    echo json_encode([
        'success'     => true,
        'nb_clusters' => $nb_clusters,
        'updated'     => $updates,
        'debug'       => $debugLogs
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error'   => $e->getMessage(),
        'debug'   => $debugLogs
    ]);
}
?>