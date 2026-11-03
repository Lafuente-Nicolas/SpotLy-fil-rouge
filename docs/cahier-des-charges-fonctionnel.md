# Cahier des charges fonctionnel — Spotly

Ce document décrit les fonctionnalités de Spotly et les règles de gestion qu'elles doivent respecter.

La présentation du projet et l'analyse du besoin sont décrites dans des documents dédiés :

- [Présentation du projet](presentation-du-projet.md) ;
- [Expression du besoin](expression-du-besoin.md).

Le périmètre décrit ici est aligné sur les [décisions de conception](decisions-de-conception.md) et sur le [backlog](backlog.md). Pour chaque fonctionnalité, il est précisé si elle fait partie du **MVP** ou d'une **évolution**.

---

## 1. Fonctionnalité principale : la découverte contextualisée

La fonctionnalité centrale de Spotly est de permettre à un voyageur de **découvrir des expériences locales adaptées à sa situation**, c'est-à-dire à sa position et au temps dont il dispose.

Le parcours principal est le suivant :

1. L'utilisateur, connecté, ouvre Spotly et autorise l'accès à sa localisation, ou recherche une zone manuellement.
2. L'application affiche les spots de la zone sur une carte.
3. L'utilisateur indique le temps dont il dispose.
4. Spotly n'affiche plus que les spots dont la durée estimée est compatible avec ce temps.
5. L'utilisateur peut affiner les résultats par catégorie, tags ou distance.
6. Il sélectionne un spot pour consulter sa fiche.
7. Il peut l'enregistrer dans ses favoris ou décider de s'y rendre.

**Valeur fonctionnelle :** cette fonctionnalité réduit le temps nécessaire pour trouver une activité et aide l'utilisateur à décider rapidement, en fonction de sa situation réelle.

---

## 2. Découverte des spots

### 2.1 Carte interactive et géolocalisation — MVP

La carte est le principal moyen de découverte des spots. Elle permet :

- d'afficher les spots sous forme de marqueurs, avec un aperçu au clic ;
- de centrer la carte sur la position de l'utilisateur ;
- de ne charger que les spots de la zone visible, puis ceux des nouvelles zones lors d'un déplacement ou d'un zoom ;
- de regrouper les spots proches (clustering).

L'application demande l'autorisation d'utiliser la géolocalisation. En cas de refus ou d'indisponibilité, l'utilisateur peut **rechercher une zone** (ville, adresse). La géolocalisation n'est jamais obligatoire.

### 2.2 Temps disponible — MVP

L'utilisateur indique le temps dont il dispose parmi des valeurs proposées : 30 minutes, 1 heure, 2 heures, une demi-journée ou une journée.

Seuls les spots dont la durée estimée est inférieure ou égale à ce temps sont alors affichés. Le temps choisi reste visible et modifiable à tout moment, et l'utilisateur peut retirer ce critère.

### 2.3 Recherche et filtres

| Critère | Périmètre |
| --- | --- |
| Recherche par mot-clé | MVP |
| Recherche d'une zone (ville, adresse) | MVP |
| Catégorie | MVP |
| Tags | MVP |
| Distance maximale | MVP |
| Temps disponible | MVP |
| Popularité (selon les notes) | Évolution |
| Moment idéal | Évolution |
| Préférences de l'utilisateur | Évolution |

Les filtres sont combinables. Lorsqu'aucun spot ne correspond, l'application l'indique et propose d'élargir la recherche.

---

## 3. Gestion des spots

### 3.1 Contenu d'un spot — MVP

| Donnée | Obligatoire | Précisions |
| --- | --- | --- |
| Titre | Oui | |
| Description | Oui | |
| Catégorie | Oui | Une seule catégorie principale |
| Localisation GPS | Oui | Coordonnées validées |
| Adresse | Non | Adresse lisible, pour l'affichage |
| Durée estimée | Oui | 30 min, 1 h, 2 h, demi-journée ou journée |
| Photos | Oui | De 1 à 5 photos |
| Tags | Non | Choisis dans une liste contrôlée |
| Conseil | Non | Conseil pratique (ex. : prévoir de bonnes chaussures) |
| Créateur | Automatique | L'utilisateur connecté |
| Date de création | Automatique | |

Les autres informations complémentaires envisagées (moment idéal, horaires, conditions d'accès) sont des évolutions.

### 3.2 Catégories et tags

Chaque spot appartient à **une seule catégorie principale**, qui sert à le classer et à choisir son marqueur sur la carte. La liste des catégories est définie par l'administrateur et initialisée en base pour le MVP.

Les **tags** précisent un spot sans le classer, par exemple : gratuit, wifi, coucher de soleil, street food, accessible à pied, adapté à la pluie.

**Catégories retenues (décision D16) :**

| Catégorie | Exemples de spots |
| --- | --- |
| Café | Café calme, salon de thé |
| Coworking | Espace de coworking |
| Restauration | Restaurant, stand de street food |
| Bar et rooftop | Bar, rooftop |
| Point de vue | Panorama, spot de coucher de soleil |
| Plage et baignade | Plage, lac, piscine naturelle |
| Nature et randonnée | Balade, randonnée, parc |
| Culture et patrimoine | Musée, monument, quartier historique |
| Marché | Marché local, marché de nuit |
| Activité | Surf, plongée, atelier |

Cette liste regroupe les catégories citées dans les différents documents du projet et supprime celles qui se recoupaient : « vue » et « sunset » deviennent « Point de vue », « balade » et « randonnée » deviennent « Nature et randonnée ». « Sunset » et « street food » deviennent aussi des tags.

### 3.3 Création, modification et suppression — MVP

- Seul un utilisateur connecté peut créer un spot.
- Un spot est **publié immédiatement** après sa création. La modération intervient ensuite.
- Le créateur peut **modifier** ou **supprimer** ses propres spots. Un administrateur peut aussi les supprimer.
- La modification applique les mêmes règles de validation que la création.
- Les photos retirées ou liées à un spot supprimé sont supprimées du service de stockage des médias.

### 3.4 Statuts d'un spot — MVP

| Statut | Signification | Visible par les utilisateurs |
| --- | --- | --- |
| Publié | Statut par défaut à la création | Oui |
| Masqué | Retiré par un administrateur | Non |
| Supprimé | Supprimé par son créateur ou un administrateur (suppression logique) | Non |

Les statuts « brouillon » et « archivé » sont des évolutions. Le fait qu'un spot soit signalé n'est pas un statut : c'est une information déduite des signalements.

---

## 4. Gestion du compte

| Fonctionnalité | Périmètre |
| --- | --- |
| Créer un compte (pseudo, adresse e-mail, mot de passe, acceptation des conditions d'utilisation) | MVP |
| Se connecter, se déconnecter | MVP |
| Consulter son profil et ses contributions | Évolution (P2) |
| Modifier son profil (prénom, nom, ville, photo de profil) | Évolution (P3) |
| Vérifier son adresse e-mail | Évolution |
| Réinitialiser son mot de passe | Évolution |
| Renseigner ses préférences | Évolution |
| Supprimer son compte (droit à l'effacement, décision D21) | Évolution |

L'utilisation de Spotly nécessite un compte, y compris pour consulter la carte. Seules l'inscription et la connexion sont accessibles sans être connecté.

---

## 5. Interactions communautaires

### 5.1 Favoris — MVP

L'utilisateur peut ajouter un spot à ses favoris, l'en retirer et consulter la liste de ses favoris. Un favori sert à **conserver** un spot pour le retrouver plus tard.

### 5.2 Notes — Évolution (P2)

L'utilisateur peut attribuer à un spot une note de 1 à 5, qu'il peut modifier. La note sert à **évaluer** un spot. La note moyenne et le nombre de notes sont affichés sur la fiche.

La note est indépendante du commentaire. Les « likes » ne sont pas retenus dans le périmètre actuel : la note joue ce rôle d'appréciation, de façon plus informative. Ils restent une piste d'évolution.

### 5.3 Commentaires — Évolution (P2)

L'utilisateur peut publier un commentaire sur un spot pour partager son expérience, et supprimer ses propres commentaires.

### 5.4 Signalements — Évolution (P2)

L'utilisateur peut signaler un spot ou un commentaire inapproprié ou incorrect, en choisissant un motif et en ajoutant éventuellement une description.

---

## 6. Administration et modération

L'administrateur est un utilisateur disposant de droits supplémentaires.

| Fonctionnalité | Périmètre |
| --- | --- |
| Masquer un spot, ou le republier | MVP |
| Supprimer un spot | MVP |
| Consulter et traiter les signalements (spots et commentaires) | Évolution (P3) |
| Suspendre un compte | Évolution |
| Gérer les catégories depuis l'interface | Évolution |
| Consulter des statistiques | Évolution |

Toutes les autorisations sont vérifiées par l'API, et pas seulement en masquant des boutons dans l'interface.

---

## 7. Règles de gestion

### 7.1 Utilisateurs

- Une adresse e-mail ne peut être associée qu'à un seul compte.
- Un pseudo ne peut être associé qu'à un seul compte.
- Un utilisateur doit être connecté pour utiliser l'application, à l'exception de l'inscription et de la connexion.
- Un utilisateur ne peut modifier que ses propres données et ses propres contenus.
- Le mot de passe comporte au moins 12 caractères et n'est jamais stocké en clair.

### 7.2 Spots

- Un spot est associé à un seul créateur et à une seule catégorie principale.
- Un spot comporte un titre, une description, une catégorie, une localisation, une durée estimée et de 1 à 5 photos.
- Les coordonnées GPS doivent être valides : latitude entre -90 et 90, longitude entre -180 et 180.
- Un spot peut être modifié ou supprimé par son créateur. Il peut être masqué ou supprimé par un administrateur.
- Un spot masqué par un administrateur ne peut pas être republié par son créateur.
- Seuls les spots publiés apparaissent sur la carte, dans les recherches, dans les fiches et dans les favoris.

### 7.3 Interactions

- Un même spot ne peut figurer qu'une seule fois dans les favoris d'un utilisateur.
- Un utilisateur ne peut attribuer qu'une seule note par spot, comprise entre 1 et 5.
- Un commentaire est associé à un utilisateur et à un spot. Il ne peut pas être vide.
- Un signalement est effectué par un utilisateur et vise exactement un contenu : soit un spot, soit un commentaire.
- Le nombre d'actions d'un même utilisateur sur une courte période est limité, afin de réduire le spam.

### 7.4 Règles à préciser

Les règles suivantes, envisagées au début du projet, ne sont pas retenues tant que leur fonctionnement n'est pas défini :

- **Spot en doublon** : il faudrait définir à partir de quand deux spots sont considérés comme identiques (même nom, distance minimale entre deux spots…).
- **Masquage automatique après plusieurs signalements** : il faudrait définir un seuil et éviter qu'il soit utilisé pour masquer abusivement un contenu.

---

## 8. Synthèse du périmètre

| Périmètre | Fonctionnalités |
| --- | --- |
| **MVP (P1)** | Inscription, connexion, déconnexion ; carte et géolocalisation ; recherche par mot-clé ou par zone ; filtres ; temps disponible ; fiche d'un spot ; ajout, modification et suppression de ses spots ; favoris ; masquage d'un spot par un administrateur |
| **Évolutions (P2)** | Commentaires, notes, signalements, consultation du profil |
| **Évolutions (P3)** | Modification du profil, traitement des signalements |
| **Vision long terme** | Likes, préférences, vérification de l'e-mail, mot de passe oublié, suppression de compte, suspension de comptes, gestion des catégories, notifications, partage de spots (bouton déjà présent sur la maquette, décision D18), événements, offre professionnelle |
