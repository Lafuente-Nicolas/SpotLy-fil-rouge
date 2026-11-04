# Modèle Physique de Données (MPD) — Spotly

## 1. Objectif

Le MPD est la dernière étape de la méthode Merise. Il adapte le [MLD](mld.md) au logiciel de base de données choisi, ici **PostgreSQL**. Il précise ce que le MLD laissait ouvert :

- le **type** exact de chaque colonne ;
- les **contraintes** : colonnes obligatoires, valeurs uniques, vérifications (`CHECK`) ;
- les **valeurs par défaut** ;
- les **règles de suppression** (`ON DELETE`) ;
- les **index**.

Le MPD est livré sous la forme d'un script SQL exécutable : [`sql/mpd-spotly.sql`](sql/mpd-spotly.sql). Ce document explique chaque choix du script.

> Dans le projet, les tables sont créées par les **migrations Prisma** (voir section 12). Le schéma Prisma reproduit exactement ce MPD. Les contraintes `CHECK`, que Prisma ne sait pas écrire (voir section 6), sont ajoutées à la main dans la migration.

---

## 2. Choix structurants

| Question | Choix | Justification |
| --- | --- | --- |
| Type des identifiants | **Nombre entier auto-incrémenté** (`INTEGER GENERATED ALWAYS AS IDENTITY`) | Simple, léger (4 octets contre 16 pour un UUID) et lisible. PostgreSQL attribue lui-même le numéro suivant. |
| Position des spots | **Deux colonnes décimales** `latitude` et `longitude` + un index | Suffisant pour afficher les spots d'une zone de carte. Bien géré par Prisma, contrairement à l'extension PostGIS. |
| Suppression d'un compte | **Suppression en cascade** de tout son contenu | Répond au droit à l'effacement du RGPD : aucune donnée liée à la personne ne reste en base. |
| Listes de valeurs (rôle, statuts, motifs) | **Types énumérés** PostgreSQL (`ENUM`) | La base refuse toute valeur hors de la liste. Prisma les gère nativement (`enum`). |

Les trois premiers choix sont enregistrés dans les [décisions de conception](decisions-de-conception.md) (D19 à D21).

---

## 3. Passage du MLD au MPD : le nommage

Le MLD gardait les noms générés par Looping. Le MPD les adapte aux conventions de PostgreSQL :

- **tout en minuscules**, mots séparés par `_` ;
- un nom de table **au singulier** ;
- des clés étrangères qui indiquent le **rôle** de l'utilisateur.

| MLD (Looping) | MPD (PostgreSQL) |
| --- | --- |
| UTILISATEUR, SPOT, CATEGORIE… | utilisateur, spot, categorie… |
| Id_SPOT, Id_TAG… | id_spot, id_tag… |
| SPOT.Id_UTILISATEUR | spot.**id_createur** |
| COMMENTAIRE.Id_UTILISATEUR | commentaire.**id_auteur** |
| SIGNALEMENT.Id_UTILISATEUR | signalement.**id_auteur** |
| METTRE_EN_FAVORI | **favori** |
| NOTER | **note** |
| ETIQUETER | **spot_tag** |

Les tables, les clés et les liens restent strictement les mêmes que dans le MLD.

Les contraintes portent aussi un nom, pour que les messages d'erreur soient compréhensibles :

- `pk_` : clé primaire ;
- `fk_` : clé étrangère ;
- `uq_` : unicité ;
- `ck_` : vérification ;
- `idx_` : index.

---

## 4. Les types utilisés

| Type dans le MCD | Type PostgreSQL | Pourquoi |
| --- | --- | --- |
| Identifiant | `INTEGER GENERATED ALWAYS AS IDENTITY` | Numéro unique attribué automatiquement |
| Texte (n) | `VARCHAR(n)` | Longueur maximale imposée par la base |
| Texte long | `TEXT` | Longueur libre : la description d'un spot |
| Décimal (GPS) | `DECIMAL(9,6)` | Valeur **exacte** à 6 décimales, soit environ 10 cm de précision. Un nombre à virgule flottante (`FLOAT`) pourrait arrondir. |
| Petit entier | `SMALLINT` | Pour la note (1 à 5), l'ordre des photos (1 à 5) et la durée en minutes. Prend 2 octets au lieu de 4. |
| Date et heure | `TIMESTAMPTZ` | Date et heure **avec fuseau horaire** : pas d'erreur d'une heure lors du changement d'heure |
| Liste de valeurs | type `ENUM` | Seules les valeurs prévues sont acceptées |

**Le mot de passe** est stocké dans un `VARCHAR(255)`. On n'y enregistre jamais le mot de passe lui-même, mais son **empreinte** (hash) calculée par le backend, par exemple avec bcrypt ou Argon2.

### Les types énumérés

| Type | Valeurs | Utilisé par |
| --- | --- | --- |
| `role_utilisateur` | `UTILISATEUR`, `ADMINISTRATEUR` | utilisateur.role |
| `statut_publication` | `PUBLIE`, `MASQUE`, `SUPPRIME` | spot.statut et commentaire.statut (D5, D12) |
| `motif_signalement` | `CONTENU_INAPPROPRIE`, `INFORMATION_INCORRECTE`, `SPAM`, `SPOT_INEXISTANT`, `AUTRE` | signalement.motif |
| `statut_signalement` | `EN_ATTENTE`, `TRAITE`, `CLASSE_SANS_SUITE` | signalement.statut (D13) |

Les spots et les commentaires ont les mêmes statuts. Ils partagent donc **un seul type**, `statut_publication`.

---

## 5. Description des tables

Abréviations : **PK** clé primaire, **FK** clé étrangère, **NN** obligatoire (`NOT NULL`), **UQ** unique.

### utilisateur

| Colonne | Type | Contraintes | Défaut |
| --- | --- | --- | --- |
| id_utilisateur | INTEGER | PK | auto |
| pseudo | VARCHAR(30) | NN, UQ, non vide | |
| email | VARCHAR(255) | NN, UQ | |
| mot_de_passe | VARCHAR(255) | NN | |
| prenom | VARCHAR(50) | | |
| nom | VARCHAR(50) | | |
| ville | VARCHAR(100) | | |
| photo_profil | VARCHAR(500) | | |
| role | role_utilisateur | NN | `UTILISATEUR` |
| date_inscription | TIMESTAMPTZ | NN | date du jour |
| date_acceptation_cgu | TIMESTAMPTZ | NN | |

`date_acceptation_cgu` n'a pas de valeur par défaut. Le backend doit l'envoyer explicitement, ce qui prouve que la case a bien été cochée.

### categorie

| Colonne | Type | Contraintes |
| --- | --- | --- |
| id_categorie | INTEGER | PK |
| libelle | VARCHAR(50) | NN, UQ |
| icone | VARCHAR(50) | NN |

Les 10 catégories (D16) sont insérées à la fin du script, car l'application ne fonctionne pas sans elles.

### tag

| Colonne | Type | Contraintes |
| --- | --- | --- |
| id_tag | INTEGER | PK |
| libelle | VARCHAR(50) | NN, UQ |

### spot

| Colonne | Type | Contraintes | Défaut |
| --- | --- | --- | --- |
| id_spot | INTEGER | PK | auto |
| titre | VARCHAR(100) | NN, non vide | |
| description | TEXT | NN | |
| latitude | DECIMAL(9,6) | NN, entre -90 et 90 | |
| longitude | DECIMAL(9,6) | NN, entre -180 et 180 | |
| adresse | VARCHAR(255) | | |
| duree_minutes | SMALLINT | NN, > 0 | |
| conseil | VARCHAR(300) | | |
| statut | statut_publication | NN | `PUBLIE` |
| date_creation | TIMESTAMPTZ | NN | date du jour |
| date_modification | TIMESTAMPTZ | NN | date du jour |
| id_createur | INTEGER | NN, FK → utilisateur | |
| id_categorie | INTEGER | NN, FK → categorie | |

Avec Prisma, `date_modification` sera mise à jour automatiquement à chaque modification (`@updatedAt`).

### photo

| Colonne | Type | Contraintes | Défaut |
| --- | --- | --- | --- |
| id_photo | INTEGER | PK | auto |
| url | VARCHAR(500) | NN | |
| identifiant_media | VARCHAR(255) | NN, UQ | |
| texte_alternatif | VARCHAR(150) | | |
| ordre | SMALLINT | NN, de 1 à 5 | |
| date_ajout | TIMESTAMPTZ | NN | date du jour |
| id_spot | INTEGER | NN, FK → spot | |

Le couple (id_spot, ordre) est unique : deux photos d'un même spot ne peuvent pas avoir la même position.

### commentaire

| Colonne | Type | Contraintes | Défaut |
| --- | --- | --- | --- |
| id_commentaire | INTEGER | PK | auto |
| contenu | VARCHAR(1000) | NN, non vide | |
| statut | statut_publication | NN | `PUBLIE` |
| date_publication | TIMESTAMPTZ | NN | date du jour |
| id_auteur | INTEGER | NN, FK → utilisateur | |
| id_spot | INTEGER | NN, FK → spot | |

### signalement

| Colonne | Type | Contraintes | Défaut |
| --- | --- | --- | --- |
| id_signalement | INTEGER | PK | auto |
| motif | motif_signalement | NN | |
| description | VARCHAR(500) | | |
| statut | statut_signalement | NN | `EN_ATTENTE` |
| date_signalement | TIMESTAMPTZ | NN | date du jour |
| date_traitement | TIMESTAMPTZ | voir section 6 | |
| id_auteur | INTEGER | NN, FK → utilisateur | |
| id_spot | INTEGER | FK → spot, **facultatif** | |
| id_commentaire | INTEGER | FK → commentaire, **facultatif** | |

### favori, note, spot_tag

| Table | Colonnes | Clé primaire composée | Particularité |
| --- | --- | --- | --- |
| favori | id_utilisateur, id_spot, date_ajout | (id_utilisateur, id_spot) | date_ajout = date du jour par défaut |
| note | id_utilisateur, id_spot, valeur, date_note | (id_utilisateur, id_spot) | valeur SMALLINT entre 1 et 5 |
| spot_tag | id_spot, id_tag | (id_spot, id_tag) | |

---

## 6. Les contraintes de vérification (`CHECK`)

Une contrainte `CHECK` fait refuser par la base une ligne qui ne respecte pas une règle de gestion. Même si le backend contient un bug, la donnée reste juste.

| Contrainte | Table | Règle | RG |
| --- | --- | --- | --- |
| ck_spot_latitude | spot | latitude entre -90 et 90 | RG-09 |
| ck_spot_longitude | spot | longitude entre -180 et 180 | RG-09 |
| ck_spot_duree | spot | duree_minutes > 0 | RG-08 |
| ck_spot_titre_non_vide | spot | titre différent d'une suite d'espaces | |
| ck_photo_ordre | photo | ordre entre 1 et 5 | RG-06 |
| ck_note_valeur | note | valeur entre 1 et 5 | RG-12 |
| ck_commentaire_contenu_non_vide | commentaire | contenu non vide | RG-13 |
| ck_utilisateur_pseudo_non_vide | utilisateur | pseudo non vide | RG-02 |
| **ck_signalement_une_cible** | signalement | exactement une des deux colonnes id_spot et id_commentaire est remplie | RG-16, D10 |
| **ck_signalement_date_traitement** | signalement | date_traitement est vide tant que le statut vaut `EN_ATTENTE`, et remplie sinon | RG-17, D13 |

Prisma ne sait déclarer **aucune** contrainte `CHECK` dans son schéma. Les dix contraintes ci-dessus sont donc ajoutées à la main à la fin du fichier SQL de la première migration (`backend/prisma/migrations/…_init/migration.sql`). Les deux contraintes **en gras** sont les plus importantes, car elles portent des règles que les cardinalités du MCD ne pouvaient pas exprimer.

`ck_signalement_une_cible` utilise la fonction `num_nonnulls(id_spot, id_commentaire)`. Elle compte les valeurs non vides, et la contrainte impose que ce nombre soit égal à 1.

---

## 7. Les règles de suppression (`ON DELETE`)

Ces règles indiquent à PostgreSQL ce qu'il doit faire des lignes liées quand une ligne est supprimée **physiquement**. Rappel : un spot ou un commentaire supprimé par son auteur est d'abord supprimé **logiquement** (statut `SUPPRIME`, D5). La suppression physique n'arrive donc que lors de la suppression d'un compte, ou d'un nettoyage par un administrateur.

| Clé étrangère | Règle | Effet |
| --- | --- | --- |
| spot.id_createur | `CASCADE` | Supprimer un utilisateur supprime ses spots. |
| commentaire.id_auteur | `CASCADE` | … et ses commentaires. |
| signalement.id_auteur | `CASCADE` | … et ses signalements. |
| favori.id_utilisateur, note.id_utilisateur | `CASCADE` | … et ses favoris et ses notes. |
| photo.id_spot | `CASCADE` | Supprimer un spot supprime ses photos. |
| commentaire.id_spot | `CASCADE` | … ses commentaires. |
| favori.id_spot, note.id_spot, spot_tag.id_spot | `CASCADE` | … ses favoris, notes et tags associés. |
| signalement.id_spot, signalement.id_commentaire | `CASCADE` | Un signalement disparaît avec le contenu qu'il vise. |
| spot_tag.id_tag | `CASCADE` | Supprimer un tag le retire des spots, sans supprimer les spots. |
| spot.id_categorie | **`RESTRICT`** | Une catégorie utilisée par au moins un spot **ne peut pas** être supprimée. |

**Exemple :** quand un utilisateur supprime son compte, PostgreSQL supprime en une seule opération :
- ses spots, puis, par cascade, leurs photos, commentaires, notes, favoris et signalements ;
- ses propres commentaires, notes, favoris et signalements sur les spots des autres.

**Limite :** les images sont stockées sur **Cloudinary**, pas dans la base. Avant de supprimer un compte ou un spot, le backend doit supprimer les images sur Cloudinary grâce à `identifiant_media`. Sinon, elles resteraient stockées inutilement, ce qui va contre l'éco-conception et le RGPD.

---

## 8. Les index

Un index fonctionne comme le sommaire d'un livre. PostgreSQL trouve les lignes recherchées sans parcourir toute la table.

PostgreSQL crée déjà automatiquement un index pour chaque **clé primaire** et chaque colonne **unique**. Le script ajoute ceux qui correspondent aux recherches les plus fréquentes :

| Index | Colonnes | Recherche accélérée |
| --- | --- | --- |
| idx_spot_position | spot (latitude, longitude) | Spots visibles dans la zone de la carte (US-03, US-04) |
| idx_spot_categorie | spot (id_categorie) | Filtre par catégorie (US-05) |
| idx_spot_createur | spot (id_createur) | « Mes spots » sur le profil |
| idx_commentaire_spot | commentaire (id_spot) | Commentaires affichés sur la fiche d'un spot |
| idx_note_spot | note (id_spot) | Calcul de la note moyenne d'un spot |
| idx_spot_tag_tag | spot_tag (id_tag) | Filtre par tag |
| idx_signalement_statut | signalement (statut) | Liste des signalements en attente (US-15) |

Tous les index ne sont pas nécessaires. Par exemple, les favoris d'un utilisateur sont déjà trouvés rapidement grâce à la clé primaire (id_utilisateur, id_spot), qui commence par id_utilisateur. On n'en ajoute pas, car chaque index occupe de la place et ralentit un peu les écritures.

---

## 9. Ce que fait l'éco-conception dans le MPD

- **Des types au plus juste** : `SMALLINT` pour les petites valeurs, `INTEGER` plutôt qu'un UUID, `VARCHAR(n)` limité. La base est plus petite, donc moins de stockage et de mémoire.
- **Aucune image dans la base** : seules l'adresse et l'identifiant Cloudinary sont enregistrés. Les images sont optimisées et servies par Cloudinary.
- **Des index ciblés** : les recherches fréquentes coûtent moins de calcul au serveur, sans ajouter d'index inutiles.
- **Un maximum de 5 photos** par spot, vérifié par l'API (RG-06).
- **Pas de donnée en double** : la note moyenne n'est pas stockée, elle est calculée à partir de la table `note`.

---

## 10. Règles qui restent à vérifier par l'API

Certaines règles ne peuvent pas être garanties par la base seule. Le backend les contrôle :

| Règle | Pourquoi pas dans la base |
| --- | --- |
| Entre 1 et 5 photos par spot (RG-06) | Une contrainte `CHECK` ne voit qu'une ligne à la fois, pas le nombre de photos d'un spot. |
| Mot de passe d'au moins 12 caractères | La base ne reçoit que l'empreinte, jamais le mot de passe. |
| Format de l'adresse e-mail | Vérifié lors de la validation du formulaire. |
| Unicité de l'e-mail sans tenir compte des majuscules | L'API enregistre l'e-mail en minuscules. |
| Droits : seul l'auteur modifie son contenu, seul un administrateur masque ou traite | Ce sont des règles d'accès, pas de structure. |

---

## 11. Table technique des sessions

L'authentification par session (décision D23) ajoute une table `session`, créée et gérée par la bibliothèque `connect-pg-simple` :

| Colonne | Contenu |
| --- | --- |
| sid | Identifiant de la session (celui du cookie) |
| sess | Données de la session, dont l'identifiant de l'utilisateur connecté |
| expire | Date d'expiration, avec un index pour supprimer les sessions expirées |

Cette table ne fait pas partie du modèle métier : elle n'apparaît ni dans le MCD ni dans le MLD, et elle n'est pas décrite dans le schéma Prisma. Comme elle n'a pas de clé étrangère vers `utilisateur`, l'API supprime elle-même les sessions d'un utilisateur lorsque son compte est supprimé.

---

## 12. Le schéma Prisma

Le MPD est traduit dans le fichier [`backend/prisma/schema.prisma`](../backend/prisma/schema.prisma). La correspondance est directe :

- une table devient un `model` ;
- un type énuméré devient un `enum` ;
- les colonnes ont un nom en camelCase côté TypeScript (`dureeMinutes`), relié au nom PostgreSQL du MPD (`duree_minutes`) par `@map`. Les tables sont reliées par `@@map`.

Pour les identifiants, Prisma (`@default(autoincrement())`) écrit `SERIAL`. C'est l'ancienne écriture PostgreSQL du même mécanisme : un nombre attribué automatiquement.

**Création de la base, en trois étapes :**

1. `npx prisma migrate dev --create-only --name init` génère le SQL de la première migration, sans l'appliquer ;
2. les dix contraintes `CHECK` de la section 6 sont ajoutées à la main à la fin de ce fichier ;
3. `npx prisma migrate dev` applique la migration, puis `npx prisma db seed` insère les 10 catégories et les tags.

**Vérification :** insérer une note de 6 est refusé par la base (`violates check constraint "ck_note_valeur"`).
