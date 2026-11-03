-- =====================================================================
-- Spotly : Modèle Physique de Données (MPD) pour PostgreSQL
-- Document associé : docs/mpd.md
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. Types énumérés : listes de valeurs autorisées
-- ---------------------------------------------------------------------

CREATE TYPE role_utilisateur AS ENUM ('UTILISATEUR', 'ADMINISTRATEUR');

-- Utilisé par les spots ET les commentaires (décisions D5 et D12)
CREATE TYPE statut_publication AS ENUM ('PUBLIE', 'MASQUE', 'SUPPRIME');

CREATE TYPE motif_signalement AS ENUM (
    'CONTENU_INAPPROPRIE',
    'INFORMATION_INCORRECTE',
    'SPAM',
    'SPOT_INEXISTANT',
    'AUTRE'
);

CREATE TYPE statut_signalement AS ENUM ('EN_ATTENTE', 'TRAITE', 'CLASSE_SANS_SUITE');


-- ---------------------------------------------------------------------
-- 2. Tables issues des entités
-- ---------------------------------------------------------------------

CREATE TABLE utilisateur (
    id_utilisateur        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pseudo                VARCHAR(30)  NOT NULL UNIQUE,
    email                 VARCHAR(255) NOT NULL UNIQUE,
    mot_de_passe          VARCHAR(255) NOT NULL,          -- empreinte (hash), jamais le mot de passe en clair
    prenom                VARCHAR(50),
    nom                   VARCHAR(50),
    ville                 VARCHAR(100),
    photo_profil          VARCHAR(500),
    role                  role_utilisateur NOT NULL DEFAULT 'UTILISATEUR',
    date_inscription      TIMESTAMPTZ  NOT NULL DEFAULT now(),
    date_acceptation_cgu  TIMESTAMPTZ  NOT NULL,

    CONSTRAINT ck_utilisateur_pseudo_non_vide CHECK (btrim(pseudo) <> '')
);

CREATE TABLE categorie (
    id_categorie  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    libelle       VARCHAR(50) NOT NULL UNIQUE,
    icone         VARCHAR(50) NOT NULL
);

CREATE TABLE tag (
    id_tag   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    libelle  VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE spot (
    id_spot            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    titre              VARCHAR(100)  NOT NULL,
    description        TEXT          NOT NULL,
    latitude           DECIMAL(9,6)  NOT NULL,
    longitude          DECIMAL(9,6)  NOT NULL,
    adresse            VARCHAR(255),
    duree_minutes      SMALLINT      NOT NULL,
    conseil            VARCHAR(300),
    statut             statut_publication NOT NULL DEFAULT 'PUBLIE',
    date_creation      TIMESTAMPTZ   NOT NULL DEFAULT now(),
    date_modification  TIMESTAMPTZ   NOT NULL DEFAULT now(),
    id_createur        INTEGER       NOT NULL,
    id_categorie       INTEGER       NOT NULL,

    CONSTRAINT fk_spot_createur  FOREIGN KEY (id_createur)
        REFERENCES utilisateur (id_utilisateur) ON DELETE CASCADE,
    CONSTRAINT fk_spot_categorie FOREIGN KEY (id_categorie)
        REFERENCES categorie (id_categorie) ON DELETE RESTRICT,

    CONSTRAINT ck_spot_titre_non_vide CHECK (btrim(titre) <> ''),
    CONSTRAINT ck_spot_latitude       CHECK (latitude  BETWEEN -90  AND 90),
    CONSTRAINT ck_spot_longitude      CHECK (longitude BETWEEN -180 AND 180),
    CONSTRAINT ck_spot_duree          CHECK (duree_minutes > 0)
);

CREATE TABLE photo (
    id_photo           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    url                VARCHAR(500) NOT NULL,
    identifiant_media  VARCHAR(255) NOT NULL UNIQUE,
    texte_alternatif   VARCHAR(150),
    ordre              SMALLINT     NOT NULL,
    date_ajout         TIMESTAMPTZ  NOT NULL DEFAULT now(),
    id_spot            INTEGER      NOT NULL,

    CONSTRAINT fk_photo_spot FOREIGN KEY (id_spot)
        REFERENCES spot (id_spot) ON DELETE CASCADE,

    CONSTRAINT uq_photo_spot_ordre UNIQUE (id_spot, ordre),
    CONSTRAINT ck_photo_ordre      CHECK (ordre BETWEEN 1 AND 5)
);

CREATE TABLE commentaire (
    id_commentaire    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    contenu           VARCHAR(1000) NOT NULL,
    statut            statut_publication NOT NULL DEFAULT 'PUBLIE',
    date_publication  TIMESTAMPTZ   NOT NULL DEFAULT now(),
    id_auteur         INTEGER       NOT NULL,
    id_spot           INTEGER       NOT NULL,

    CONSTRAINT fk_commentaire_auteur FOREIGN KEY (id_auteur)
        REFERENCES utilisateur (id_utilisateur) ON DELETE CASCADE,
    CONSTRAINT fk_commentaire_spot   FOREIGN KEY (id_spot)
        REFERENCES spot (id_spot) ON DELETE CASCADE,

    CONSTRAINT ck_commentaire_contenu_non_vide CHECK (btrim(contenu) <> '')
);

CREATE TABLE signalement (
    id_signalement    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    motif             motif_signalement  NOT NULL,
    description       VARCHAR(500),
    statut            statut_signalement NOT NULL DEFAULT 'EN_ATTENTE',
    date_signalement  TIMESTAMPTZ NOT NULL DEFAULT now(),
    date_traitement   TIMESTAMPTZ,
    id_auteur         INTEGER     NOT NULL,
    id_spot           INTEGER,            -- facultatif : rempli si le signalement vise un spot
    id_commentaire    INTEGER,            -- facultatif : rempli si le signalement vise un commentaire

    CONSTRAINT fk_signalement_auteur      FOREIGN KEY (id_auteur)
        REFERENCES utilisateur (id_utilisateur) ON DELETE CASCADE,
    CONSTRAINT fk_signalement_spot        FOREIGN KEY (id_spot)
        REFERENCES spot (id_spot) ON DELETE CASCADE,
    CONSTRAINT fk_signalement_commentaire FOREIGN KEY (id_commentaire)
        REFERENCES commentaire (id_commentaire) ON DELETE CASCADE,

    -- RG-16 / D10 : exactement une cible, ni zéro ni deux
    CONSTRAINT ck_signalement_une_cible CHECK (num_nonnulls(id_spot, id_commentaire) = 1),

    -- D13 : la date de traitement est remplie si et seulement si le signalement est traité
    CONSTRAINT ck_signalement_date_traitement CHECK (
        (statut = 'EN_ATTENTE' AND date_traitement IS NULL)
        OR (statut <> 'EN_ATTENTE' AND date_traitement IS NOT NULL)
    )
);


-- ---------------------------------------------------------------------
-- 3. Tables issues des associations plusieurs-à-plusieurs
-- ---------------------------------------------------------------------

CREATE TABLE favori (
    id_utilisateur  INTEGER     NOT NULL,
    id_spot         INTEGER     NOT NULL,
    date_ajout      TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT pk_favori PRIMARY KEY (id_utilisateur, id_spot),
    CONSTRAINT fk_favori_utilisateur FOREIGN KEY (id_utilisateur)
        REFERENCES utilisateur (id_utilisateur) ON DELETE CASCADE,
    CONSTRAINT fk_favori_spot        FOREIGN KEY (id_spot)
        REFERENCES spot (id_spot) ON DELETE CASCADE
);

CREATE TABLE note (
    id_utilisateur  INTEGER     NOT NULL,
    id_spot         INTEGER     NOT NULL,
    valeur          SMALLINT    NOT NULL,
    date_note       TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT pk_note PRIMARY KEY (id_utilisateur, id_spot),
    CONSTRAINT fk_note_utilisateur FOREIGN KEY (id_utilisateur)
        REFERENCES utilisateur (id_utilisateur) ON DELETE CASCADE,
    CONSTRAINT fk_note_spot        FOREIGN KEY (id_spot)
        REFERENCES spot (id_spot) ON DELETE CASCADE,

    CONSTRAINT ck_note_valeur CHECK (valeur BETWEEN 1 AND 5)
);

CREATE TABLE spot_tag (
    id_spot  INTEGER NOT NULL,
    id_tag   INTEGER NOT NULL,

    CONSTRAINT pk_spot_tag PRIMARY KEY (id_spot, id_tag),
    CONSTRAINT fk_spot_tag_spot FOREIGN KEY (id_spot)
        REFERENCES spot (id_spot) ON DELETE CASCADE,
    CONSTRAINT fk_spot_tag_tag  FOREIGN KEY (id_tag)
        REFERENCES tag (id_tag) ON DELETE CASCADE
);


-- ---------------------------------------------------------------------
-- 4. Index : accélèrent les recherches les plus fréquentes
-- ---------------------------------------------------------------------

-- Spots visibles dans la zone affichée sur la carte (US-03, US-04)
CREATE INDEX idx_spot_position    ON spot (latitude, longitude);
-- Filtre par catégorie (US-05)
CREATE INDEX idx_spot_categorie   ON spot (id_categorie);
-- « Mes spots » sur le profil
CREATE INDEX idx_spot_createur    ON spot (id_createur);
-- Commentaires d'un spot, sur sa fiche
CREATE INDEX idx_commentaire_spot ON commentaire (id_spot);
-- Moyenne des notes d'un spot
CREATE INDEX idx_note_spot        ON note (id_spot);
-- Filtre par tag
CREATE INDEX idx_spot_tag_tag     ON spot_tag (id_tag);
-- Liste des signalements à traiter (US-15)
CREATE INDEX idx_signalement_statut ON signalement (statut);


-- ---------------------------------------------------------------------
-- 5. Données de référence : les 10 catégories (D16)
-- ---------------------------------------------------------------------

INSERT INTO categorie (libelle, icone) VALUES
    ('Café',                  'cafe'),
    ('Coworking',             'coworking'),
    ('Restauration',          'restauration'),
    ('Bar et rooftop',        'bar'),
    ('Point de vue',          'point-de-vue'),
    ('Plage et baignade',     'plage'),
    ('Nature et randonnée',   'nature'),
    ('Culture et patrimoine', 'culture'),
    ('Marché',                'marche'),
    ('Activité',              'activite');
