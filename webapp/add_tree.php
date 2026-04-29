<?php
// Page de formulaire pour l’ajout d’un nouvel arbre
require_once __DIR__ . '/api/db_connect.php';

// Charger les valeurs de référence pour les listes déroulantes
function fetchOptions($pdo, $table) {
    $stmt = $pdo->query("SELECT id, name FROM $table ORDER BY id");
    return $stmt->fetchAll();
}

$states      = fetchOptions($pdo, 'states');
$stages      = fetchOptions($pdo, 'development_stages');
$ports       = fetchOptions($pdo, 'ports');
$feet        = fetchOptions($pdo, 'feet');
$revetements = fetchOptions($pdo, 'revetements');
$feuillages  = fetchOptions($pdo, 'feuillages');
$secteurs    = fetchOptions($pdo, 'secteurs');
$quartiers   = fetchOptions($pdo, 'quartiers');
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Ajouter un arbre</title>
    <link rel="stylesheet" href="assets/style.css">
    <script>
    // Fonction pour envoyer les données via fetch
    async function submitForm(event) {
        event.preventDefault();
        const form = document.getElementById('treeForm');
        const data = Object.fromEntries(new FormData(form).entries());
        // Convert checkbox to 1/0
        data.remarkable = form.remarkable.checked ? 1 : 0;
        const response = await fetch('api/add_tree_api.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        const result = await response.json();
        const msg = document.getElementById('message');
        if (result.success) {
            msg.textContent = 'Arbre ajouté avec succès (ID ' + result.id + ')';
            msg.className = 'success';
            form.reset();
        } else {
            msg.textContent = 'Erreur: ' + (result.error || 'inconnue');
            msg.className = 'danger';
        }
    }
    </script>
</head>
<body>
    <header>
        <h1>Ajouter un arbre</h1>
        <nav>
            <ul>
                <li><a href="index.php">Accueil</a></li>
                <li><a href="add_tree.php">Ajouter un arbre</a></li>
                <li><a href="view_trees.php">Visualiser les arbres</a></li>
            </ul>
        </nav>
    </header>
    <main>
        <h2>Nouveau arbre</h2>
        <form id="treeForm" onsubmit="submitForm(event)">
            <label>Espèce
                <input type="text" name="species" required>
            </label>
            <label>Hauteur totale (m)
                <input type="number" name="height_total" step="0.01" required>
            </label>
            <label>Diamètre du tronc (cm)
                <input type="number" name="trunk_diam" step="0.01" required>
            </label>
            <label>Âge estimé (ans)
                <input type="number" name="age_est" step="0.1" required>
            </label>
            <label>Hauteur du tronc (m)
                <input type="number" name="trunk_height" step="0.01" required>
            </label>
            <label>Remarquable
                <input type="checkbox" name="remarkable" value="1">
            </label>
            <label>Latitude
                <input type="number" name="lat" step="0.000001" required>
            </label>
            <label>Longitude
                <input type="number" name="lon" step="0.000001" required>
            </label>
            <label>État
                <select name="state_id" required>
                    <option value="">--Choisir--</option>
                    <?php foreach ($states as $opt) { echo '<option value="' . $opt['id'] . '">' . htmlspecialchars($opt['name']) . '</option>'; } ?>
                </select>
            </label>
            <label>Stade de développement
                <select name="stage_id" required>
                    <option value="">--Choisir--</option>
                    <?php foreach ($stages as $opt) { echo '<option value="' . $opt['id'] . '">' . htmlspecialchars($opt['name']) . '</option>'; } ?>
                </select>
            </label>
            <label>Type de port
                <select name="port_id" required>
                    <option value="">--Choisir--</option>
                    <?php foreach ($ports as $opt) { echo '<option value="' . $opt['id'] . '">' . htmlspecialchars($opt['name']) . '</option>'; } ?>
                </select>
            </label>
            <label>Type de pied
                <select name="foot_id" required>
                    <option value="">--Choisir--</option>
                    <?php foreach ($feet as $opt) { echo '<option value="' . $opt['id'] . '">' . htmlspecialchars($opt['name']) . '</option>'; } ?>
                </select>
            </label>
            <label>Révêtement
                <select name="revetement_id" required>
                    <option value="">--Choisir--</option>
                    <?php foreach ($revetements as $opt) { echo '<option value="' . $opt['id'] . '">' . htmlspecialchars($opt['name']) . '</option>'; } ?>
                </select>
            </label>
            <label>Feuillage
                <select name="feuillage_id" required>
                    <option value="">--Choisir--</option>
                    <?php foreach ($feuillages as $opt) { echo '<option value="' . $opt['id'] . '">' . htmlspecialchars($opt['name']) . '</option>'; } ?>
                </select>
            </label>
            <label>Secteur
                <select name="secteur_id" required>
                    <option value="">--Choisir--</option>
                    <?php foreach ($secteurs as $opt) { echo '<option value="' . $opt['id'] . '">' . htmlspecialchars($opt['name']) . '</option>'; } ?>
                </select>
            </label>
            <label>Quartier
                <select name="quartier_id" required>
                    <option value="">--Choisir--</option>
                    <?php foreach ($quartiers as $opt) { echo '<option value="' . $opt['id'] . '">' . htmlspecialchars($opt['name']) . '</option>'; } ?>
                </select>
            </label>
            <button type="submit">Enregistrer l’arbre</button>
        </form>
        <div id="message"></div>
    </main>
    <footer>
        <p>Projet FISA4 – Big Data / IA / Web</p>
    </footer>
</body>
</html>