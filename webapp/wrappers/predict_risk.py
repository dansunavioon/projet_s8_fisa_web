#!/usr/bin/env python3
"""
Wrapper pour la prédiction du risque de déracinement (client 3).

Usage :
    python predict_risk.py <haut_tot> <tronc_diam> <age_estim>
        <fk_stadedev> <fk_port> <fk_pied> <fk_situation> <fk_revetement>
        <remarquable> <feuillage> <clc_quartier> <clc_secteur>

Exemple :
    python predict_risk.py 20 40 50 jeune libre terre isole non 0 caduc 1 2

Le script charge le modèle RandomForest et les encodeurs sauvegardés
dans ``../../IA/Client_3/project_models/``. Il encode les variables
catégorielles, exécute la prédiction et renvoie un JSON :

    {"prediction": 1, "proba_en_place": 0.75, "proba_abattu": 0.25}

La valeur ``prediction`` vaut 1 lorsque l’arbre est considéré à risque
("abattu"), 0 sinon.
"""

import json
import os
import sys

import joblib
import pandas as pd

def load_encoders(encoders_path, feature_names):
    encoders = {}
    for feature in feature_names:
        encoder_file = os.path.join(encoders_path, f"{feature}_encoder.pkl")
        if os.path.exists(encoder_file):
            with open(encoder_file, 'rb') as f:
                encoders[feature] = joblib.load(f)
    return encoders

def encode_input(input_dict, encoders):
    encoded = {}
    for feature, value in input_dict.items():
        if feature in encoders:
            df_val = pd.DataFrame([[value]], columns=[feature])
            encoded_val = encoders[feature].transform(df_val)[0][0]
            encoded[feature] = encoded_val
        else:
            # remarquer : convertir en numérique si possible
            try:
                encoded[feature] = float(str(value).replace(',', '.'))
            except ValueError:
                encoded[feature] = value
    return encoded

def main():
    # Expect 12 arguments after the script name
    if len(sys.argv) != 13:
        print(json.dumps({
            'error': 'Usage: predict_risk.py <haut_tot> <tronc_diam> <age_estim> <fk_stadedev> <fk_port> <fk_pied> <fk_situation> <fk_revetement> <remarquable> <feuillage> <clc_quartier> <clc_secteur>'
        }))
        sys.exit(1)

    # Parse numeric features
    try:
        haut_tot   = float(sys.argv[1])
        tronc_diam = float(sys.argv[2])
        age_estim  = float(sys.argv[3])
        # remarq : convert to float (0 or 1) if numeric
        remarquable = float(sys.argv[9]) if sys.argv[9].replace('.', '', 1).isdigit() else sys.argv[9]
    except ValueError:
        print(json.dumps({ 'error': 'Invalid numeric values for numeric features' }))
        sys.exit(1)

    # Parse categorical features
    fk_stadedev  = sys.argv[4]
    fk_port      = sys.argv[5]
    fk_pied      = sys.argv[6]
    fk_situation = sys.argv[7]
    fk_revetement= sys.argv[8]
    feuillage    = sys.argv[10]
    clc_quartier = sys.argv[11]
    clc_secteur  = sys.argv[12]

    # Map all features into dict according to order
    feature_names = [
        'haut_tot', 'tronc_diam', 'age_estim',
        'fk_stadedev', 'fk_port', 'fk_pied', 'fk_situation',
        'fk_revetement', 'remarquable', 'feuillage',
        'clc_quartier', 'clc_secteur'
    ]

    user_input = {
        'haut_tot': haut_tot,
        'tronc_diam': tronc_diam,
        'age_estim': age_estim,
        'fk_stadedev': fk_stadedev,
        'fk_port': fk_port,
        'fk_pied': fk_pied,
        'fk_situation': fk_situation,
        'fk_revetement': fk_revetement,
        'remarquable': remarquable,
        'feuillage': feuillage,
        'clc_quartier': clc_quartier,
        'clc_secteur': clc_secteur
    }

    # Determine paths
    script_dir = os.path.dirname(os.path.abspath(__file__))
    # Dans cette preuve de concept, les modèles et encodeurs sont situés
    # dans le dossier project_models à la racine du dépôt. Adaptez ces
    # chemins si nécessaire.
    model_path = os.path.abspath(os.path.join(
        script_dir,
        '..', '..',        # remonte à la racine
        'IA',
        'Client_3',
        'project_models',
        'models',
        'random_forest_best.pkl'
    ))

    encoders_path = os.path.abspath(os.path.join(
        script_dir,
        '..', '..',
        'IA',
        'Client_3',
        'project_models',
        'encoders'
    ))

    if not os.path.exists(model_path):
        print(json.dumps({ 'error': f'Model not found at {model_path}' }))
        sys.exit(1)
    if not os.path.exists(encoders_path):
        print(json.dumps({ 'error': f'Encoders path not found at {encoders_path}' }))
        sys.exit(1)

    # Load model and encoders
    model = joblib.load(model_path)
    encoders = load_encoders(encoders_path, feature_names)

    # Encode user input
    encoded_input = encode_input(user_input, encoders)
    X_user = pd.DataFrame([encoded_input])
    X_user = X_user[feature_names]

    # Predict
    prediction = int(model.predict(X_user)[0])
    # Probabilities if available
    result = { 'prediction': prediction }
    if hasattr(model, 'predict_proba'):
        proba = model.predict_proba(X_user)[0]
        result['proba_en_place'] = float(round(proba[0], 4))
        result['proba_abattu']   = float(round(proba[1], 4))

    print(json.dumps(result))

if __name__ == '__main__':
    main()