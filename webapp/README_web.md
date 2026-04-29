# Application web de gestion du patrimoine arboré

Ce répertoire contient une preuve de concept d’application web construite
pour répondre aux besoins du projet A3 (client 1 et client 3). La
structure respecte les consignes du cahier des charges : HTML / CSS / JS
pour la partie front‑end, PHP pour la partie back‑end et PostgreSQL pour
la base de données.

## Arborescence

```
webapp/
├── README_web.md               # Ce document
├── index.php                   # Page d’accueil
├── add_tree.php                # Formulaire d’ajout d’un arbre
├── view_trees.php              # Tableau des arbres et carte interactive
├── predict_cluster.php         # Page de prédiction des clusters (client 1)
├── predict_risk.php            # Page de prédiction de l’âge ou du déracinement (client 3)
├── api/                        # Scripts PHP répondant en JSON
│   ├── db_connect.php          # Connexion PDO à la base PostgreSQL
│   ├── get_tree_attrs.php      # Renvoie les valeurs des listes déroulantes
│   ├── get_trees.php           # Renvoie la liste des arbres
│   ├── add_tree_api.php        # Insère un arbre en base
│   ├── predict_cluster_api.php # Appelle le wrapper Python pour prédire les clusters
│   └── predict_risk_api.php    # Appelle le wrapper Python pour prédire l’âge ou le risque
├── assets/
│   ├── style.css               # Feuille de styles commune
│   ├── app.js                  # Fonctions JavaScript pour la page view_trees.php
│   └── map.js                  # Fonctions d’affichage de la carte Plotly/Mapbox
└── wrappers/
    ├── predict_cluster.py      # Script Python pour prédire un cluster (k‑means)
    └── predict_risk.py         # Script Python pour prédire l’état (RandomForest IA)
```

## Pré‑requis

* Un serveur web Apache avec PHP 8 (ou supérieur) activé.
* Une base de données PostgreSQL accessible (les informations de connexion
  sont définies dans `api/db_connect.php`). Le fichier `arbres_db.sql`
  fournit un modèle de base et des données d’exemple.
* Python 3 avec les dépendances de l’IA (pandas, scikit‑learn, joblib).
* Les modèles et encodeurs générés dans la partie IA doivent être
  présents dans `../IA/Client_3/project_models/...` (pour la
  prédiction de déracinement) et dans `../IA/Client_1/` (pour
  la prédiction des clusters). Vous pouvez adapter les chemins dans
  `wrappers/predict_cluster.py` et `wrappers/predict_risk.py` en
  conséquence.

## Mise en place et améliorations graphiques

1. **Importer la base de données** :
   - Ouvrez votre interface SQL (par exemple SQLTools).
   - Exécutez le script `arbres_db.sql` pour créer les tables et
     insérer les valeurs de référence. Ce script définit également
     des valeurs de référence compatibles avec les encodeurs utilisés
     dans la partie IA (`Libre`, `Couronne`, `Semi_libre` pour les types de port,
     `Terre`, `Gazon`, `Bande_de_terre` pour les pieds, etc.).
     Le script intègre désormais l’intégralité des secteurs et des quartiers
     présents dans votre CSV (plus de 300 entrées), ainsi qu’une dizaine
     d’arbres d’exemple supplémentaires. Assurez‑vous d’être connecté à la base
     `arbres` avant d’exécuter le script.
2. **Configurer la connexion** :
   - Ouvrez `api/db_connect.php` et modifiez les constantes
     `$host`, `$db`, `$user`, `$pass` selon votre configuration PostgreSQL.
3. **Déployer les fichiers** :
   - Copiez l’intégralité du dossier `webapp` dans le répertoire
     accessible par votre serveur Apache (par exemple `/var/www/html/arbres`).
   - Veillez à conserver l’arborescence des sous‑dossiers `api/`,
     `assets/` et `wrappers/`.
4. **Vérifier l’installation** :
   - Accédez à `http://localhost/arbres/index.php` dans votre
     navigateur. La page d’accueil s’affiche avec un menu.
   - Naviguez vers "Ajouter un arbre" pour ajouter un nouvel enregistrement.
   - Naviguez vers "Visualiser les arbres" pour voir le tableau et la
     carte. Les prédictions des clusters et du risque sont accessibles
     par les boutons correspondants.

L’interface a été modernisée : couleurs beige et brunes,
polices harmonisées, boutons au style doux et jeu d’ombres léger,
hero section accueillante en page d’accueil et footer professionnel.
Le tableau alterne les couleurs de lignes pour une meilleure
lisibilité et les cartes sont bordées de bords arrondis.

## Notes sur les prédictions

* **Prédiction des clusters (Client 1)** : le script Python
  `wrappers/predict_cluster.py` nécessite un fichier modèle
  `kmeans_model_kX.pkl` (où `X` est le nombre de clusters) pour
  fonctionner. Placez vos fichiers de modèle dans
  `../IA/Client_1/` ou modifiez le chemin dans le wrapper.
* **Prédiction de l’âge ou du risque (Client 3)** : le script
  `wrappers/predict_risk.py` s’appuie sur le modèle
  `random_forest_best.pkl` et les encodeurs stockés dans
  `../IA/Client_3/project_models/encoders`. Veillez à ce qu’ils
  soient présents.

   Lors de l’appel au script via l’API, l’indicateur « remarquable »
   est converti en `'Oui'` ou `'Non'` et la variable de situation est
   fixée à `'Isole'` afin d’être compatible avec les encodages
   disponibles dans les modèles IA.

## Utilisation rapide

1. **Ajouter un arbre** : rendez‑vous sur la page "Ajouter un arbre"
   (`add_tree.php`), remplissez le formulaire et soumettez. Les
   valeurs des listes déroulantes proviennent de la base et sont
   donc cohérentes avec votre jeu de données.
2. **Visualiser et prédire** : la page "Visualiser les arbres"
   (`view_trees.php`) affiche un tableau et une carte des arbres
   enregistrés. Sélectionnez un arbre via le bouton radio puis
   cliquez sur "Prédire l’âge" ou "Prédire le déracinement".
   Pour prédire les clusters, cliquez sur "Prédire les clusters".
3. **Résultats** : les pages `predict_cluster.php` et
   `predict_risk.php` affichent la sortie des scripts Python et une
   version colorée de la carte. Les mises à jour éventuelles du
   champ `cluster_id` ou des colonnes `risk_pred`/`risk_proba` sont
   réalisées côté serveur.

## Limitations

Cette preuve de concept fournit les structures et les appels
essentiels. Pour un site en production, il serait nécessaire de :

- Mettre en place un système d’authentification si vous activez
  l’ajout d’arbres (bonus).
- Utiliser une clé Mapbox valide pour la carte Plotly.
- Mettre en place un meilleur système d’importation des données
  initiales, d’auto‑complétion d’espèces et de filtrage.
