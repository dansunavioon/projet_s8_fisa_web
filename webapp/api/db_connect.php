<?php
// Connection parameters for PostgreSQL
// Modify these constants according to your environment

$host = 'localhost';        // Adresse du serveur
$db   = 'arbres';           // Nom de la base de données
$user = 'arbres_p';         // Nom d'utilisateur
$pass = 'a';         // Mot de passe (à adapter)
$port = 5432;

// Data Source Name
$dsn = "pgsql:host=$host;port=$port;dbname=$db";

// Options pour PDO : lever des exceptions et retourner des tableaux associatifs
$options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
];

try {
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (PDOException $e) {
    http_response_code(500);
    header('Content-Type: application/json');
    echo json_encode([ 'error' => 'Connexion à la base impossible: ' . $e->getMessage() ]);
    exit;
}

?>