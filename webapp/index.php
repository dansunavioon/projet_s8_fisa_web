<?php
/*
 * Page d’accueil de l’application web.
 * Contient un menu de navigation et une présentation rapide du projet.
 */
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gestion du patrimoine arboré – Accueil</title>
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
    <header>
        <h1>Patrimoine arboré – Application web</h1>
        <nav>
            <ul>
                <li><a href="index.php">Accueil</a></li>
                <li><a href="add_tree.php">Ajouter un arbre</a></li>
                <li><a href="view_trees.php">Visualiser les arbres</a></li>
            </ul>
        </nav>
    </header>
    <main>
        <div class="hero">
            <h2>Bienvenue&nbsp;!</h2>
            <p>
                Ce portail vous permet de gérer et de visualiser le patrimoine arboré de la ville de manière moderne et intuitive.
                Ajoutez de nouveaux arbres, consultez ceux déjà enregistrés, affichez-les sur une carte interactive et utilisez nos modèles
                d’intelligence artificielle pour prédire leur groupe (client&nbsp;1) ou leur risque de déracinement (client&nbsp;3).
            </p>
            <p>
                Utilisez le menu de navigation pour commencer. La base de données est initialisée avec quelques exemples d’arbres&nbsp;;
                vous pouvez en ajouter d’autres via le formulaire.
            </p>
        </div>
    </main>
    <footer>
        <p>Projet FISA4 – Big Data / IA / Web</p>
    </footer>
</body>
</html>