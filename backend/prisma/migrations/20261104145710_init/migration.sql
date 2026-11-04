-- CreateEnum
CREATE TYPE "role_utilisateur" AS ENUM ('UTILISATEUR', 'ADMINISTRATEUR');

-- CreateEnum
CREATE TYPE "statut_publication" AS ENUM ('PUBLIE', 'MASQUE', 'SUPPRIME');

-- CreateEnum
CREATE TYPE "motif_signalement" AS ENUM ('CONTENU_INAPPROPRIE', 'INFORMATION_INCORRECTE', 'SPAM', 'SPOT_INEXISTANT', 'AUTRE');

-- CreateEnum
CREATE TYPE "statut_signalement" AS ENUM ('EN_ATTENTE', 'TRAITE', 'CLASSE_SANS_SUITE');

-- CreateTable
CREATE TABLE "utilisateur" (
    "id_utilisateur" SERIAL NOT NULL,
    "pseudo" VARCHAR(30) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "mot_de_passe" VARCHAR(255) NOT NULL,
    "prenom" VARCHAR(50),
    "nom" VARCHAR(50),
    "ville" VARCHAR(100),
    "photo_profil" VARCHAR(500),
    "role" "role_utilisateur" NOT NULL DEFAULT 'UTILISATEUR',
    "date_inscription" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_acceptation_cgu" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "utilisateur_pkey" PRIMARY KEY ("id_utilisateur")
);

-- CreateTable
CREATE TABLE "categorie" (
    "id_categorie" SERIAL NOT NULL,
    "libelle" VARCHAR(50) NOT NULL,
    "icone" VARCHAR(50) NOT NULL,

    CONSTRAINT "categorie_pkey" PRIMARY KEY ("id_categorie")
);

-- CreateTable
CREATE TABLE "tag" (
    "id_tag" SERIAL NOT NULL,
    "libelle" VARCHAR(50) NOT NULL,

    CONSTRAINT "tag_pkey" PRIMARY KEY ("id_tag")
);

-- CreateTable
CREATE TABLE "spot" (
    "id_spot" SERIAL NOT NULL,
    "titre" VARCHAR(100) NOT NULL,
    "description" TEXT NOT NULL,
    "latitude" DECIMAL(9,6) NOT NULL,
    "longitude" DECIMAL(9,6) NOT NULL,
    "adresse" VARCHAR(255),
    "duree_minutes" SMALLINT NOT NULL,
    "conseil" VARCHAR(300),
    "statut" "statut_publication" NOT NULL DEFAULT 'PUBLIE',
    "date_creation" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_modification" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_createur" INTEGER NOT NULL,
    "id_categorie" INTEGER NOT NULL,

    CONSTRAINT "spot_pkey" PRIMARY KEY ("id_spot")
);

-- CreateTable
CREATE TABLE "photo" (
    "id_photo" SERIAL NOT NULL,
    "url" VARCHAR(500) NOT NULL,
    "identifiant_media" VARCHAR(255) NOT NULL,
    "texte_alternatif" VARCHAR(150),
    "ordre" SMALLINT NOT NULL,
    "date_ajout" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_spot" INTEGER NOT NULL,

    CONSTRAINT "photo_pkey" PRIMARY KEY ("id_photo")
);

-- CreateTable
CREATE TABLE "commentaire" (
    "id_commentaire" SERIAL NOT NULL,
    "contenu" VARCHAR(1000) NOT NULL,
    "statut" "statut_publication" NOT NULL DEFAULT 'PUBLIE',
    "date_publication" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_auteur" INTEGER NOT NULL,
    "id_spot" INTEGER NOT NULL,

    CONSTRAINT "commentaire_pkey" PRIMARY KEY ("id_commentaire")
);

-- CreateTable
CREATE TABLE "signalement" (
    "id_signalement" SERIAL NOT NULL,
    "motif" "motif_signalement" NOT NULL,
    "description" VARCHAR(500),
    "statut" "statut_signalement" NOT NULL DEFAULT 'EN_ATTENTE',
    "date_signalement" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_traitement" TIMESTAMPTZ,
    "id_auteur" INTEGER NOT NULL,
    "id_spot" INTEGER,
    "id_commentaire" INTEGER,

    CONSTRAINT "signalement_pkey" PRIMARY KEY ("id_signalement")
);

-- CreateTable
CREATE TABLE "favori" (
    "id_utilisateur" INTEGER NOT NULL,
    "id_spot" INTEGER NOT NULL,
    "date_ajout" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "favori_pkey" PRIMARY KEY ("id_utilisateur","id_spot")
);

-- CreateTable
CREATE TABLE "note" (
    "id_utilisateur" INTEGER NOT NULL,
    "id_spot" INTEGER NOT NULL,
    "valeur" SMALLINT NOT NULL,
    "date_note" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "note_pkey" PRIMARY KEY ("id_utilisateur","id_spot")
);

-- CreateTable
CREATE TABLE "spot_tag" (
    "id_spot" INTEGER NOT NULL,
    "id_tag" INTEGER NOT NULL,

    CONSTRAINT "spot_tag_pkey" PRIMARY KEY ("id_spot","id_tag")
);

-- CreateIndex
CREATE UNIQUE INDEX "utilisateur_pseudo_key" ON "utilisateur"("pseudo");

-- CreateIndex
CREATE UNIQUE INDEX "utilisateur_email_key" ON "utilisateur"("email");

-- CreateIndex
CREATE UNIQUE INDEX "categorie_libelle_key" ON "categorie"("libelle");

-- CreateIndex
CREATE UNIQUE INDEX "tag_libelle_key" ON "tag"("libelle");

-- CreateIndex
CREATE INDEX "idx_spot_position" ON "spot"("latitude", "longitude");

-- CreateIndex
CREATE INDEX "idx_spot_categorie" ON "spot"("id_categorie");

-- CreateIndex
CREATE INDEX "idx_spot_createur" ON "spot"("id_createur");

-- CreateIndex
CREATE UNIQUE INDEX "photo_identifiant_media_key" ON "photo"("identifiant_media");

-- CreateIndex
CREATE UNIQUE INDEX "uq_photo_spot_ordre" ON "photo"("id_spot", "ordre");

-- CreateIndex
CREATE INDEX "idx_commentaire_spot" ON "commentaire"("id_spot");

-- CreateIndex
CREATE INDEX "idx_signalement_statut" ON "signalement"("statut");

-- CreateIndex
CREATE INDEX "idx_note_spot" ON "note"("id_spot");

-- CreateIndex
CREATE INDEX "idx_spot_tag_tag" ON "spot_tag"("id_tag");

-- AddForeignKey
ALTER TABLE "spot" ADD CONSTRAINT "spot_id_createur_fkey" FOREIGN KEY ("id_createur") REFERENCES "utilisateur"("id_utilisateur") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spot" ADD CONSTRAINT "spot_id_categorie_fkey" FOREIGN KEY ("id_categorie") REFERENCES "categorie"("id_categorie") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "photo" ADD CONSTRAINT "photo_id_spot_fkey" FOREIGN KEY ("id_spot") REFERENCES "spot"("id_spot") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "commentaire" ADD CONSTRAINT "commentaire_id_auteur_fkey" FOREIGN KEY ("id_auteur") REFERENCES "utilisateur"("id_utilisateur") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "commentaire" ADD CONSTRAINT "commentaire_id_spot_fkey" FOREIGN KEY ("id_spot") REFERENCES "spot"("id_spot") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "signalement" ADD CONSTRAINT "signalement_id_auteur_fkey" FOREIGN KEY ("id_auteur") REFERENCES "utilisateur"("id_utilisateur") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "signalement" ADD CONSTRAINT "signalement_id_spot_fkey" FOREIGN KEY ("id_spot") REFERENCES "spot"("id_spot") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "signalement" ADD CONSTRAINT "signalement_id_commentaire_fkey" FOREIGN KEY ("id_commentaire") REFERENCES "commentaire"("id_commentaire") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "favori" ADD CONSTRAINT "favori_id_utilisateur_fkey" FOREIGN KEY ("id_utilisateur") REFERENCES "utilisateur"("id_utilisateur") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "favori" ADD CONSTRAINT "favori_id_spot_fkey" FOREIGN KEY ("id_spot") REFERENCES "spot"("id_spot") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "note" ADD CONSTRAINT "note_id_utilisateur_fkey" FOREIGN KEY ("id_utilisateur") REFERENCES "utilisateur"("id_utilisateur") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "note" ADD CONSTRAINT "note_id_spot_fkey" FOREIGN KEY ("id_spot") REFERENCES "spot"("id_spot") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spot_tag" ADD CONSTRAINT "spot_tag_id_spot_fkey" FOREIGN KEY ("id_spot") REFERENCES "spot"("id_spot") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spot_tag" ADD CONSTRAINT "spot_tag_id_tag_fkey" FOREIGN KEY ("id_tag") REFERENCES "tag"("id_tag") ON DELETE CASCADE ON UPDATE CASCADE;

-- =====================================================================
-- Contraintes de vérification (CHECK) ajoutées à la main.
-- Prisma ne sait pas les déclarer dans le schéma : elles viennent du MPD
-- (docs/mpd.md, section 6) et protègent les données même en cas de bug de l'API.
-- =====================================================================

-- RG-02 : pseudo non vide
ALTER TABLE "utilisateur" ADD CONSTRAINT "ck_utilisateur_pseudo_non_vide" CHECK (btrim("pseudo") <> '');

-- RG-08 et RG-09 : durée positive, titre non vide, coordonnées GPS valides
ALTER TABLE "spot" ADD CONSTRAINT "ck_spot_titre_non_vide" CHECK (btrim("titre") <> '');
ALTER TABLE "spot" ADD CONSTRAINT "ck_spot_latitude" CHECK ("latitude" BETWEEN -90 AND 90);
ALTER TABLE "spot" ADD CONSTRAINT "ck_spot_longitude" CHECK ("longitude" BETWEEN -180 AND 180);
ALTER TABLE "spot" ADD CONSTRAINT "ck_spot_duree" CHECK ("duree_minutes" > 0);

-- RG-06 : position d'une photo entre 1 et 5
ALTER TABLE "photo" ADD CONSTRAINT "ck_photo_ordre" CHECK ("ordre" BETWEEN 1 AND 5);

-- RG-12 : note entre 1 et 5
ALTER TABLE "note" ADD CONSTRAINT "ck_note_valeur" CHECK ("valeur" BETWEEN 1 AND 5);

-- RG-13 : commentaire non vide
ALTER TABLE "commentaire" ADD CONSTRAINT "ck_commentaire_contenu_non_vide" CHECK (btrim("contenu") <> '');

-- RG-16 (D10) : un signalement vise exactement une cible, un spot ou un commentaire
ALTER TABLE "signalement" ADD CONSTRAINT "ck_signalement_une_cible" CHECK (num_nonnulls("id_spot", "id_commentaire") = 1);

-- RG-17 (D13) : la date de traitement est remplie si et seulement si le signalement est traité
ALTER TABLE "signalement" ADD CONSTRAINT "ck_signalement_date_traitement" CHECK (
    ("statut" = 'EN_ATTENTE' AND "date_traitement" IS NULL)
    OR ("statut" <> 'EN_ATTENTE' AND "date_traitement" IS NOT NULL)
);
