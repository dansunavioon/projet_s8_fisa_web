<?php
/*
 * Page de prédiction du risque d’un arbre sélectionné (client 3).
 * L’ID de l’arbre doit être passé en paramètre dans l’URL (tree_id).
 */
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Prédire le risque de déracinement</title>
    <link rel="stylesheet" href="assets/style.css">
    <script src="https://cdn.plot.ly/plotly-2.18.2.min.js"></script>
</head>
<body>
    <header>
        <h1>Prédiction du risque de déracinement</h1>
        <nav>
            <ul>
                <li><a href="index.php">Accueil</a></li>
                <li><a href="add_tree.php">Ajouter un arbre</a></li>
                <li><a href="view_trees.php">Visualiser les arbres</a></li>
            </ul>
        </nav>
    </header>
    <main>
        <div id="result"></div>
    </main>
    <footer>
        <p>Projet FISA4 – Big Data / IA / Web</p>
    </footer>
    <script>
    // Récupère l’ID depuis l’URL
    const params = new URLSearchParams(window.location.search);
    const treeId = params.get('tree_id');
    if (!treeId) {
        document.getElementById('result').textContent = 'Aucun arbre sélectionné.';
    } else {
        fetch('api/predict_risk_api.php?tree_id=' + treeId)
            .then(res => res.json())
            .then(data => {
                const div = document.getElementById('result');
                if (data.success) {
                    const risk = data.prediction == 1 ? '<span class="danger">Élevé</span>' : '<span class="success">Faible</span>';
                    div.innerHTML = '<div class="prediction-result"><p>Résultat : ' + risk + '</p>' +
                        '<p>Probabilité d’être abattu : ' + data.proba_abattu + '</p>' +
                        '<p>Probabilité d’être en place : ' + data.proba_en_place + '</p></div>';
                } else {
                    div.textContent = 'Erreur: ' + data.error;
                }
            })
            .catch(err => {
                document.getElementById('result').textContent = 'Erreur: ' + err;
            });
    }
    </script>
</body>
</html>