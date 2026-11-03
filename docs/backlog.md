# Gestion du backlog — Spotly

## 1. Objectif

Le backlog de Spotly permet de recenser et de prioriser les fonctionnalités nécessaires au développement de l'application.

Chaque fonctionnalité est représentée sous la forme d'une **User Story**, afin de se concentrer sur le besoin de l'utilisateur et la valeur apportée par la fonctionnalité.

Le suivi du projet est réalisé avec **Trello**, sous la forme d'un tableau Kanban.

Le périmètre et les priorités de ce backlog sont alignés sur le document [Décisions de conception](decisions-de-conception.md).

### Organisation du tableau

- **Backlog** : fonctionnalités identifiées mais pas encore planifiées.
- **À faire** : fonctionnalités sélectionnées pour être développées.
- **En cours** : fonctionnalités actuellement développées.
- **En test** : fonctionnalités développées en cours de vérification.
- **Terminé** : fonctionnalités validées.

---

## 2. Organisation des fonctionnalités

Les User Stories sont regroupées en **6 Epics** représentant les principaux domaines fonctionnels de Spotly.

| Epic | Description |
|---|---|
| Authentification | Gestion des comptes et de la connexion |
| Découverte | Recherche et découverte des spots selon la position et le temps disponible |
| Gestion des spots | Consultation et ajout de spots |
| Interactions | Favoris, commentaires, notes et signalements |
| Profil utilisateur | Consultation et modification du profil |
| Administration | Modération des contenus et traitement des signalements |

### Numérotation

Les identifiants des User Stories sont **stables** : une User Story ajoutée en cours de projet reçoit le numéro suivant, même si elle est rangée dans un Epic placé plus haut. C'est le cas de US-16, US-17 et US-18. Cela évite de casser les références dans Trello et dans les autres documents du projet.

### Rappel : utilisation de Spotly avec un compte

L'utilisation de Spotly nécessite un compte, y compris pour consulter la carte. Seules l'inscription et la connexion sont accessibles sans être connecté.

---

## 3. User Stories

Chaque User Story possède des critères d'acceptation. Ceux des User Stories P2 et P3 seront précisés lorsqu'elles seront planifiées.

## Epic 1 — Authentification

### US-01 — Créer un compte

> En tant que visiteur, je souhaite créer un compte Spotly, afin d'accéder à la découverte des spots, d'enregistrer mes favoris et de contribuer à la communauté.

**Priorité : P1 — MVP**

**Critères d'acceptation :**

- Étant donné que je ne suis pas inscrit, quand je renseigne un pseudo, une adresse e-mail et un mot de passe valides et que j'accepte les conditions d'utilisation, alors mon compte est créé, un message confirme la création et je peux me connecter.
- Je ne peux pas créer de compte sans accepter les conditions d'utilisation.
- Étant donné qu'une adresse e-mail est déjà utilisée par un compte, quand je tente de m'inscrire avec cette adresse, alors l'inscription est refusée avec un message explicite.
- Étant donné qu'un pseudo est déjà utilisé par un compte, quand je tente de m'inscrire avec ce pseudo, alors l'inscription est refusée avec un message explicite.
- Étant donné que mon mot de passe ne respecte pas les règles de sécurité (au moins 12 caractères), quand je valide le formulaire, alors l'inscription est refusée et la règle à respecter m'est indiquée.
- Le mot de passe n'est jamais stocké en clair : il est haché côté serveur.
- Toutes les règles de validation sont vérifiées par l'API, même si elles le sont déjà dans le formulaire.

### US-02 — Se connecter

> En tant qu'utilisateur, je souhaite me connecter à mon compte, afin de retrouver mes favoris et mes contributions.

**Priorité : P1 — MVP**

**Critères d'acceptation :**

- Étant donné que je possède un compte, quand je saisis une adresse e-mail et un mot de passe corrects, alors je suis connecté et redirigé vers la carte.
- Étant donné que l'adresse e-mail ou le mot de passe est incorrect, quand je valide, alors un message générique s'affiche, sans indiquer lequel des deux champs est faux.
- Étant donné que je suis connecté, quand je rouvre l'application plus tard, alors ma session est conservée tant qu'elle n'a pas expiré.
- Étant donné que je suis connecté, quand je me déconnecte, alors ma session est fermée et je reviens à l'écran de connexion.
- Les tentatives de connexion répétées depuis une même origine sont limitées.

---

## Epic 2 — Découverte

### US-03 — Voir les spots sur une carte

> En tant qu'utilisateur connecté, je souhaite voir les spots autour de moi sur une carte, afin de découvrir rapidement les lieux intéressants à proximité.

**Priorité : P1 — MVP**

**Critères d'acceptation :**

- Étant donné que j'autorise la géolocalisation, quand la carte s'affiche, alors elle est centrée sur ma position.
- Étant donné que je refuse la géolocalisation ou qu'elle est indisponible, quand la carte s'affiche, alors je peux rechercher une zone manuellement (voir US-04).
- Seuls les spots situés dans la zone visible de la carte sont chargés depuis l'API. Un déplacement ou un zoom déclenche le chargement de la nouvelle zone.
- Quand je sélectionne un marqueur, un aperçu du spot s'affiche (titre, catégorie, durée, photo) avec un accès à sa fiche complète.
- Les spots proches les uns des autres sont regroupés (clustering) et le nombre de spots du groupe est affiché.
- Seuls les spots au statut `PUBLIE` sont affichés.
- Étant donné qu'aucun spot n'existe dans la zone, quand la carte est chargée, alors un message m'invite à déplacer la carte ou à élargir ma recherche.

### US-04 — Rechercher un spot ou une zone

> En tant qu'utilisateur connecté, je souhaite rechercher un lieu ou une activité, afin de trouver rapidement un spot correspondant à mon besoin, même sans utiliser ma géolocalisation.

**Priorité : P1 — MVP**

**Critères d'acceptation :**

- Étant donné que je saisis un mot-clé, quand je lance la recherche, alors les spots dont le titre ou la description contient ce mot-clé sont affichés.
- Étant donné que je saisis le nom d'une ville ou d'une adresse, quand je valide, alors la carte se recentre sur cette zone et affiche ses spots.
- Étant donné qu'aucun résultat ne correspond, quand la recherche se termine, alors un message l'indique et me propose de modifier ma recherche.
- La saisie ne déclenche pas une requête à chaque caractère : la recherche part à la validation ou après une courte pause de saisie.

### US-05 — Filtrer les spots

> En tant qu'utilisateur connecté, je souhaite filtrer les spots par catégorie, tags et distance, afin d'afficher uniquement les lieux qui m'intéressent.

**Priorité : P1 — MVP**

**Critères d'acceptation :**

- Je peux filtrer par catégorie, par un ou plusieurs tags et par distance maximale depuis ma position ou la zone recherchée.
- Les filtres sont combinables entre eux et avec le temps disponible (US-16).
- Quand je modifie un filtre, les résultats de la carte sont mis à jour sans recharger la page.
- Je peux réinitialiser tous les filtres en une seule action.
- Les filtres actifs restent visibles à l'écran.

### US-16 — Indiquer son temps disponible

> En tant qu'utilisateur connecté, je souhaite indiquer le temps dont je dispose, afin de ne voir que des spots que j'ai le temps de découvrir.

**Priorité : P1 — MVP**

**Critères d'acceptation :**

- Je peux choisir mon temps disponible parmi des valeurs proposées : 30 min, 1 h, 2 h, demi-journée, journée.
- Étant donné que j'ai indiqué un temps disponible, quand les résultats s'affichent, alors seuls les spots dont la durée estimée est inférieure ou égale à ce temps sont proposés.
- Le temps disponible sélectionné est visible en permanence sur l'écran de la carte et modifiable en une action.
- Je peux retirer ce critère pour afficher tous les spots, quelle que soit leur durée.
- Étant donné qu'aucun spot ne correspond à mon temps disponible, quand les résultats s'affichent, alors un message me propose d'augmenter le temps ou d'élargir la zone.

*Évolution envisagée : tenir compte aussi du temps de trajet à pied jusqu'au spot.*

---

## Epic 3 — Gestion des spots

### US-06 — Consulter un spot

> En tant qu'utilisateur connecté, je souhaite consulter les informations détaillées d'un spot, afin de savoir si ce lieu correspond à ce que je recherche.

**Priorité : P1 — MVP**

**Critères d'acceptation :**

- La fiche affiche le titre, la description, les photos, la catégorie, les tags, la durée estimée et la distance depuis ma position ou la zone recherchée.
- L'adresse et le conseil pratique sont affichés lorsqu'ils ont été renseignés.
- Un bouton « Itinéraire » ouvre le trajet vers le spot dans l'application de cartographie de l'appareil.
- Les photos sont chargées dans une taille adaptée à l'écran, et seulement lorsqu'elles deviennent visibles.
- Étant donné qu'un spot est masqué ou supprimé, quand j'essaie d'accéder à sa fiche, alors un message indique que le spot n'est plus disponible.
- Quand je ferme la fiche, je reviens à la carte avec la même position, le même zoom et les mêmes filtres.

### US-07 — Ajouter un spot

> En tant qu'utilisateur connecté, je souhaite proposer un nouveau spot, afin de partager un lieu intéressant avec la communauté.

**Priorité : P1 — MVP**

**Critères d'acceptation :**

- Le titre, la description, la catégorie, la localisation, la durée estimée et au moins une photo sont obligatoires. Les tags, l'adresse et le conseil pratique sont facultatifs.
- Je peux ajouter entre 1 et 5 photos, aux formats JPEG, PNG ou WebP, avec un poids maximal par fichier défini par l'application.
- Les coordonnées GPS sont validées : latitude entre -90 et 90, longitude entre -180 et 180.
- Étant donné que le formulaire est valide, quand je le soumets, alors le spot est enregistré avec le statut `PUBLIE`, m'est rattaché comme créateur et apparaît sur la carte.
- Étant donné qu'une donnée est invalide, quand je soumets le formulaire, alors le spot n'est pas créé et chaque erreur est indiquée à côté du champ concerné.
- Toutes les règles sont vérifiées par l'API, y compris le nombre, le type et le poids des photos.

### US-18 — Gérer ses spots

> En tant qu'utilisateur connecté, je souhaite modifier ou supprimer les spots que j'ai publiés, afin de corriger une information erronée ou de retirer un spot qui n'est plus pertinent.

**Priorité : P1 — MVP**

**Critères d'acceptation :**

- Depuis la fiche d'un spot dont je suis l'auteur, je peux le modifier ou le supprimer. Ces actions n'apparaissent pas sur les spots des autres utilisateurs.
- La modification applique les mêmes règles de validation que la création (US-07) : champs obligatoires, 1 à 5 photos, coordonnées GPS valides.
- Étant donné que je modifie un spot, quand j'enregistre, alors les changements sont visibles immédiatement sur la carte et sur la fiche.
- Les photos retirées lors d'une modification sont aussi supprimées du service de stockage des médias.
- Étant donné que je demande la suppression d'un spot, quand je confirme, alors son statut passe à `SUPPRIME` et il n'apparaît plus sur la carte, dans les recherches ni dans les favoris.
- Une confirmation m'est demandée avant la suppression.
- Un spot masqué par un administrateur ne peut pas être republié par son auteur en le modifiant.
- L'API vérifie que l'utilisateur est l'auteur du spot ou un administrateur. Toute autre requête est refusée.

---

## Epic 4 — Interactions

### US-08 — Ajouter un spot aux favoris

> En tant qu'utilisateur connecté, je souhaite enregistrer un spot dans mes favoris, afin de pouvoir le retrouver facilement plus tard.

**Priorité : P1 — MVP**

**Critères d'acceptation :**

- Depuis la fiche d'un spot, je peux l'ajouter à mes favoris ou l'en retirer en une action.
- La fiche indique si le spot fait déjà partie de mes favoris.
- Un même spot ne peut pas figurer deux fois dans mes favoris, même en cas de double clic ou de requêtes répétées.

### US-09 — Consulter ses favoris

> En tant qu'utilisateur connecté, je souhaite consulter mes spots favoris, afin de retrouver facilement les lieux que j'ai enregistrés.

**Priorité : P1 — MVP**

**Critères d'acceptation :**

- La liste affiche mes favoris du plus récent au plus ancien, avec le titre, la catégorie, la durée et une photo miniature.
- La liste est paginée.
- Les spots masqués ou supprimés n'apparaissent pas dans la liste.
- Étant donné que je n'ai aucun favori, quand j'ouvre la liste, alors un message m'invite à découvrir des spots.
- Je ne peux consulter que mes propres favoris.

### US-10 — Commenter un spot

> En tant qu'utilisateur connecté, je souhaite publier un commentaire sur un spot, afin de partager mon expérience avec les autres utilisateurs.

**Priorité : P2**

**Critères d'acceptation :**

- Depuis la fiche d'un spot, je peux rédiger et publier un commentaire.
- Un commentaire vide est refusé, et son contenu est validé par l'API.
- Le commentaire publié apparaît sur la fiche du spot, avec son auteur et sa date.
- Je peux supprimer mes propres commentaires, et uniquement les miens.
- Le nombre de commentaires publiés sur une courte période est limité pour réduire le spam.

### US-11 — Noter un spot

> En tant qu'utilisateur connecté, je souhaite attribuer une note de 1 à 5 à un spot, afin d'aider les autres utilisateurs à évaluer sa qualité.

**Priorité : P2**

**Critères d'acceptation :**

- Depuis la fiche d'un spot, je peux attribuer une note de 1 à 5.
- Je ne peux avoir qu'une seule note par spot. Si je note à nouveau, ma note précédente est remplacée.
- La note est indépendante du commentaire : je peux noter sans commenter.
- La note moyenne du spot et le nombre de notes sont mis à jour et affichés sur la fiche.

### US-12 — Signaler un contenu

> En tant qu'utilisateur connecté, je souhaite signaler un spot ou un commentaire inapproprié ou incorrect, afin de contribuer à la qualité des informations présentes sur Spotly.

**Priorité : P2**

**Critères d'acceptation :**

- Un bouton de signalement est disponible sur chaque spot et chaque commentaire.
- Je dois choisir un motif parmi une liste. Je peux ajouter une description.
- Un signalement vise exactement un contenu : soit un spot, soit un commentaire.
- Le signalement est enregistré et une confirmation s'affiche.

---

## Epic 5 — Profil utilisateur

### US-13 — Consulter son profil

> En tant qu'utilisateur connecté, je souhaite consulter mon profil, afin de retrouver mes informations et mes contributions sur Spotly.

**Priorité : P2**

**Critères d'acceptation :**

- Je peux accéder à mon profil depuis le menu.
- Mon pseudo et mes informations principales sont affichés.
- Je peux consulter la liste des spots que j'ai publiés.
- Je peux accéder à mes favoris depuis mon profil.

### US-14 — Modifier son profil

> En tant qu'utilisateur connecté, je souhaite modifier mes informations personnelles, afin de garder mon profil à jour.

**Priorité : P3**

**Critères d'acceptation :**

- Je peux modifier mon pseudo, mon prénom, mon nom, ma ville et ma photo de profil depuis mon profil. Le prénom, le nom, la ville et la photo sont facultatifs.
- Les nouvelles informations sont validées par l'API, notamment l'unicité du pseudo.
- Les modifications sont enregistrées et une confirmation s'affiche.
- Je ne peux modifier que mon propre profil.

---

## Epic 6 — Administration

### US-17 — Masquer un spot

> En tant qu'administrateur, je souhaite masquer un spot qui ne respecte pas les règles de la plateforme, afin de le retirer de la vue des utilisateurs sans le supprimer définitivement.

**Priorité : P1 — MVP**

**Critères d'acceptation :**

- Seul un utilisateur ayant le rôle administrateur peut masquer ou republier un spot. Le contrôle est fait par l'API : une requête d'un autre utilisateur est refusée.
- Étant donné qu'un spot est publié, quand je le masque, alors son statut passe à `MASQUE` et il disparaît de la carte, des recherches et des favoris.
- Étant donné qu'un spot est masqué, quand je le republie, alors son statut repasse à `PUBLIE` et il redevient visible.
- Je peux retrouver la liste des spots masqués.

### US-15 — Traiter les signalements

> En tant qu'administrateur, je souhaite consulter et traiter les signalements, afin de maintenir la qualité des contenus de Spotly.

**Priorité : P3**

**Critères d'acceptation :**

- Je peux consulter la liste des signalements en attente.
- Pour chaque signalement, je vois le contenu signalé, le motif et la date.
- Je peux traiter un signalement : masquer le contenu concerné ou classer le signalement sans suite.
- Un signalement traité passe à l'état « traité » et n'apparaît plus dans la liste des signalements en attente.
- Seul un administrateur peut accéder à ces fonctionnalités. Le contrôle est fait par l'API.

---

## 4. Priorisation

### P1 — MVP

- US-01 — Créer un compte
- US-02 — Se connecter
- US-03 — Voir les spots sur une carte
- US-04 — Rechercher un spot ou une zone
- US-05 — Filtrer les spots
- US-16 — Indiquer son temps disponible
- US-06 — Consulter un spot
- US-07 — Ajouter un spot
- US-18 — Gérer ses spots
- US-08 — Ajouter un spot aux favoris
- US-09 — Consulter ses favoris
- US-17 — Masquer un spot

### P2 — Évolutions

- US-10 — Commenter un spot
- US-11 — Noter un spot
- US-12 — Signaler un contenu
- US-13 — Consulter son profil

### P3 — Fonctionnalités secondaires

- US-14 — Modifier son profil
- US-15 — Traiter les signalements

### Hors backlog actuel

Les fonctionnalités suivantes font partie de la vision du produit mais ne sont pas planifiées : likes, préférences utilisateur, brouillons et archivage des spots, vérification de l'adresse e-mail, réinitialisation du mot de passe, suppression de compte, suspension de compte, partage de spots, notifications et offre professionnelle.

---

## 5. Définition du MVP

Le **MVP (Minimum Viable Product)** de Spotly a pour objectif de proposer la fonctionnalité principale de l'application :

> **Permettre à un utilisateur de découvrir des spots autour de lui, adaptés au temps dont il dispose, de consulter leurs informations et de sauvegarder ceux qui l'intéressent.**

Le MVP se concentre donc sur la **découverte contextualisée**, la **contribution** par l'ajout de spots et la **gestion des favoris**, avec une **modération minimale** des contenus publiés.

Les fonctionnalités communautaires (commentaires, notes, signalements) et l'administration complète pourront être ajoutées progressivement après validation du fonctionnement principal de l'application.

---

## 6. Suivi des User Stories

Chaque User Story est représentée par une **carte Trello**.

Une carte contient notamment :

- Identifiant de la User Story
- Titre
- Epic associé
- Description de la User Story
- Priorité
- Critères d'acceptation
- Statut
- Tâches techniques associées

### Exemple : US-03 — Voir les spots sur une carte

Tâches techniques possibles :

- Installer et configurer MapLibre GL JS
- Créer le composant de carte
- Créer la route API renvoyant les spots d'une zone géographique
- Récupérer les spots de la zone visible depuis l'API
- Afficher les marqueurs et le clustering
- Ajouter la géolocalisation et le repli sur la recherche manuelle
- Tester l'affichage sur mobile

Cela permet de conserver une distinction entre **le besoin utilisateur (User Story)** et **la réalisation technique**.

---

## 7. Justification de la priorisation

La priorité est donnée aux fonctionnalités permettant de réaliser la proposition de valeur principale de Spotly.

La **carte, la recherche, les filtres, le temps disponible et la consultation des spots** sont prioritaires car ils permettent directement à l'utilisateur de découvrir des lieux adaptés à sa situation. Le **temps disponible** (US-16) fait l'objet d'une User Story dédiée car il constitue l'élément différenciant de Spotly : sans lui, l'application se limiterait à une carte de lieux.

L'**ajout de spots** fait partie du MVP car les contenus de Spotly proviennent de la communauté. La **gestion de ses spots** (US-18) l'accompagne : les spots étant publiés immédiatement, leur auteur doit pouvoir corriger une erreur, par exemple sur la durée ou la position, qui fausserait sinon les résultats liés au temps disponible.

Les **favoris** sont également intégrés au MVP car ils permettent à l'utilisateur de conserver les spots qui l'intéressent.

Le **masquage d'un spot** par un administrateur (US-17) est intégré au MVP car des contenus communautaires sont publiés immédiatement, sans validation préalable. Il faut donc pouvoir retirer un contenu problématique dès la première version.

Les commentaires, notes et signalements sont placés en P2 car ils renforcent l'aspect communautaire mais ne sont pas indispensables pour découvrir des spots.

Enfin, le traitement complet des signalements et la modification du profil sont placés en P3 car ils peuvent être développés après la mise en place du fonctionnement principal de l'application.

---

## 8. Outils utilisés

- **Trello** : gestion du backlog et suivi Kanban
- **Figma** : wireframes, maquettes et prototype
- **Git/GitHub** : gestion du code source et des versions

Cette organisation permet de passer progressivement de la **conception UX/UI** au **développement**, tout en gardant une vision claire des fonctionnalités à réaliser.
