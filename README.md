## Installation et environnement

### 1. Créez un environnement virtuel (optionnel mais recommandé) :

```bash
python -m venv venv
source venv/bin/activate   # ou venv\Scripts\activate sur Windows
```

### 2. Installez les dépendances à partir du fichier `requirements.txt` :

```bash
pip install -r requirements.txt
```

Les bibliothèques nécessaires incluent notamment `pandas`, `numpy`, `scikit‑learn`, `joblib`, `matplotlib`, `pyproj` et `folium`.

sudo service postgresql start
sudo -u postgres psql
CREATE DATABASE arbres;
\c arbres

sudo service apache2 start

postgres=# CREATE USER arbres_p WITH PASSWORD 'a';
CREATE ROLE
postgres=# CREATE DATABASE arbres;
CREATE DATABASE
postgres=# GRANT ALL PRIVILEGES ON DATABASE arbres TO arbres_p;
psql -U arbres_p -d arbres -h localhost
ALTER DATABASE arbres OWNER TO arbres_p;
GRANT ALL ON SCHEMA public TO arbres_p;