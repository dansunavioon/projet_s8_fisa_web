<?php
/*
 * Page de visualisation des arbres : tableau et carte.
 * Le tableau est rempli via un appel AJAX à api/get_trees.php.
 * Les prédictions sont lancées par les boutons en bas de page.
 */
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Visualiser les arbres</title>
    <link rel="stylesheet" href="assets/style.css">
    <script src="https://cdn.plot.ly/plotly-2.18.2.min.js"></script>
</head>
<body>
    <header>
        <h1>Visualiser les arbres</h1>
        <nav>
            <ul>
                <li><a href="index.php">Accueil</a></li>
                <li><a href="add_tree.php">Ajouter un arbre</a></li>
                <li><a href="view_trees.php">Visualiser les arbres</a></li>
            </ul>
        </nav>
    </header>
    <main>
        <h2>Liste des arbres</h2>
        <div class="table-wrapper">
            <table id="treesTable">
                <thead>
                    <tr>
                        <th></th>
                        <th>ID</th>
                        <th>Espèce</th>
                        <th>Hauteur totale</th>
                        <th>Diamètre du tronc</th>
                        <th>Âge estimé</th>
                        <th>Remarquable</th>
                        <th>État</th>
                        <th>Stade</th>
                        <th>Port</th>
                        <th>Pied</th>
                        <th>Révêtement</th>
                        <th>Feuillage</th>
                        <th>Quartier</th>
                        <th>Secteur</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Les lignes sont générées par JS -->
                </tbody>
            </table>
        </div>
        <div class="map-wrapper">
            <div class="map-container" id="treesMap"></div>

            <div id="legendBox"></div>
            <div id="coordsBox">Lat : -, Lon : -</div>
        </div>
        <div class="cluster-controls">
            <label for="nbClusters">Nombre de clusters :</label>
            <select id="nbClusters">
                <option value="2">2</option>
                <option value="3" selected>3</option>
            </select>
        </div>
        <div class="buttons-container">
            <button id="clusterBtn">Prédire les clusters</button>
            <button id="riskBtn" disabled>Prédire le déracinement</button>
        </div>
        <div id="result"></div>
    </main>
    <footer>
        <p>Projet FISA4 – Big Data / IA / Web</p>
    </footer>

    <script>
    // Variables globales
    let selectedTreeId = null;
    let treesData = [];

    // Récupérer la liste des arbres et remplir le tableau
    async function loadTrees() {
        const res = await fetch('api/get_trees.php');
        const data = await res.json();
        treesData = data;
        const tbody = document.querySelector('#treesTable tbody');
        tbody.innerHTML = '';
        data.forEach(tree => {
            const tr = document.createElement('tr');
            // Bouton radio
            const tdRadio = document.createElement('td');
            const radio = document.createElement('input');
            radio.type = 'radio';
            radio.name = 'selectedTree';
            radio.value = tree.id;
            radio.addEventListener('change', () => {
                selectedTreeId = tree.id;
                // activer les boutons de prédiction
                document.getElementById('riskBtn').disabled = false;
                // mettre en évidence la ligne sélectionnée
                document.querySelectorAll('#treesTable tbody tr').forEach(row => row.classList.remove('selected'));
                tr.classList.add('selected');
            });
            tdRadio.appendChild(radio);
            tr.appendChild(tdRadio);
            // Autres colonnes
            ['id','species','height_total','trunk_diam','age_est','remarkable','state','stage','port','foot','revetement','feuillage','quartier','secteur'].forEach(key => {
                const td = document.createElement('td');
                td.textContent = tree[key];
                tr.appendChild(td);
            });
            tbody.appendChild(tr);
        });
        drawMap(data);
    }

    // Afficher la carte avec Plotly/Mapbox
    function drawMap(data) {
        const lat = [];
        const lon = [];
        const texts = [];
        const colors = [];
        data.forEach(tree => {
            lat.push(tree.lat);
            lon.push(tree.lon);
            texts.push(`ID ${tree.id} - ${tree.species}`);
            // Couleur selon cluster ou risque
            if (tree.cluster_id === null || tree.cluster_id === undefined) {
                colors.push('blue');
            } else {
                // Palette simple : trois clusters max
                const palette = ['red','green','orange','purple','brown','grey'];
                colors.push(palette[tree.cluster_id % palette.length]);
            }
        });
        const trace = {
            type: 'scattermapbox',
            lat: lat,
            lon: lon,
            mode: 'markers',
            marker: {
                color: colors,
                size: 8
            },
            text: texts
        };
        const layout = {
            mapbox: {
                style: 'open-street-map',
                center: { lon: 3.2873, lat: 49.8445 },
                zoom: 12
            },
            margin: { t:0, b:0, l:0, r:0 }
        };
        Plotly.newPlot('treesMap', [trace], layout);
        const mapDiv = document.getElementById('treesMap');
        const coordsBox = document.getElementById('coordsBox');

        mapDiv.on('plotly_click', function(eventData) {
            if (eventData.points && eventData.points.length > 0) {
                const lat = eventData.points[0].lat;
                const lon = eventData.points[0].lon;

                coordsBox.textContent = `Lat : ${lat.toFixed(6)} | Lon : ${lon.toFixed(6)}`;
            }
        });
    }

    function updateLegend(nbClusters) {
        const legend = document.getElementById('legendBox');

        let html = '<strong>Légende</strong><br>';

        if (nbClusters == 2) {
            html += `
                <div class="legend-item">
                    <div class="legend-color" style="background:green"></div> Grand
                </div>
                <div class="legend-item">
                    <div class="legend-color" style="background:red"></div> Petit
                </div>
            `;
        } else if (nbClusters == 3) {
            html += `
                <div class="legend-item">
                    <div class="legend-color" style="background:red"></div> Grand
                </div>
                <div class="legend-item">
                    <div class="legend-color" style="background:green"></div> Petit
                </div>
                <div class="legend-item">
                    <div class="legend-color" style="background:orange"></div> Moyen
                </div>
            `;
        }

        legend.innerHTML = html;
    }

    // Bouton prédiction cluster
    document.getElementById('clusterBtn').addEventListener('click', async () => {
        const nbClusters = document.getElementById('nbClusters').value;

        const res = await fetch(`api/predict_cluster_api.php?nb_clusters=${nbClusters}`);
        const data = await res.json();

        if (data.success) {
            await loadTrees();

            updateLegend(nbClusters); // 👈 AJOUT IMPORTANT

            alert(`${data.updated.length} arbres mis à jour`);
        }
    });

    // Bouton prédiction risque
    document.getElementById('riskBtn').addEventListener('click', async () => {
        if (!selectedTreeId) return;
        const res = await fetch('api/predict_risk_api.php?tree_id=' + selectedTreeId);
        const data = await res.json();
        const result = document.getElementById('result');
        if (data.success) {
            result.innerHTML = `<div class="prediction-result"><p>Risque : ${data.prediction == 1 ? '<span class=\"danger\">Élevé</span>' : '<span class=\"success\">Faible</span>'}</p><p>Probabilité (abattu) : ${data.proba_abattu}</p><p>Probabilité (en place) : ${data.proba_en_place}</p></div>`;
        } else {
            result.textContent = 'Erreur: ' + data.error;
        }
    });

    // Initialisation
    loadTrees();
    </script>
</body>
</html>