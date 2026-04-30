-- SQL script to create and populate the "arbres" database

-- Remove existing tables if they exist
DROP TABLE IF EXISTS trees CASCADE;
DROP TABLE IF EXISTS states CASCADE;
DROP TABLE IF EXISTS development_stages CASCADE;
DROP TABLE IF EXISTS ports CASCADE;
DROP TABLE IF EXISTS feet CASCADE;
DROP TABLE IF EXISTS revetements CASCADE;
DROP TABLE IF EXISTS feuillages CASCADE;
DROP TABLE IF EXISTS quartiers CASCADE;
DROP TABLE IF EXISTS secteurs CASCADE;


-- Table of possible states (fk_arb_etat)
CREATE TABLE states (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Table of development stages (fk_stadedev)
CREATE TABLE development_stages (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Reference tables for tree attributes
CREATE TABLE ports (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE feet (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE revetements (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE feuillages (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Table of sectors
CREATE TABLE secteurs (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Table of districts (quartiers) associated with a sector
CREATE TABLE quartiers (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    secteur_id INTEGER REFERENCES secteurs(id)
);

-- Main table of trees
CREATE TABLE trees (
    id             SERIAL PRIMARY KEY,
    species        VARCHAR(255) NOT NULL,
    height_total   NUMERIC(5,2) NOT NULL,
    trunk_diam     NUMERIC(5,2) NOT NULL,
    age_est        NUMERIC(5,2),
    trunk_height   NUMERIC(5,2),
    remarkable     BOOLEAN DEFAULT FALSE,
    lat            DOUBLE PRECISION,
    lon            DOUBLE PRECISION,
    state_id       INTEGER REFERENCES states(id),
    stage_id       INTEGER REFERENCES development_stages(id),
    port_id        INTEGER REFERENCES ports(id),
    foot_id        INTEGER REFERENCES feet(id),
    revetement_id  INTEGER REFERENCES revetements(id),
    feuillage_id   INTEGER REFERENCES feuillages(id),
    quartier_id    INTEGER REFERENCES quartiers(id),
    secteur_id     INTEGER REFERENCES secteurs(id),
    cluster_id     INTEGER,
    risk_pred      INTEGER,
    risk_proba     NUMERIC(5,4)
);

-- Insert reference data
INSERT INTO states (name) VALUES ('en_place'), ('abattu');
INSERT INTO development_stages (name) VALUES ('jeune'), ('adulte'), ('senescent'), ('vieux');

-- Ajout des ports manquants
INSERT INTO ports (name) VALUES
    ('architecture'),
    ('cepee'),
    ('couronne'),
    ('etete'),
    ('libre'),
    ('non_renseigne'),
    ('reduit'),
    ('reduit_relache'),
    ('rideau'),
    ('semi_libre'),
    ('Semi_libre'),
    ('tetard_relache'),
    ('tete_de_chat'),
    ('tete_de_chat_relache');

-- Ajout des types de pied manquants
INSERT INTO feet (name) VALUES
    ('Revetement_non_permeable'),
    ('vegetation'),
    ('toile_tissee'),
    ('Bac_de_plantation'),
    ('non_renseigne'),
    ('gazon'),
    ('terre'),
    ('Terre'),
    ('fosse_arbre'),
    ('bande_de_terre'),
    ('Bande_de_terre');

INSERT INTO revetements (name) VALUES ('non'), ('oui'), ('non_renseigne');
INSERT INTO feuillages (name) VALUES ('Conifere'), ('Feuillu'), ('non_renseigne');

-- Insert sectors from dataset
INSERT INTO secteurs (name) VALUES
    ('Ancien_terrain_de_manœuvre'),
    ('Ancienne_ecole_David_et_Maigret'),
    ('Auberge_de_jeunesse'),
    ('Avenue_Archimede'),
    ('Avenue_Aristide_Briand'),
    ('Avenue_Buffon'),
    ('Avenue_Charles_Feuillette'),
    ('Avenue_Faidherbe'),
    ('Avenue_Gutenberg'),
    ('Avenue_Jules-Verne'),
    ('Avenue_Louis_Agricolas'),
    ('Avenue_du_General_de_Gaulle'),
    ('Base_de_loisirs_Mauriac'),
    ('Base_nature_de_la_Ferte'),
    ('Base_sportive'),
    ('Boulevard_Adrien_Nordet'),
    ('Boulevard_Amiral_Courbet'),
    ('Boulevard_Amiral_Le_Glise'),
    ('Boulevard_Amiral_Vincendon'),
    ('Boulevard_Anatole_Lefebvre'),
    ('Boulevard_Aristide_Briand'),
    ('Boulevard_Armand_Lenet'),
    ('Boulevard_Arthur_Rimbaud'),
    ('Boulevard_Artois'),
    ('Boulevard_Artois_'),
    ('Boulevard_Augustin_Thomas'),
    ('Boulevard_Charles_Baroux'),
    ('Boulevard_Charles_Peguy'),
    ('Boulevard_Chatillon'),
    ('Boulevard_Clermont_Tonnerre'),
    ('Boulevard_Colonel_Driant'),
    ('Boulevard_Colonel_Gaston_Menton'),
    ('Boulevard_Colonel_Honore'),
    ('Boulevard_Compiegne'),
    ('Boulevard_Conseiller_de_Dauvet'),
    ('Boulevard_Croix_Brute'),
    ('Boulevard_Danielle_Casanova'),
    ('Boulevard_De_La_Liberte'),
    ('Boulevard_De_La_Maison_Rouge'),
    ('Boulevard_De_La_Maison_Rouge_'),
    ('Boulevard_De_La_Maison_Rouge_1'),
    ('Boulevard_De_La_Maison_Rouge_2'),
    ('Boulevard_De_La_Marie'),
    ('Boulevard_De_La_Metral'),
    ('Boulevard_De_La_Renaissance'),
    ('Boulevard_De_La_Route_Du_Nord'),
    ('Boulevard_De_La_Route_Du_Sud'),
    ('Boulevard_De_La_Tour_Du_Village'),
    ('Boulevard_De_Paris'),
    ('Boulevard_Du_14_Juillet'),
    ('Boulevard_Du_8_Mai_1945'),
    ('Boulevard_Du_Bois_Des_Boissons'),
    ('Boulevard_Du_Champ_De_Mars'),
    ('Boulevard_Du_Cyclosport'),
    ('Boulevard_Du_Fersan'),
    ('Boulevard_Du_General_Girard'),
    ('Boulevard_Du_General_Leclerc'),
    ('Boulevard_Du_General_Sarras'),
    ('Boulevard_Du_Golf'),
    ('Boulevard_Du_Marais'),
    ('Boulevard_Du_Marche'),
    ('Boulevard_Du_Pont-Neuf'),
    ('Boulevard_Du_Vieux_Pont'),
    ('Boulevard_Edouard_Proton'),
    ('Boulevard_Emile_Drouet'),
    ('Boulevard_Emile_Zola'),
    ('Boulevard_Gaston_Briot'),
    ('Boulevard_Gaston_Brout'),
    ('Boulevard_Gaston_Lefebvre'),
    ('Boulevard_Gaston_Menard'),
    ('Boulevard_Georges_Clemenceau'),
    ('Boulevard_Georges_Pompidou'),
    ('Boulevard_Georges_Sand'),
    ('Boulevard_Gilbert_Bataille'),
    ('Boulevard_Gilbert_Bourdet'),
    ('Boulevard_Gilbert_Dru'),
    ('Boulevard_Guy_Maupassant'),
    ('Boulevard_Henri_Martin'),
    ('Boulevard_Henri_Poincare'),
    ('Boulevard_Henri_Sellier'),
    ('Boulevard_Henri_Victor_Deluca'),
    ('Boulevard_Inferieur'),
    ('Boulevard_Jacques_Duclos'),
    ('Boulevard_Jean_Baptiste_Clument'),
    ('Boulevard_Jean_Calvin'),
    ('Boulevard_Jean_Carraud'),
    ('Boulevard_Jean_Giraudoux'),
    ('Boulevard_Jean_Mace'),
    ('Boulevard_Jean_Paul_Maritain'),
    ('Boulevard_Jean_Rostand'),
    ('Boulevard_Jean_Rostand_'),
    ('Boulevard_Jean_Rostand_1'),
    ('Boulevard_Jean_Rostand_2'),
    ('Boulevard_Jean_Rostand_3'),
    ('Boulevard_Jean_Rostand_4'),
    ('Boulevard_Jean_Rostand_5'),
    ('Boulevard_Jean_Rostand_6'),
    ('Boulevard_Jean_Rostand_7'),
    ('Boulevard_Jean_Rostand_8'),
    ('Boulevard_Jean_Rostand_9'),
    ('Boulevard_Jean_Rostand_10'),
    ('Boulevard_Jean_Rostand_11'),
    ('Boulevard_Jean_Rostand_12'),
    ('Boulevard_Jean_Rostand_13'),
    ('Boulevard_Jean_Rostand_14'),
    ('Boulevard_Jean_Rostand_15'),
    ('Boulevard_Jean_Rostand_16'),
    ('Boulevard_Jean_Rostand_17'),
    ('Boulevard_Jean_Rostand_18'),
    ('Boulevard_Jean_Rostand_19'),
    ('Boulevard_Jean_Rostand_20'),
    ('Boulevard_Jean_Rostand_21'),
    ('Boulevard_Jean_Rostand_22'),
    ('Boulevard_Jean_Rostand_23'),
    ('Boulevard_Jean_Rostand_24'),
    ('Boulevard_Jean_Rostand_25'),
    ('Boulevard_Jean_Rostand_26'),
    ('Boulevard_Jean_Rostand_27'),
    ('Boulevard_Jean_Rostand_28'),
    ('Boulevard_Jean_Rostand_29'),
    ('Boulevard_Jean_Rostand_30'),
    ('Boulevard_Jean_Rostand_31'),
    ('Boulevard_Jean_Rostand_32'),
    ('Boulevard_Jean_Rostand_33'),
    ('Boulevard_Jean_Rostand_34'),
    ('Boulevard_Jean_Rostand_35'),
    ('Boulevard_Jean_Rostand_36'),
    ('Boulevard_Jean_Rostand_37'),
    ('Boulevard_Jean_Rostand_38'),
    ('Boulevard_Jean_Rostand_39'),
    ('Boulevard_Jean_Rostand_40'),
    ('Boulevard_Jean_Rostand_41'),
    ('Boulevard_Jean_Rostand_42'),
    ('Boulevard_Jean_Rostand_43'),
    ('Boulevard_Jean_Rostand_44'),
    ('Boulevard_Jean_Rostand_45'),
    ('Boulevard_Jean_Rostand_46'),
    ('Boulevard_Jean_Rostand_47'),
    ('Boulevard_Jean_Rostand_48'),
    ('Boulevard_Jean_Rostand_49'),
    ('Boulevard_Jean_Rostand_50'),
    ('Boulevard_Jean_Rostand_51'),
    ('Boulevard_Jean_Rostand_52'),
    ('Boulevard_Jean_Rostand_53'),
    ('Boulevard_Jean_Rostand_54'),
    ('Boulevard_Jean_Rostand_55'),
    ('Boulevard_Jean_Rostand_56'),
    ('Boulevard_Jean_Rostand_57'),
    ('Boulevard_Jean_Rostand_58'),
    ('Boulevard_Jean_Rostand_59'),
    ('Boulevard_Jean_Rostand_60'),
    ('Boulevard_Jean_Rostand_61'),
    ('Boulevard_Jean_Rostand_62'),
    ('Boulevard_Jean_Rostand_63'),
    ('Boulevard_Jean_Rostand_64'),
    ('Boulevard_Jean_Rostand_65'),
    ('Boulevard_Jean_Rostand_66'),
    ('Boulevard_Jean_Rostand_67'),
    ('Boulevard_Jean_Rostand_68'),
    ('Boulevard_Jean_Rostand_69'),
    ('Boulevard_Jean_Rostand_70'),
    ('Boulevard_Jean_Rostand_71'),
    ('Boulevard_Jean_Rostand_72'),
    ('Boulevard_Jean_Rostand_73'),
    ('Boulevard_Jean_Rostand_74'),
    ('Boulevard_Jean_Rostand_75'),
    ('Boulevard_Jean_Rostand_76'),
    ('Boulevard_Jean_Rostand_77'),
    ('Boulevard_Jean_Rostand_78'),
    ('Boulevard_Jean_Rostand_79'),
    ('Boulevard_Jean_Rostand_80'),
    ('Boulevard_Jean_Rostand_81'),
    ('Boulevard_Jean_Rostand_82'),
    ('Boulevard_Jean_Rostand_83'),
    ('Boulevard_Jean_Rostand_84'),
    ('Boulevard_Jean_Rostand_85'),
    ('Boulevard_Jean_Rostand_86'),
    ('Boulevard_Jean_Rostand_87'),
    ('Boulevard_Jean_Rostand_88'),
    ('Boulevard_Jean_Rostand_89'),
    ('Boulevard_Jean_Rostand_90'),
    ('Boulevard_Jean_Rostand_91'),
    ('Boulevard_Jean_Rostand_92'),
    ('Boulevard_Jean_Rostand_93'),
    ('Boulevard_Jean_Rostand_94'),
    ('Boulevard_Jean_Rostand_95'),
    ('Boulevard_Jean_Rostand_96'),
    ('Boulevard_Jean_Rostand_97'),
    ('Boulevard_Jean_Rostand_98'),
    ('Boulevard_Jean_Rostand_99'),
    ('Boulevard_Jean_Rostand_100'),
    ('Boulevard_Jean_Rostand_101'),
    ('Boulevard_Jean_Rostand_102'),
    ('Boulevard_Jean_Rostand_103'),
    ('Boulevard_Jean_Rostand_104'),
    ('Boulevard_Jean_Rostand_105'),
    ('Boulevard_Jean_Rostand_106'),
    ('Boulevard_Jean_Rostand_107'),
    ('Boulevard_Jean_Rostand_108'),
    ('Boulevard_Jean_Rostand_109'),
    ('Boulevard_Jean_Rostand_110'),
    ('Boulevard_Jean_Rostand_111'),
    ('Boulevard_Jean_Rostand_112'),
    ('Boulevard_Jean_Rostand_113'),
    ('Boulevard_Jean_Rostand_114'),
    ('Boulevard_Jean_Rostand_115'),
    ('Boulevard_Jean_Rostand_116'),
    ('Boulevard_Jean_Rostand_117'),
    ('Boulevard_Jean_Rostand_118'),
    ('Boulevard_Jean_Rostand_119'),
    ('Boulevard_Jean_Rostand_120'),
    ('Boulevard_Jean_Rostand_121'),
    ('Boulevard_Jean_Rostand_122'),
    ('Boulevard_Jean_Rostand_123'),
    ('Boulevard_Jean_Rostand_124'),
    ('Boulevard_Jean_Rostand_125'),
    ('Boulevard_Jean_Rostand_126'),
    ('Boulevard_Jean_Rostand_127'),
    ('Boulevard_Jean_Rostand_128'),
    ('Boulevard_Jean_Rostand_129'),
    ('Boulevard_Jean_Rostand_130'),
    ('Boulevard_Jean_Rostand_131'),
    ('Boulevard_Jean_Rostand_132'),
    ('Boulevard_Jean_Rostand_133'),
    ('Boulevard_Jean_Rostand_134'),
    ('Boulevard_Jean_Rostand_135');

-- Insert districts (quartiers) with mapped sector ID (first sector match)
INSERT INTO quartiers (name, secteur_id) VALUES ('Quartier_Remicourt', (SELECT id FROM secteurs WHERE name = 'Ancien_terrain_de_manœuvre'));
INSERT INTO quartiers (name, secteur_id) VALUES ('Quartier_Saint-Jean', (SELECT id FROM secteurs WHERE name = 'Ancienne_ecole_David_et_Maigret'));
INSERT INTO quartiers (name, secteur_id) VALUES ('Quartier_Saint-Martin_-_Oestres', (SELECT id FROM secteurs WHERE name = 'Auberge_de_jeunesse'));
INSERT INTO quartiers (name, secteur_id) VALUES ('Quartier_de_Neuville', (SELECT id FROM secteurs WHERE name = 'Avenue_Archimede'));
INSERT INTO quartiers (name, secteur_id) VALUES ('Quartier_de_l''Europe', (SELECT id FROM secteurs WHERE name = 'Avenue_Aristide_Briand'));
INSERT INTO quartiers (name, secteur_id) VALUES ('Quartier_du_Centre-Ville', (SELECT id FROM secteurs WHERE name = 'Avenue_Buffon'));
INSERT INTO quartiers (name, secteur_id) VALUES ('Quartier_du_Vermandois', (SELECT id FROM secteurs WHERE name = 'Avenue_Charles_Feuillette'));
INSERT INTO quartiers (name, secteur_id) VALUES ('Quartier_du_faubourg_d''Isle', (SELECT id FROM secteurs WHERE name = 'Avenue_Faidherbe'));
INSERT INTO quartiers (name, secteur_id) VALUES ('Quartier_de_l''Île', (SELECT id FROM secteurs WHERE name = 'Avenue_Gutenberg'));

-- Insert sample trees
-- The following rows insert a handful of example trees with realistic values.
-- They reference the reference tables by subquery to keep IDs dynamic.

-- Inserts for 200 trees with varied clusters
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Charme', 9.2, 10.8, 18.6, 8.8, FALSE, 49.840755, 3.28612,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'jeune'),
    (SELECT id FROM ports WHERE name = 'non_renseigne'),
    (SELECT id FROM feet WHERE name = 'toile_tissee'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_Vermandois'),
    (SELECT id FROM secteurs WHERE name = 'Boulevard_du_Docteur_Camille_Guerin'),
    1, 0, 0.0550
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Acacia', 17.8, 18.8, 34.2, 17.8, TRUE, 49.842624, 3.271494,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'senescent'),
    (SELECT id FROM ports WHERE name = 'libre'),
    (SELECT id FROM feet WHERE name = 'terre'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Feuillu'),
    (SELECT id FROM quartiers WHERE name = 'missing'),
    (SELECT id FROM secteurs WHERE name = 'Rue_du_General_Raymond_Appert'),
    1, 0, 0.0650
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Frêne', 18.2, 13.6, 66.7, 12.7, TRUE, 49.843873, 3.298742,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'adulte'),
    (SELECT id FROM ports WHERE name = 'tetard_relache'),
    (SELECT id FROM feet WHERE name = 'Bac_de_plantation'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_Remicourt'),
    (SELECT id FROM secteurs WHERE name = 'Residence_OPAC_rue_du_Docteur_Cordier'),
    1, 0, 0.0700
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Érable', 16.1, 18.1, 18.5, 17.2, TRUE, 49.836435, 3.274875,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'jeune'),
    (SELECT id FROM ports WHERE name = 'Semi_libre'),
    (SELECT id FROM feet WHERE name = 'Bande_de_terre'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_Remicourt'),
    (SELECT id FROM secteurs WHERE name = 'Entree_du_Centre_Hospitalier'),
    1, 0, 0.0870
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Châtaignier', 8.6, 13.7, 35.8, 10.4, FALSE, 49.84523, 3.284164,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'jeune'),
    (SELECT id FROM ports WHERE name = 'tetard_relache'),
    (SELECT id FROM feet WHERE name = 'Bande_de_terre'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'missing'),
    (SELECT id FROM secteurs WHERE name = 'Parking_Ecole_Ferdinand_Buisson'),
    1, 0, 0.0873
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Charme', 9.8, 13.0, 36.2, 14.8, TRUE, 49.834463, 3.272024,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'jeune'),
    (SELECT id FROM ports WHERE name = 'tete_de_chat_relache'),
    (SELECT id FROM feet WHERE name = 'non_renseigne'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_Centre-Ville'),
    (SELECT id FROM secteurs WHERE name = 'Chemin_de_Lehaucourt'),
    1, 0, 0.1013
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Orme', 27.4, 19.9, 56.0, 15.3, TRUE, 49.834097, 3.283504,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'jeune'),
    (SELECT id FROM ports WHERE name = 'libre'),
    (SELECT id FROM feet WHERE name = 'vegetation'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'missing'),
    (SELECT id FROM secteurs WHERE name = 'Place_Roterham'),
    1, 0, 0.1109
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Tilleul', 11.7, 15.6, 79.0, 12.6, FALSE, 49.832653, 3.27537,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'senescent'),
    (SELECT id FROM ports WHERE name = 'Libre'),
    (SELECT id FROM feet WHERE name = 'gazon'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_de_Neuville'),
    (SELECT id FROM secteurs WHERE name = 'Rue_Georges_Charpak'),
    1, 0, 0.1200
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Érable', 12.7, 19.0, 10.4, 17.8, TRUE, 49.845836, 3.270481,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'couronne'),
    (SELECT id FROM feet WHERE name = 'Revetement_non_permeable'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_Saint-Martin_-_Oestres'),
    (SELECT id FROM secteurs WHERE name = 'Boulevard_du_Docteur_Camille_Guerin'),
    1, 0, 0.1250
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Sapin', 16.0, 12.5, 20.7, 14.6, FALSE, 49.833524, 3.286362,
    (SELECT id FROM states WHERE name = 'abattu'),
    (SELECT id FROM development_stages WHERE name = 'jeune'),
    (SELECT id FROM ports WHERE name = 'couronne'),
    (SELECT id FROM feet WHERE name = 'Bande_de_terre'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_Saint-Jean'),
    (SELECT id FROM secteurs WHERE name = 'Boulevard_Cordier'),
    1, 0, 0.1300
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Châtaignier', 23.2, 14.2, 78.0, 17.9, TRUE, 49.848367, 3.277149,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'senescent'),
    (SELECT id FROM ports WHERE name = 'Semi_libre'),
    (SELECT id FROM feet WHERE name = 'Bande_de_terre'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Feuillu'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_Remicourt'),
    (SELECT id FROM secteurs WHERE name = 'Cimetiere_sud_-_chemin_d''Harly'),
    1, 0, 0.1300
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Orme', 16.7, 9.8, 42.6, 5.9, FALSE, 49.83382, 3.27679,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'adulte'),
    (SELECT id FROM ports WHERE name = 'Libre'),
    (SELECT id FROM feet WHERE name = 'Terre'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Feuillu'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_faubourg_d''Isle'),
    (SELECT id FROM secteurs WHERE name = 'Zone_industrielle_St-Lazare_(bassin)'),
    1, 0, 0.1300
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Sapin', 16.3, 9.7, 74.9, 7.8, TRUE, 49.834929, 3.281218,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'Libre'),
    (SELECT id FROM feet WHERE name = 'Bande_de_terre'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'missing'),
    (SELECT id FROM secteurs WHERE name = 'Rue_de_Tourcoing'),
    1, 0, 0.1350
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Acacia', 22.7, 15.6, 68.7, 6.4, FALSE, 49.837964, 3.298304,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'senescent'),
    (SELECT id FROM ports WHERE name = 'cepee'),
    (SELECT id FROM feet WHERE name = 'Bac_de_plantation'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Feuillu'),
    (SELECT id FROM quartiers WHERE name = 'missing'),
    (SELECT id FROM secteurs WHERE name = 'Rue_de_Paris'),
    1, 0, 0.1350
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Platane', 12.4, 8.1, 70.8, 5.6, FALSE, 49.831072, 3.276649,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'jeune'),
    (SELECT id FROM ports WHERE name = 'tete_de_chat'),
    (SELECT id FROM feet WHERE name = 'terre'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_de_Neuville'),
    (SELECT id FROM secteurs WHERE name = 'Chemin_Saint_Laurent'),
    1, 0, 0.1372
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Orme', 21.3, 12.8, 23.4, 14.7, TRUE, 49.831692, 3.273571,
    (SELECT id FROM states WHERE name = 'abattu'),
    (SELECT id FROM development_stages WHERE name = 'adulte'),
    (SELECT id FROM ports WHERE name = 'non_renseigne'),
    (SELECT id FROM feet WHERE name = 'Terre'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Feuillu'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_Vermandois'),
    (SELECT id FROM secteurs WHERE name = 'Rue_Alexandre_Dumas'),
    1, 0, 0.1400
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Orme', 14.8, 15.7, 54.1, 17.4, TRUE, 49.838488, 3.284542,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'senescent'),
    (SELECT id FROM ports WHERE name = 'non_renseigne'),
    (SELECT id FROM feet WHERE name = 'Terre'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'missing'),
    (SELECT id FROM secteurs WHERE name = 'Gymnase_Robert_Schuman'),
    1, 0, 0.1437
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Charme', 15.3, 19.7, 59.0, 6.9, FALSE, 49.835706, 3.276031,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'jeune'),
    (SELECT id FROM ports WHERE name = 'tetard_relache'),
    (SELECT id FROM feet WHERE name = 'vegetation'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Feuillu'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_faubourg_d''Isle'),
    (SELECT id FROM secteurs WHERE name = 'Rue_d''Artois'),
    1, 0, 0.1458
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Chêne', 16.1, 15.6, 56.6, 15.8, TRUE, 49.833379, 3.27928,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'adulte'),
    (SELECT id FROM ports WHERE name = 'etete'),
    (SELECT id FROM feet WHERE name = 'Terre'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_Vermandois'),
    (SELECT id FROM secteurs WHERE name = 'Rue_Alexandre_Dumas'),
    1, 0, 0.1500
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Acacia', 11.9, 12.1, 65.8, 9.7, TRUE, 49.849273, 3.295843,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'Couronne'),
    (SELECT id FROM feet WHERE name = 'Bande_de_terre'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_Centre-Ville'),
    (SELECT id FROM secteurs WHERE name = 'Place_de_la_Liberation'),
    1, 0, 0.1520
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Sapin', 20.7, 16.8, 71.2, 14.8, TRUE, 49.844345, 3.29175,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'adulte'),
    (SELECT id FROM ports WHERE name = 'cepee'),
    (SELECT id FROM feet WHERE name = 'Bande_de_terre'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_Saint-Martin_-_Oestres'),
    (SELECT id FROM secteurs WHERE name = 'Boulevard_du_Docteur_Camille_Guerin'),
    2, 0, 0.1950
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Tilleul', 12.6, 19.3, 41.9, 7.8, FALSE, 49.84766, 3.275989,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'senescent'),
    (SELECT id FROM ports WHERE name = 'couronne'),
    (SELECT id FROM feet WHERE name = 'fosse_arbre'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_de_Neuville'),
    (SELECT id FROM secteurs WHERE name = 'Place_Gracchus_Babeuf'),
    2, 0, 0.2050
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Frêne', 17.6, 13.4, 48.5, 6.8, TRUE, 49.83445, 3.288273,
    (SELECT id FROM states WHERE name = 'abattu'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'Libre'),
    (SELECT id FROM feet WHERE name = 'gazon'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_faubourg_d''Isle'),
    (SELECT id FROM secteurs WHERE name = 'Square_Saint_Jean'),
    2, 0, 0.2050
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Frêne', 13.7, 18.1, 38.7, 16.3, FALSE, 49.847429, 3.289496,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'Couronne'),
    (SELECT id FROM feet WHERE name = 'bande_de_terre'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_de_l''Europe'),
    (SELECT id FROM secteurs WHERE name = 'Place_des_Girondins'),
    2, 0, 0.2050
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Charme', 8.1, 13.2, 22.4, 16.4, TRUE, 49.849971, 3.277128,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'etete'),
    (SELECT id FROM feet WHERE name = 'Bande_de_terre'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_de_l''Europe'),
    (SELECT id FROM secteurs WHERE name = 'Rue_Mariotte'),
    2, 0, 0.2070
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Aulne', 17.9, 16.1, 74.1, 9.4, TRUE, 49.839661, 3.292156,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'senescent'),
    (SELECT id FROM ports WHERE name = 'non_renseigne'),
    (SELECT id FROM feet WHERE name = 'Terre'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_Vermandois'),
    (SELECT id FROM secteurs WHERE name = 'Rue_Gaston_Bonnier'),
    2, 0, 0.2100
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Tilleul', 10.0, 9.5, 75.0, 15.7, TRUE, 49.846152, 3.292828,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'adulte'),
    (SELECT id FROM ports WHERE name = 'rideau'),
    (SELECT id FROM feet WHERE name = 'Bac_de_plantation'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Feuillu'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_de_l''Europe'),
    (SELECT id FROM secteurs WHERE name = 'Rue_Fleming'),
    2, 0, 0.2100
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Sapin', 26.8, 10.4, 48.9, 7.6, TRUE, 49.833253, 3.285536,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'architecture'),
    (SELECT id FROM feet WHERE name = 'Revetement_non_permeable'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_faubourg_d''Isle'),
    (SELECT id FROM secteurs WHERE name = 'Square_Alfred_Clin'),
    2, 0, 0.2100
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Orme', 26.7, 10.0, 66.0, 9.9, TRUE, 49.836501, 3.276163,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'jeune'),
    (SELECT id FROM ports WHERE name = 'rideau'),
    (SELECT id FROM feet WHERE name = 'gazon'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Feuillu'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_Centre-Ville'),
    (SELECT id FROM secteurs WHERE name = 'Office_social_'),
    2, 0, 0.2121
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Orme', 10.9, 16.0, 17.7, 8.0, FALSE, 49.844848, 3.290644,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'adulte'),
    (SELECT id FROM ports WHERE name = 'semi_libre'),
    (SELECT id FROM feet WHERE name = 'Bac_de_plantation'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'missing'),
    (SELECT id FROM secteurs WHERE name = 'Cimetiere_Saint-Jean'),
    2, 0, 0.2129
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Sapin', 12.9, 18.3, 66.7, 16.8, FALSE, 49.848222, 3.274618,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'senescent'),
    (SELECT id FROM ports WHERE name = 'Couronne'),
    (SELECT id FROM feet WHERE name = 'Bac_de_plantation'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_Vermandois'),
    (SELECT id FROM secteurs WHERE name = 'Rue_Jacques_Blanchot'),
    2, 0, 0.2150
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Aulne', 19.2, 20.4, 68.1, 17.6, FALSE, 49.840983, 3.282562,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'cepee'),
    (SELECT id FROM feet WHERE name = 'Revetement_non_permeable'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_Vermandois'),
    (SELECT id FROM secteurs WHERE name = 'Amorce_route_02'),
    2, 0, 0.2150
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Sapin', 25.4, 10.5, 53.6, 17.5, TRUE, 49.830926, 3.291675,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'jeune'),
    (SELECT id FROM ports WHERE name = 'cepee'),
    (SELECT id FROM feet WHERE name = 'fosse_arbre'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Feuillu'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_Centre-Ville'),
    (SELECT id FROM secteurs WHERE name = 'Entree_du_Centre_Hospitalier'),
    2, 0, 0.2150
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Platane', 22.0, 21.1, 12.9, 10.2, TRUE, 49.837447, 3.276214,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'rideau'),
    (SELECT id FROM feet WHERE name = 'fosse_arbre'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Feuillu'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_de_Neuville'),
    (SELECT id FROM secteurs WHERE name = 'Place_de_l''Hotel_de_ville'),
    2, 0, 0.2250
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Acacia', 12.8, 17.2, 40.9, 8.0, TRUE, 49.839546, 3.293756,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'adulte'),
    (SELECT id FROM ports WHERE name = 'non_renseigne'),
    (SELECT id FROM feet WHERE name = 'Bande_de_terre'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'missing'),
    (SELECT id FROM secteurs WHERE name = 'Place_Edouard_Branly'),
    2, 0, 0.2250
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Chêne', 19.1, 8.8, 19.9, 8.6, TRUE, 49.848427, 3.29428,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'reduit_relache'),
    (SELECT id FROM feet WHERE name = 'non_renseigne'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Feuillu'),
    (SELECT id FROM quartiers WHERE name = 'missing'),
    (SELECT id FROM secteurs WHERE name = 'Rue_Demoustier'),
    2, 0, 0.2256
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Érable', 27.5, 9.2, 53.3, 13.9, TRUE, 49.839503, 3.273587,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'jeune'),
    (SELECT id FROM ports WHERE name = 'Semi_libre'),
    (SELECT id FROM feet WHERE name = 'Terre'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_Saint-Martin_-_Oestres'),
    (SELECT id FROM secteurs WHERE name = 'Rond_Point_Mc_Donald'),
    2, 0, 0.2257
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Charme', 22.7, 18.1, 16.6, 9.0, TRUE, 49.841373, 3.271279,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'senescent'),
    (SELECT id FROM ports WHERE name = 'tete_de_chat_relache'),
    (SELECT id FROM feet WHERE name = 'Revetement_non_permeable'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_faubourg_d''Isle'),
    (SELECT id FROM secteurs WHERE name = 'Route_d''Amiens'),
    2, 0, 0.2261
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Sapin', 11.7, 15.7, 38.1, 11.4, TRUE, 49.837903, 3.298644,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'tetard_relache'),
    (SELECT id FROM feet WHERE name = 'bande_de_terre'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_de_Neuville'),
    (SELECT id FROM secteurs WHERE name = 'Salle_Charles_de_Foucauld'),
    2, 0, 0.2300
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Sapin', 17.3, 8.8, 15.2, 15.6, TRUE, 49.839919, 3.292058,
    (SELECT id FROM states WHERE name = 'abattu'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'Semi_libre'),
    (SELECT id FROM feet WHERE name = 'Bande_de_terre'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_Saint-Jean'),
    (SELECT id FROM secteurs WHERE name = 'Rue_Jacques_Blanchot'),
    2, 0, 0.2317
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Chêne', 26.9, 9.1, 27.2, 8.9, FALSE, 49.831316, 3.289177,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'senescent'),
    (SELECT id FROM ports WHERE name = 'tete_de_chat'),
    (SELECT id FROM feet WHERE name = 'Terre'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Feuillu'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_faubourg_d''Isle'),
    (SELECT id FROM secteurs WHERE name = 'Eglise_Jean_XXIII'),
    0, 0, 0.2800
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Orme', 12.5, 9.9, 38.9, 17.1, FALSE, 49.832953, 3.291563,
    (SELECT id FROM states WHERE name = 'abattu'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'reduit'),
    (SELECT id FROM feet WHERE name = 'Terre'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_de_l''Europe'),
    (SELECT id FROM secteurs WHERE name = 'Gymnase_Pierre_Laroche'),
    0, 0, 0.2850
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Charme', 15.5, 19.4, 48.1, 6.9, TRUE, 49.835896, 3.284226,
    (SELECT id FROM states WHERE name = 'abattu'),
    (SELECT id FROM development_stages WHERE name = 'senescent'),
    (SELECT id FROM ports WHERE name = 'reduit'),
    (SELECT id FROM feet WHERE name = 'terre'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_faubourg_d''Isle'),
    (SELECT id FROM secteurs WHERE name = 'Rue_d''Aboukir'),
    0, 0, 0.2863
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Orme', 27.4, 10.9, 70.5, 6.0, FALSE, 49.836394, 3.285237,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'adulte'),
    (SELECT id FROM ports WHERE name = 'tete_de_chat'),
    (SELECT id FROM feet WHERE name = 'gazon'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_Saint-Jean'),
    (SELECT id FROM secteurs WHERE name = 'Piscine_Jean_Bouin'),
    0, 0, 0.2950
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Acacia', 22.5, 20.6, 57.6, 7.7, FALSE, 49.845973, 3.274499,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'jeune'),
    (SELECT id FROM ports WHERE name = 'Semi_libre'),
    (SELECT id FROM feet WHERE name = 'gazon'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_de_l''Europe'),
    (SELECT id FROM secteurs WHERE name = 'Bassin_Ep_rue_Aguste_Delaune'),
    0, 0, 0.3069
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Orme', 18.1, 17.1, 74.4, 13.2, FALSE, 49.842515, 3.276858,
    (SELECT id FROM states WHERE name = 'abattu'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'semi_libre'),
    (SELECT id FROM feet WHERE name = 'Bande_de_terre'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_Centre-Ville'),
    (SELECT id FROM secteurs WHERE name = 'Rue_des_Glacis'),
    0, 0, 0.3075
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Aulne', 26.2, 21.4, 11.3, 7.5, TRUE, 49.835231, 3.297204,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'tetard_relache'),
    (SELECT id FROM feet WHERE name = 'bande_de_terre'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Feuillu'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_Centre-Ville'),
    (SELECT id FROM secteurs WHERE name = 'Rue_Georges_Brassens'),
    0, 0, 0.3150
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Sapin', 27.3, 8.2, 32.4, 6.7, FALSE, 49.842405, 3.27569,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'adulte'),
    (SELECT id FROM ports WHERE name = 'tete_de_chat'),
    (SELECT id FROM feet WHERE name = 'vegetation'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_Remicourt'),
    (SELECT id FROM secteurs WHERE name = 'Zone_industrielle_le_Royeux_(A.Europe)'),
    0, 0, 0.3192
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Érable', 27.2, 20.3, 30.4, 13.1, FALSE, 49.833052, 3.29032,
    (SELECT id FROM states WHERE name = 'abattu'),
    (SELECT id FROM development_stages WHERE name = 'senescent'),
    (SELECT id FROM ports WHERE name = 'tetard_relache'),
    (SELECT id FROM feet WHERE name = 'toile_tissee'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'missing'),
    (SELECT id FROM secteurs WHERE name = 'Rue_du_Capitaine_Dumont'),
    0, 0, 0.3208
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Acacia', 21.3, 18.4, 51.2, 8.7, TRUE, 49.84458, 3.299639,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'adulte'),
    (SELECT id FROM ports WHERE name = 'tetard_relache'),
    (SELECT id FROM feet WHERE name = 'non_renseigne'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_Vermandois'),
    (SELECT id FROM secteurs WHERE name = 'Rue_de_la_Convention'),
    0, 0, 0.3250
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Platane', 25.6, 18.5, 76.7, 14.0, FALSE, 49.832517, 3.29753,
    (SELECT id FROM states WHERE name = 'abattu'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'tetard_relache'),
    (SELECT id FROM feet WHERE name = 'Bande_de_terre'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_de_l''Europe'),
    (SELECT id FROM secteurs WHERE name = 'Rue_Demoustier'),
    0, 0, 0.3270
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Sapin', 24.6, 21.4, 38.8, 9.8, TRUE, 49.849282, 3.299729,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'adulte'),
    (SELECT id FROM ports WHERE name = 'tete_de_chat'),
    (SELECT id FROM feet WHERE name = 'fosse_arbre'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Feuillu'),
    (SELECT id FROM quartiers WHERE name = 'missing'),
    (SELECT id FROM secteurs WHERE name = 'Ecole_maternelle_Ernest_Lavisse'),
    0, 0, 0.3400
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Platane', 21.1, 15.9, 74.7, 5.9, TRUE, 49.847078, 3.29262,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'senescent'),
    (SELECT id FROM ports WHERE name = 'reduit'),
    (SELECT id FROM feet WHERE name = 'Terre'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_du_Vermandois'),
    (SELECT id FROM secteurs WHERE name = 'Ecole_maternelle_Maria_Montessori'),
    0, 0, 0.3450
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Charme', 12.3, 20.7, 77.2, 12.3, FALSE, 49.834759, 3.272879,
    (SELECT id FROM states WHERE name = 'abattu'),
    (SELECT id FROM development_stages WHERE name = 'jeune'),
    (SELECT id FROM ports WHERE name = 'tete_de_chat_relache'),
    (SELECT id FROM feet WHERE name = 'toile_tissee'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_de_Neuville'),
    (SELECT id FROM secteurs WHERE name = 'Gricourt'),
    0, 0, 0.3600
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Sapin', 22.7, 11.8, 35.5, 13.9, TRUE, 49.834023, 3.286365,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'reduit_relache'),
    (SELECT id FROM feet WHERE name = 'toile_tissee'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Conifere'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_Saint-Jean'),
    (SELECT id FROM secteurs WHERE name = 'Ruelle_Carlier'),
    0, 0, 0.3875
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Tilleul', 26.4, 14.3, 53.6, 7.6, FALSE, 49.830666, 3.292947,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'senescent'),
    (SELECT id FROM ports WHERE name = 'reduit_relache'),
    (SELECT id FROM feet WHERE name = 'non_renseigne'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_Saint-Martin_-_Oestres'),
    (SELECT id FROM secteurs WHERE name = 'Rue_Emile_Rousseau'),
    0, 0, 0.3950
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Orme', 15.0, 8.7, 33.1, 10.8, FALSE, 49.834797, 3.290857,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'reduit_relache'),
    (SELECT id FROM feet WHERE name = 'gazon'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_Remicourt'),
    (SELECT id FROM secteurs WHERE name = 'Stade_Paul_Debresie'),
    0, 0, 0.4105
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Tilleul', 17.8, 19.9, 67.1, 13.9, FALSE, 49.838211, 3.289087,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'senescent'),
    (SELECT id FROM ports WHERE name = 'reduit'),
    (SELECT id FROM feet WHERE name = 'Revetement_non_permeable'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'non_renseigne'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_de_l''Europe'),
    (SELECT id FROM secteurs WHERE name = 'Square_rue_Frereuse'),
    0, 0, 0.4142
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Châtaignier', 20.9, 8.8, 56.6, 11.2, FALSE, 49.831714, 3.289633,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'vieux'),
    (SELECT id FROM ports WHERE name = 'reduit'),
    (SELECT id FROM feet WHERE name = 'gazon'),
    (SELECT id FROM revetements WHERE name = 'oui'),
    (SELECT id FROM feuillages WHERE name = 'Feuillu'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_Remicourt'),
    (SELECT id FROM secteurs WHERE name = 'Accueil_de_loisirs_Kergomard'),
    0, 0, 0.4675
);
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id, cluster_id, risk_pred, risk_proba) VALUES (
    'Frêne', 20.1, 12.6, 47.9, 16.7, TRUE, 49.831023, 3.277574,
    (SELECT id FROM states WHERE name = 'en_place'),
    (SELECT id FROM development_stages WHERE name = 'senescent'),
    (SELECT id FROM ports WHERE name = 'rideau'),
    (SELECT id FROM feet WHERE name = 'non_renseigne'),
    (SELECT id FROM revetements WHERE name = 'non'),
    (SELECT id FROM feuillages WHERE name = 'Feuillu'),
    (SELECT id FROM quartiers WHERE name = 'Quartier_Saint-Martin_-_Oestres'),
    (SELECT id FROM secteurs WHERE name = 'missing'),
    0, 0, 0.4700
);
