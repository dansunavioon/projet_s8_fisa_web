<?php
/*
 * Page de prédiction des clusters – client 1.
 * Elle appelle automatiquement l’API de clustering puis affiche la
 * liste des arbres avec la couleur de leur cluster.
 */
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Prédire les clusters</title>
    <link rel="stylesheet" href="assets/style.css">
    <script src="https://cdn.plot.ly/plotly-2.18.2.min.js"></script>
</head>
<body>
    <header>
        <h1>Prédiction des clusters</h1>
        <nav>
            <ul>
                <li><a href="index.php">Accueil</a></li>
                <li><a href="add_tree.php">Ajouter un arbre</a></li>
                <li><a href="view_trees.php">Visualiser les arbres</a></li>
            </ul>
        </nav>
    </header>
    <main>
        <p>Calcul des clusters en cours…</p>
        <div id="content"></div>
    </main>
    <footer>
        <p>Projet FISA4 – Big Data / IA / Web</p>
    </footer>
    <script>
    // On appelle l’API de prédiction puis on recharge les données
    async function predictClusters() {
        await fetch('api/predict_cluster_api.php?nb_clusters=3');
        // Récupérer les nouvelles données
        const res = await fetch('api/get_trees.php');
        const data = await res.json();
        // Construire un tableau et une carte similaires à view_trees
        let html = '<table><thead><tr>';
        const cols = ['ID','Espèce','Hauteur','Diamètre','Âge','Remarquable','État','Stade','Port','Pied','Révêtement','Feuillage','Quartier','Secteur','Cluster'];
        cols.forEach(c => html += '<th>' + c + '</th>');
        html += '</tr></thead><tbody>';
        data.forEach(tree => {
            html += '<tr>';
            html += '<td>' + tree.id + '</td>';
            html += '<td>' + tree.species + '</td>';
            html += '<td>' + tree.height_total + '</td>';
            html += '<td>' + tree.trunk_diam + '</td>';
            html += '<td>' + tree.age_est + '</td>';
            html += '<td>' + tree.remarkable + '</td>';
            html += '<td>' + tree.state + '</td>';
            html += '<td>' + tree.stage + '</td>';
            html += '<td>' + tree.port + '</td>';
            html += '<td>' + tree.foot + '</td>';
            html += '<td>' + tree.revetement + '</td>';
            html += '<td>' + tree.feuillage + '</td>';
            html += '<td>' + tree.quartier + '</td>';
            html += '<td>' + tree.secteur + '</td>';
            html += '<td>' + tree.cluster_id + '</td>';
            html += '</tr>';
        });
        html += '</tbody></table>';
        document.getElementById('content').innerHTML = html;
        // Créer la carte
        const lat = [];
        const lon = [];
        const texts = [];
        const colors = [];
        data.forEach(tree => {
            lat.push(tree.lat);
            lon.push(tree.lon);
            texts.push('ID ' + tree.id + ' - ' + tree.species);
            const palette = ['red','green','orange','purple','brown','grey'];
            colors.push(palette[tree.cluster_id % palette.length]);
        });
        const trace = {
            type: 'scattermapbox',
            lat: lat,
            lon: lon,
            mode: 'markers',
            marker: { color: colors, size: 8 },
            text: texts
        };
        const layout = {
            mapbox: { style: 'open-street-map', center: { lon: 3.2873, lat: 49.8445 }, zoom: 12 },
            margin: { t:0,b:0,l:0,r:0 }
        };
        const mapDiv = document.createElement('div');
        mapDiv.style.height = '500px';
        document.getElementById('content').appendChild(mapDiv);
        Plotly.newPlot(mapDiv, [trace], layout);
    }
    predictClusters();
    </script>
</body>
</html>