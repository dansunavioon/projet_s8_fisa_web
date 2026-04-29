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
INSERT INTO ports (name) VALUES ('Libre'), ('Couronne'), ('Semi_libre');
INSERT INTO feet (name) VALUES ('Terre'), ('Gazon'), ('Bande_de_terre');
INSERT INTO revetements (name) VALUES ('non'), ('Oui'), ('non_renseigne');
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

INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id) VALUES (
    'Frêne', 23.0, 18.0, 38.0, 16.0, FALSE, 49.874961, 3.286801, (SELECT id FROM states WHERE name = 'en_place'), (SELECT id FROM development_stages WHERE name = 'adulte'), (SELECT id FROM ports WHERE name = 'Libre'), (SELECT id FROM feet WHERE name = 'Bande_de_terre'), (SELECT id FROM revetements WHERE name = 'non'), (SELECT id FROM feuillages WHERE name = 'non_renseigne'), (SELECT id FROM quartiers WHERE name = 'Quartier_Remicourt'), (SELECT id FROM secteurs WHERE name = 'Ancien_terrain_de_manœuvre'));
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id) VALUES (
    'Sapin', 25.0, 17.0, 29.0, 15.0, FALSE, 49.816097, 3.331145, (SELECT id FROM states WHERE name = 'en_place'), (SELECT id FROM development_stages WHERE name = 'jeune'), (SELECT id FROM ports WHERE name = 'Libre'), (SELECT id FROM feet WHERE name = 'Terre'), (SELECT id FROM revetements WHERE name = 'non'), (SELECT id FROM feuillages WHERE name = 'Feuillu'), (SELECT id FROM quartiers WHERE name = 'Quartier_du_Centre-Ville'), (SELECT id FROM secteurs WHERE name = 'Avenue_Buffon'));
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id) VALUES (
    'Chêne', 17.0, 20.0, 42.0, 11.0, FALSE, 49.832421, 3.258824, (SELECT id FROM states WHERE name = 'abattu'), (SELECT id FROM development_stages WHERE name = 'vieux'), (SELECT id FROM ports WHERE name = 'Couronne'), (SELECT id FROM feet WHERE name = 'Gazon'), (SELECT id FROM revetements WHERE name = 'Oui'), (SELECT id FROM feuillages WHERE name = 'Feuillu'), (SELECT id FROM quartiers WHERE name = 'Quartier_de_Neuville'), (SELECT id FROM secteurs WHERE name = 'Avenue_Archimede'));
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id) VALUES (
    'Érable', 11.0, 15.0, 63.0, 10.0, FALSE, 49.831964, 3.262580, (SELECT id FROM states WHERE name = 'abattu'), (SELECT id FROM development_stages WHERE name = 'senescent'), (SELECT id FROM ports WHERE name = 'Semi_libre'), (SELECT id FROM feet WHERE name = 'Gazon'), (SELECT id FROM revetements WHERE name = 'non_renseigne'), (SELECT id FROM feuillages WHERE name = 'Conifere'), (SELECT id FROM quartiers WHERE name = 'Quartier_du_Vermandois'), (SELECT id FROM secteurs WHERE name = 'Avenue_Charles_Feuillette'));
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id) VALUES (
    'Platane', 16.0, 21.0, 31.0, 9.0, FALSE, 49.878930, 3.281148, (SELECT id FROM states WHERE name = 'en_place'), (SELECT id FROM development_stages WHERE name = 'adulte'), (SELECT id FROM ports WHERE name = 'Couronne'), (SELECT id FROM feet WHERE name = 'Terre'), (SELECT id FROM revetements WHERE name = 'non'), (SELECT id FROM feuillages WHERE name = 'Feuillu'), (SELECT id FROM quartiers WHERE name = 'Quartier_Saint-Jean'), (SELECT id FROM secteurs WHERE name = 'Ancienne_ecole_David_et_Maigret'));
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id) VALUES (
    'Orme', 23.0, 12.0, 47.0, 12.0, FALSE, 49.878555, 3.331433, (SELECT id FROM states WHERE name = 'en_place'), (SELECT id FROM development_stages WHERE name = 'adulte'), (SELECT id FROM ports WHERE name = 'Semi_libre'), (SELECT id FROM feet WHERE name = 'Bande_de_terre'), (SELECT id FROM revetements WHERE name = 'non_renseigne'), (SELECT id FROM feuillages WHERE name = 'Feuillu'), (SELECT id FROM quartiers WHERE name = 'Quartier_du_faubourg_d''Isle'), (SELECT id FROM secteurs WHERE name = 'Avenue_Faidherbe'));
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id) VALUES (
    'Charme', 26.0, 15.0, 26.0, 20.0, FALSE, 49.829672, 3.273874, (SELECT id FROM states WHERE name = 'en_place'), (SELECT id FROM development_stages WHERE name = 'jeune'), (SELECT id FROM ports WHERE name = 'Libre'), (SELECT id FROM feet WHERE name = 'Terre'), (SELECT id FROM revetements WHERE name = 'non'), (SELECT id FROM feuillages WHERE name = 'Conifere'), (SELECT id FROM quartiers WHERE name = 'Quartier_Saint-Martin_-_Oestres'), (SELECT id FROM secteurs WHERE name = 'Auberge_de_jeunesse'));
INSERT INTO trees (species, height_total, trunk_diam, age_est, trunk_height, remarkable, lat, lon, state_id, stage_id, port_id, foot_id, revetement_id, feuillage_id, quartier_id, secteur_id) VALUES (
    'Châtaignier', 18.0, 24.0, 24.0, 11.0, FALSE, 49.842274, 3.330790, (SELECT id FROM states WHERE name = 'abattu'), (SELECT id FROM development_stages WHERE name = 'vieux'), (SELECT id FROM ports WHERE name = 'Couronne'), (SELECT id FROM feet WHERE name = 'Bande_de_terre'), (SELECT id FROM revetements WHERE name = 'Oui'), (SELECT id FROM feuillages WHERE name = 'Conifere'), (SELECT id FROM quartiers WHERE name = 'Quartier_de_l''Europe'), (SELECT id FROM secteurs WHERE name = 'Avenue_Aristide_Briand'));