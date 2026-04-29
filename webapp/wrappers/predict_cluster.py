#!/usr/bin/env python3
"""
Wrapper pour la prédiction de clusters (client 1).

Usage :
    python predict_cluster.py <nb_clusters> <haut_tot> <tronc_diam> <age_estim> <haut_tronc>

Exemple :
    python predict_cluster.py 3 20 40 50 6

Le script charge le modèle k‑means correspondant (``kmeans_model_kX.pkl``) dans
le répertoire ``../../IA/Client_1`` (relatif à ce script). Il applique
l’éventuel scaler, réalise la prédiction et renvoie un JSON sur la sortie
standard :

    {"cluster_id": 1, "cluster_label": "grand"}

Si le modèle n’existe pas, le script retourne une valeur ``cluster_id`` de
``-1`` et ``cluster_label`` à ``unknown``.
"""

import json
import os
import sys

import joblib
import pandas as pd

def main():
    if len(sys.argv) != 6:
        print(json.dumps({
            'error': 'Usage: predict_cluster.py <nb_clusters> <haut_tot> <tronc_diam> <age_estim> <haut_tronc>'
        }))
        sys.exit(1)

    try:
        nb = int(sys.argv[1])
        haut_tot = float(sys.argv[2])
        tronc_diam = float(sys.argv[3])
        age_estim = float(sys.argv[4])
        haut_tronc = float(sys.argv[5])
    except ValueError:
        print(json.dumps({ 'error': 'Invalid numeric values' }))
        sys.exit(1)

    # Détermination du chemin du modèle : identique au wrapper du dossier webapp.
    script_dir = os.path.dirname(os.path.abspath(__file__))
    model_name = f'kmeans_model_k{nb}.pkl'
    # Chemin du modèle : IA/Client_1/kmeans_model_kX.pkl depuis la racine du dépôt
    model_path = os.path.abspath(os.path.join(
        script_dir,
        '..', '..',
        'IA',
        'Client_1',
        model_name
    ))

    if not os.path.exists(model_path):
        # Return unknown cluster if file is missing
        print(json.dumps({ 'cluster_id': -1, 'cluster_label': 'unknown' }))
        return

    data = joblib.load(model_path)

    # Determine structure of the loaded model
    if isinstance(data, dict):
        model = data.get('model')
        scaler = data.get('scaler')
        label_map = data.get('label_map')
    else:
        model = data
        scaler = None
        label_map = None

    # Create DataFrame in correct column order
    X = pd.DataFrame([[haut_tot, tronc_diam, age_estim, haut_tronc]],
                     columns=['haut_tot', 'tronc_diam', 'age_estim', 'haut_tronc'])

    # Apply scaler if present
    if scaler is not None:
        X = scaler.transform(X)

    cluster_id = int(model.predict(X)[0])

    # Map to label
    if label_map:
        cluster_label = label_map.get(cluster_id, str(cluster_id))
    else:
        if nb == 2:
            # Par défaut : 0=grand, 1=petit ; mais l’ordre peut différer
            # On respecte la logique du script original
            mapping = {0: 'grand', 1: 'petit'}
            cluster_label = mapping.get(cluster_id, str(cluster_id))
        elif nb == 3:
            mapping = {0: 'grand', 1: 'petit', 2: 'moyen'}
            cluster_label = mapping.get(cluster_id, str(cluster_id))
        else:
            cluster_label = str(cluster_id)

    print(json.dumps({ 'cluster_id': cluster_id, 'cluster_label': cluster_label }))

if __name__ == '__main__':
    main()