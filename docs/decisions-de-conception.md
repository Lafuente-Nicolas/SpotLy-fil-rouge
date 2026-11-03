# Décisions de conception — Spotly

Ce document consigne les décisions prises pour lever les incohérences entre les documents du projet (README, cahier des charges fonctionnel, backlog, cas d'utilisation). Il fait référence : en cas de contradiction, **c'est ce document qui s'applique**, et les autres documents doivent être alignés sur lui.

*Décisions validées le 9 octobre 2026.*

---

## D1 — Périmètre du MVP

**Décision :** le MVP correspond au backlog P1 (US-01 à US-09), complété par trois User Stories :

| US | Intitulé | Priorité |
|---|---|---|
| US-16 | Indiquer son temps disponible pour obtenir des spots compatibles | P1 — MVP |
| US-17 | Masquer un spot (administrateur) | P1 — MVP |
| US-18 | Gérer ses spots : modifier ou supprimer ses propres spots | P1 — MVP |

**Justification :**

- Le temps disponible est l'élément différenciant de Spotly. Il figure dans la problématique, les parcours et le diagramme UML, mais n'avait aucune User Story : il doit apparaître explicitement dans le MVP.
- Les spots étant publiés immédiatement, leur auteur doit pouvoir corriger une erreur (durée, position…) qui fausserait les résultats. US-18 a été ajoutée après la mise à jour des cas d'utilisation, qui prévoyaient ce cas sans User Story.
- La création de spots par la communauté fait partie du MVP. Il faut donc un moyen minimal de retirer un contenu problématique dès la première version, sans attendre le traitement complet des signalements (US-15, P3).

**Conséquence :** le premier périmètre du MVP, qui incluait le profil, les likes, les commentaires et la modération complète, a été remplacé par celui-ci dans le README et le cahier des charges fonctionnel.

---

## D2 — Appréciation des spots : notes, pas de likes

**Décision :** l'appréciation d'un spot se fait par une **note**, distincte du commentaire. Un utilisateur ne peut attribuer **qu'une seule note par spot** (il peut la modifier). Le commentaire reste facultatif et indépendant. **Les likes sont retirés du périmètre** et deviennent une évolution possible.

**Justification :**

- Une note (par exemple de 1 à 5) aide davantage à décider qu'un like, ce qui sert directement la proposition de valeur.
- Les favoris couvrent déjà le besoin de « garder » un spot. Likes, favoris et notes en même temps feraient trois mécanismes proches.
- Séparer la note du commentaire empêche de noter plusieurs fois le même spot en publiant plusieurs commentaires.

**Impact sur la modélisation :**

- **MCD :** association `NOTER` entre UTILISATEUR (0,n) et SPOT (0,n), porteuse des attributs `valeur` et `date_note`. Ce n'est pas une entité.
- **MLD :** table `NOTER` dont la clé primaire est composée de `(Id_UTILISATEUR, Id_SPOT)`, ce qui garantit l'unicité. Dans le MPD, elle devient la table `note`, de clé primaire `(id_utilisateur, id_spot)`.
- **MPD :** contrainte `CHECK (valeur BETWEEN 1 AND 5)`.

**Priorité :** US-11 reste en P2.

---

## D3 — Compte obligatoire pour utiliser l'application

**Décision :** toutes les fonctionnalités, y compris la consultation de la carte et des fiches, nécessitent d'être connecté. Il n'y a pas d'acteur « visiteur » dans les cas d'utilisation.

**Conséquences :**

- Les acteurs (3.2.4) et le parcours principal (3.4.1) ne prévoient aucun accès sans compte.
- Dans US-01, « En tant que visiteur » désigne simplement une personne pas encore inscrite.
- Côté API, toutes les routes sauf l'inscription et la connexion sont protégées par l'authentification.
- Une session persistante est nécessaire pour ne pas imposer une connexion à chaque ouverture. C'est déjà ce que prévoit l'analyse d'éco-conception.

---

## D4 — Publication immédiate, modération a posteriori

**Décision :** un spot créé est publié immédiatement. La modération intervient ensuite : l'administrateur peut masquer un spot (US-17), puis, à terme, traiter les signalements (US-12 et US-15).

**Justification :** cohérent avec la découverte spontanée et le fonctionnement communautaire. Une validation préalable imposerait un administrateur disponible en permanence dès le MVP.

**Conséquence :** il n'y a ni notification « Spot validé », ni étape de validation des contenus avant leur publication.

---

## D5 — Statuts d'un spot

**Décision :** trois statuts au MVP.

| Statut | Signification | Qui le déclenche | Visible publiquement |
|---|---|---|---|
| `PUBLIE` | Statut par défaut à la création | Le système | Oui |
| `MASQUE` | Retiré de la vue publique par la modération | Administrateur | Non |
| `SUPPRIME` | Suppression logique : la ligne est conservée mais invisible | Créateur ou administrateur | Non |

**Transitions autorisées :**

- `PUBLIE` → `MASQUE` (administrateur)
- `MASQUE` → `PUBLIE` (administrateur)
- `PUBLIE` ou `MASQUE` → `SUPPRIME` (créateur ou administrateur)

**Justification :**

- « Signalé » n'est pas un statut du spot : c'est une information déduite de l'existence de signalements.
- « Brouillon » et « Archivé » ne répondent à aucune User Story du MVP. Ils deviennent des évolutions.
- La suppression logique conserve la cohérence des données liées (notes, commentaires, signalements) et garde une trace utile à la modération.

**RGPD :** la suppression d'un compte supprime physiquement tous ses contenus, y compris ceux supprimés logiquement (voir D21).

**Impact MPD :** type énuméré PostgreSQL `statut_publication` (`enum` Prisma), partagé avec les commentaires (D12), valeur par défaut `PUBLIE`.

---

## D6 — Catégories, tags et préférences

**Décision :**

- **Catégorie :** chaque spot a **une seule catégorie principale**, choisie dans une liste gérée par l'administrateur. Les doublons de sens des premières listes (« vue » et « sunset », « balade » et « randonnée ») ont été supprimés (voir D16).
- **Tags :** un spot peut avoir plusieurs tags, choisis dans une **liste contrôlée**. Un tag précise le spot (gratuit, wifi, accessible à pied, coucher de soleil…) sans le classer.
- **Préférences utilisateur** (aventure, food, culture, nature, détente, coworking) : **hors MVP**. Elles seront stockées plus tard. La piste envisagée est une relation entre l'utilisateur et des catégories.

**Justification :** trois systèmes de classement qui se recoupent compliquent la saisie, les filtres et le modèle. Une catégorie sert à classer et à choisir le marqueur ; les tags servent à affiner.

---

## D7 — Photos

**Décision :** **au moins une photo obligatoire** à la création d'un spot, **cinq au maximum**.

**Justification :**

- Les photos authentiques sont un élément clé pour décider rapidement si un spot convient.
- Le plafond limite le volume stocké et transféré : c'est un argument d'éco-conception mesurable.

**Conséquences :**

- Le flux d'upload vers Cloudinary fait partie du MVP (US-07).
- La validation porte sur le type, le poids et le nombre de fichiers. Elle est faite côté serveur et doublée côté client.
- **MCD :** cardinalité SPOT (1,n) — PHOTO (1,1). Le minimum de 1 et le maximum de 5 sont des règles de gestion contrôlées par le backend : une base relationnelle ne les garantit pas seule.

---

## D8 — Gestion des comptes au MVP

**Décision :** le MVP comprend l'**inscription**, la **connexion** et la **déconnexion**.

La réinitialisation du mot de passe, la vérification de l'adresse e-mail, la modification du profil (US-14) et la suppression du compte deviennent des évolutions.

**Justification :** la vérification d'e-mail et la réinitialisation du mot de passe nécessitent un service d'envoi d'e-mails, donc une dépendance et une configuration supplémentaires. Elles n'apportent rien à la proposition de valeur principale.

**Conséquence :** la vérification de l'adresse e-mail à l'inscription est une évolution. La règle « un seul compte par adresse e-mail » est conservée (contrainte d'unicité).

---

## D9 — Stockage des durées

**Décision :** la durée estimée d'un spot est stockée sous forme d'un **entier en minutes** (`duree_minutes`). Les paliers 30 min, 1 h, 2 h, demi-journée (240 min) et journée (480 min) sont des valeurs proposées dans l'interface, pas des libellés stockés.

**Justification :** la comparaison avec le temps disponible devient une simple condition (`duree_minutes <= temps_disponible`). Les paliers peuvent évoluer sans migration de la base.

**Impact MPD :** `CHECK (duree_minutes > 0)`.

---

## D10 — Cible d'un signalement

**Décision :** la table `signalement` possède deux clés étrangères facultatives, `id_spot` et `id_commentaire`. Exactement une des deux doit être renseignée.

**Garanties :**

- **Base de données :** une contrainte `CHECK` vérifie qu'une seule des deux colonnes est remplie. Prisma ne sait pas déclarer ce type de contrainte : elle sera ajoutée à la main dans la migration SQL.
- **Backend :** la même règle est vérifiée lors de la validation de la requête, pour renvoyer un message d'erreur clair.

**Priorité :** US-12 reste en P2. La décision est prise dès maintenant pour que le MCD soit complet.

---

## D11 — Pseudo unique

**Décision :** chaque utilisateur choisit un **pseudo**, unique, affiché comme auteur de ses spots et de ses commentaires.

**Justification :** il permet d'identifier l'auteur d'un contenu sans exposer son adresse e-mail. L'unicité évite les confusions entre deux auteurs.

---

## D12 — Statut des commentaires

**Décision :** un commentaire a les mêmes statuts qu'un spot : `PUBLIE`, `MASQUE` (par un administrateur) et `SUPPRIME` (suppression logique par son auteur ou un administrateur).

**Justification :** le traitement des signalements (US-15) prévoit de masquer un commentaire signalé, ce qui nécessite un statut. Utiliser les mêmes valeurs que pour les spots garde un modèle homogène.

---

## D13 — Traitement des signalements

**Décision :** un signalement a un statut `EN_ATTENTE`, `TRAITE` ou `CLASSE_SANS_SUITE`, et une date de traitement.

**Justification :** US-15 prévoit de masquer le contenu ou de classer le signalement sans suite. Enregistrer l'administrateur qui a traité le signalement n'est pas retenu, pour garder un modèle simple. Cela pourra être ajouté plus tard si un suivi plus précis est nécessaire.

---

## D14 — Adresse et conseil d'un spot

**Décision :** un spot peut avoir une **adresse** et un **conseil** pratique, tous deux facultatifs. Les horaires et les conditions d'accès restent des évolutions.

**Justification :** la maquette affiche l'adresse du spot et des conseils de la communauté. L'adresse est plus lisible que des coordonnées GPS. Un seul champ « conseil » couvre l'essentiel sans alourdir le formulaire.

---

## D15 — Informations du profil

**Décision :** le profil peut contenir un **prénom**, un **nom**, une **ville** et une **photo de profil**, tous facultatifs. Seuls le pseudo, l'e-mail et le mot de passe sont demandés à l'inscription. La date d'acceptation des conditions d'utilisation est enregistrée.

**Justification :** la maquette du profil affiche ces informations. Les rendre facultatives respecte le principe de minimisation des données du RGPD : l'utilisateur choisit ce qu'il partage.

---

## D16 — Liste des catégories

**Décision :** dix catégories sont retenues : Café, Coworking, Restauration, Bar et rooftop, Point de vue, Plage et baignade, Nature et randonnée, Culture et patrimoine, Marché, Activité.

**Justification :** cette liste couvre les besoins des personas (par exemple les cafés et coworkings pour les digital nomads) et supprime les doublons des premières listes (« vue » et « sunset », « balade » et « randonnée »).

---

## D17 — Charte graphique de référence

**Décision :** la charte de la maquette fait référence : police **Poppins**, couleurs Dark Teal `#0F4C5C`, Coral Glow `#FF7F50`, Muted Teal `#7A9E7E`, Carbon Black `#1E1E1E`, blanc et gris clair `#F5F5F5`. Les nuances intermédiaires sont des opacités de ces couleurs.

**Justification :** les premiers documents citaient Inter et d'autres noms de couleurs. La maquette, plus récente et plus aboutie, est retenue pour que le dossier, la maquette et le code utilisent la même charte.

---

## D18 — Bouton « Partager »

**Décision :** le bouton « Partager » reste visible sur la fiche d'un spot dans la maquette, mais le partage n'est pas dans le backlog du MVP. Il sera développé en évolution.

**Justification :** il fait partie de l'expérience envisagée et ne nécessite aucune donnée en base (partage du lien de la fiche). Il n'a donc aucun impact sur le MCD.

---

## D19 — Type des identifiants

**Décision :** chaque table a un identifiant **entier auto-incrémenté** (`INTEGER GENERATED ALWAYS AS IDENTITY`, `@default(autoincrement())` avec Prisma).

**Justification :** il est simple, léger (4 octets contre 16 pour un UUID) et lisible pendant le développement. Le risque qu'un identifiant soit deviné dans une URL est couvert par les contrôles d'accès de l'API : connaître le numéro d'un spot ne donne aucun droit dessus.

---

## D20 — Stockage de la position des spots

**Décision :** deux colonnes `latitude` et `longitude` de type `DECIMAL(9,6)`, avec un index sur ce couple. PostGIS n'est pas utilisé au MVP.

**Justification :** la carte affiche les spots d'une zone rectangulaire : une simple recherche entre deux latitudes et deux longitudes suffit. La distance précise peut être calculée par l'API. Prisma gère mal PostGIS, ce qui compliquerait le code pour un gain inutile au MVP.

---

## D21 — Suppression d'un compte

**Décision :** la suppression d'un compte supprime **en cascade** tout ce qui lui est lié : spots (avec leurs photos, commentaires, notes, favoris et signalements), commentaires, notes, favoris et signalements de l'utilisateur. Une catégorie utilisée par un spot ne peut pas être supprimée (`RESTRICT`).

**Justification :** cela répond simplement au droit à l'effacement du RGPD, et règle le point laissé ouvert en D5. Avant la suppression, l'API supprime les images correspondantes sur Cloudinary.

**Priorité :** la fonctionnalité « Supprimer son compte » est une évolution. Cette décision fixe dès maintenant son effet sur la base de données, pour que le MPD soit complet.

---

## Points techniques restant à décider

Ces choix ne changent pas le périmètre fonctionnel. Ils seront tranchés avec le cahier des charges technique.

| Sujet | Question |
|---|---|
| Tuiles cartographiques | Quel fournisseur de tuiles pour MapLibre ? Impact élevé selon l'analyse éco. |
| Géocodage | Quel service pour la recherche manuelle d'un lieu (repli si la géolocalisation est refusée) ? |
| Authentification | Session avec cookie `httpOnly` ou jeton JWT ? |
| Validation serveur | Quelle librairie de validation des entrées ? |
| Mesure éco | Quels outils et quelles mesures avant/après (EcoIndex, Lighthouse, onglet Réseau) ? |
| Règles floues du README | Critère de détection d'un spot en doublon ; seuil de masquage automatique après signalements. |

---

## Récapitulatif du backlog après décisions

| Priorité | User Stories |
|---|---|
| **P1 — MVP** | US-01 à US-09, US-16 (temps disponible), US-17 (masquer un spot), US-18 (gérer ses spots) |
| **P2** | US-10 commenter, US-11 noter, US-12 signaler, US-13 consulter son profil |
| **P3** | US-14 modifier son profil, US-15 traiter les signalements |
| **Évolutions** | Likes, préférences, brouillon/archivage, vérification e-mail, mot de passe oublié, suppression de compte, suspension de compte, partage de spots, notifications, offre professionnelle |
