# Analyse d'éco-conception — Spotly

## Présentation du projet

Spotly est une application web responsive pensée avant tout pour une utilisation sur smartphone. Elle permet aux voyageurs de découvrir rapidement des lieux, activités et expériences à proximité grâce à une carte interactive et aux recommandations de la communauté.

L'application vise à répondre à une problématique simple : permettre à un voyageur de trouver rapidement un lieu intéressant autour de lui en fonction de sa position, du temps dont il dispose et de ses centres d'intérêt.

Le public cible est composé principalement de voyageurs solo, backpackers, touristes en court séjour, digital nomads et voyageurs longue durée.

---

## Fonctionnalité étudiée

Dans le cadre de cette analyse d'éco-conception, la fonctionnalité principale retenue est la découverte d'un spot à proximité via la carte interactive.

Cette fonctionnalité représente le cœur de l'application et constitue l'action la plus fréquemment réalisée par les utilisateurs.

---

## Unité fonctionnelle

Permettre à un utilisateur de découvrir un spot pertinent à proximité de sa position en moins de deux minutes grâce à une carte interactive et des informations contextualisées.

Cette unité fonctionnelle servira de référence pour l'analyse des impacts environnementaux et l'identification des pistes d'amélioration.

---

## Parcours utilisateur étudié

Le parcours utilisateur retenu est le suivant :

1. Ouvrir l'application Spotly.
2. Autoriser la géolocalisation.
3. Afficher la carte interactive.
4. Visualiser les spots à proximité.
5. Indiquer son temps disponible.
6. Utiliser les filtres de recherche.
7. Consulter la fiche détaillée d'un spot.
8. Lire les informations et les photos associées.
9. Ajouter le spot en favoris.

Ce parcours correspond à l'usage principal de l'application.

---

## Gestion de l'authentification

L'utilisation de Spotly nécessite un compte, y compris pour consulter la carte. Le parcours étudié commence pourtant avec un utilisateur **déjà connecté**.

Ce choix est justifié par la fréquence des actions : l'utilisateur s'authentifie une seule fois, lors de son inscription ou de sa première connexion. Une **session persistante** lui permet ensuite de rester connecté pendant toute sa durée de validité. La connexion n'est donc pas répétée à chaque découverte de spot, contrairement aux étapes du parcours étudié.

Inclure la connexion dans chaque parcours surestimerait son poids dans l'usage réel. Son impact est évalué à part, comme une action ponctuelle (voir l'[analyse des impacts](analyse-des-impacts.md)).

La session persistante est aussi un choix d'éco-conception : elle évite des échanges réseau et des traitements serveur répétés (vérification du mot de passe, création de session).

---

## Ressources numériques sollicitées

Le parcours étudié mobilise plusieurs ressources numériques :

| Étape | Ressources utilisées |
|---------|---------|
| Ouverture de l'application | HTML, CSS, JavaScript |
| Géolocalisation | API de géolocalisation du navigateur |
| Indication du temps disponible | Filtre appliqué par l'API lors du chargement des spots |
| Affichage de la carte | Tuiles cartographiques MapLibre |
| Chargement des spots | API REST, base de données PostgreSQL |
| Consultation d'un spot | API REST, base de données PostgreSQL |
| Affichage des photos | Cloudinary |
| Ajout en favoris | API REST, base de données PostgreSQL |

Les ressources les plus sollicitées sont les images, les données cartographiques et les échanges réseau entre le client et le serveur.

---

## Premières hypothèses d'impact

Les principaux postes susceptibles de générer un impact environnemental sont :

- le chargement des images publiées par les utilisateurs ;
- le chargement des tuiles cartographiques ;
- les appels réseau liés à la recherche des spots ;
- les requêtes vers la base de données ;
- le stockage des médias.

Ces éléments feront l'objet d'une analyse plus détaillée dans la suite de la démarche d'éco-conception.