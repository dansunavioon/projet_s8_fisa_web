<?php
require_once __DIR__ . '/db_connect.php';

header('Content-Type: application/json; charset=utf-8');

try {
    // Query reference tables
    $tables = [
        'states',
        'development_stages',
        'ports',
        'feet',
        'revetements',
        'feuillages',
        'secteurs',
        'quartiers'
    ];

    $result = [];

    foreach ($tables as $table) {
        $stmt = $pdo->query("SELECT id, name FROM $table ORDER BY id");
        $rows = $stmt->fetchAll();
        $result[$table] = $rows;
    }

    echo json_encode($result);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([ 'error' => $e->getMessage() ]);
}
?>