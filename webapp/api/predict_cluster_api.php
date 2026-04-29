<?php
require_once __DIR__ . '/db_connect.php';

header('Content-Type: application/json; charset=utf-8');

// Only GET or POST allowed
$nb_clusters = 3;
if (isset($_GET['nb_clusters'])) {
    $nb_clusters = (int)$_GET['nb_clusters'];
} elseif (isset($_POST['nb_clusters'])) {
    $nb_clusters = (int)$_POST['nb_clusters'];
}

// Build path to python wrapper
$wrapper = realpath(__DIR__ . '/../wrappers/predict_cluster.py');
if (!$wrapper || !file_exists($wrapper)) {
    http_response_code(500);
    echo json_encode([ 'error' => 'Wrapper script not found' ]);
    exit;
}

try {
    // Fetch trees from DB
    $stmt = $pdo->query('SELECT id, height_total, trunk_diam, age_est, trunk_height FROM trees');
    $trees = $stmt->fetchAll();
    $updates = [];

    foreach ($trees as $tree) {
        $id          = $tree['id'];
        $height      = (float)$tree['height_total'];
        $diam        = (float)$tree['trunk_diam'];
        $age         = (float)$tree['age_est'];
        $trunk_height= (float)$tree['trunk_height'];

        // Build command
        $cmd = [
            'python3',
            $wrapper,
            $nb_clusters,
            $height,
            $diam,
            $age,
            $trunk_height
        ];
        // Escape all arguments
        $escaped = array_map('escapeshellarg', $cmd);
        $cmdline = implode(' ', $escaped);

        $output = shell_exec($cmdline);
        $data   = json_decode($output, true);
        $cluster_id = isset($data['cluster_id']) ? (int)$data['cluster_id'] : null;

        if ($cluster_id !== null && $cluster_id >= 0) {
            // Update DB
            $updates[] = [ 'id' => $id, 'cluster_id' => $cluster_id ];
            $upd = $pdo->prepare('UPDATE trees SET cluster_id = :cluster_id WHERE id = :id');
            $upd->execute([ ':cluster_id' => $cluster_id, ':id' => $id ]);
        }
    }
    echo json_encode([ 'success' => true, 'updated' => $updates ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([ 'error' => $e->getMessage() ]);
}
?>