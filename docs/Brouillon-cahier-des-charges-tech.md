# 4. Cahier des charges technique

## 4.1 Architecture générale

Spotly repose sur une architecture client/serveur séparant le frontend, le backend et la base de données.

L'architecture est composée de trois éléments principaux :

* **Frontend** : interface utilisateur et interactions avec la carte ;
* **Backend** : API REST et logique métier ;
* **Base de données** : stockage persistant des données de l'application.

Un service externe est également utilisé pour la gestion des médias, notamment les photos associées aux spots.

Cette séparation permet de maintenir une architecture modulaire et facilite la maintenance et l'évolution de l'application.

Elle permet également de séparer les responsabilités : le frontend gère principalement l'affichage et les interactions, tandis que le backend est responsable de la logique métier, de la validation et de l'accès aux données.

---

## 4.2 Frontend

### React — version 19.2

React est utilisé pour développer l'interface utilisateur de Spotly.

Le choix de React est principalement lié au caractère fortement interactif de l'application. Spotly doit notamment gérer une carte, des filtres, des fiches de spots, des favoris et différentes interactions communautaires.

L'approche par composants de React permet de découper l'interface en éléments réutilisables et indépendants, ce qui facilite la maintenance et l'évolution de l'application.

La version **19.2** est retenue car elle appartient au canal stable de React. React suit une politique de versionnement sémantique et les versions stables bénéficient d'un cycle de développement et de tests avant publication.

Le choix d'une version stable plutôt qu'une version expérimentale permet de limiter les risques de régression et de garantir un environnement plus fiable pour le développement du projet.

---

## 4.3 Outil de build — Vite 8.1

Vite est utilisé comme outil de développement et de build du frontend.

Il permet notamment :

* de démarrer rapidement l'environnement de développement ;
* de gérer le module bundling de l'application ;
* de générer une version optimisée pour la production.

La version **8.1** est retenue car elle constitue une version stable récente de Vite. Vite 8 a introduit Rolldown comme bundler unifié et Vite 8.1 apporte notamment des améliorations et corrections par rapport à la première version majeure.

Le choix de Vite est également cohérent avec l'objectif de construire une application frontend légère et performante.

---

## 4.4 TypeScript

TypeScript est utilisé comme langage principal du frontend et du backend.

Il apporte un typage statique permettant notamment de détecter certaines erreurs pendant le développement et de mieux documenter la structure des données.

Ce choix est particulièrement pertinent pour Spotly car l'application manipule de nombreuses données structurées :

* utilisateurs ;
* spots ;
* catégories ;
* coordonnées géographiques ;
* commentaires ;
* notes ;
* favoris ;
* signalements.

L'utilisation de TypeScript sur le frontend et le backend permet également de conserver une cohérence dans la manière dont les données sont manipulées dans l'ensemble de l'application.

**Version : à renseigner selon la version réellement utilisée dans le projet.**

La version exacte doit être figée dans les dépendances du projet afin d'assurer la reproductibilité de l'environnement.

---

## 4.5 Tailwind CSS

Tailwind CSS est utilisé pour la conception de l'interface utilisateur.

Le choix de Tailwind CSS répond principalement à deux besoins du projet :

1. développer rapidement une interface responsive ;
2. conserver une interface cohérente sans multiplier les feuilles de styles personnalisées.

Spotly étant conçu selon une approche **mobile-first**, Tailwind permet de gérer facilement les différentes tailles d'écran et d'adapter l'interface aux smartphones, tablettes et ordinateurs.

Le choix de la version doit être basé sur une version stable compatible avec React 19 et Vite 8, afin d'éviter d'introduire une dépendance expérimentale inutile.

**Version : à renseigner selon la version retenue dans le projet.**

---

## 4.6 Cartographie — MapLibre GL JS 6.x

MapLibre GL JS est utilisé pour construire la carte interactive de Spotly.

Cette technologie est directement liée à la fonctionnalité principale du projet : permettre à l'utilisateur de découvrir des spots autour de sa position.

Elle permet notamment :

* d'afficher une carte interactive ;
* d'afficher les spots sous forme de marqueurs ;
* de gérer le déplacement et le zoom ;
* d'afficher les données selon la zone visible ;
* de mettre en place le clustering des spots.

La version **6.x** est retenue car MapLibre GL JS 6 est désormais une version majeure officiellement publiée en 2026. Cette version apporte notamment une architecture moderne basée sur les modules ES et abandonne certaines anciennes configurations de la version 5.

Le choix de MapLibre est également cohérent avec le besoin de disposer d'une solution de cartographie flexible et adaptée à une application web moderne.

### Fond de carte — OpenFreeMap

MapLibre affiche la carte, mais les données du fond de carte viennent d'un **fournisseur de tuiles**. Spotly utilise les tuiles vectorielles d'**OpenFreeMap**, issues d'OpenStreetMap : elles sont gratuites, sans inscription ni clé d'accès. La mention « © OpenStreetMap » est affichée sur la carte.

Le style de la carte est personnalisé aux couleurs de la charte graphique avec l'éditeur Maputnik. Les tuiles vectorielles sont plus légères que des tuiles en images et s'adaptent à ce style.

Ces choix sont justifiés dans la décision **D22** des [décisions de conception](decisions-de-conception.md).

---

## 4.7 Backend — Node.js 24.20.0 LTS

Node.js est utilisé comme environnement d'exécution du backend.

Le choix de Node.js permet de développer le serveur avec le même écosystème JavaScript/TypeScript que le frontend.

La version **24.20.0 LTS** est retenue pour le projet.

Le choix d'une version LTS est volontaire : contrairement à une version *Current*, une version LTS est destinée aux applications nécessitant une meilleure stabilité et une maintenance sur la durée. La documentation officielle de Node.js recommande d'utiliser les versions Active LTS ou Maintenance LTS pour les applications en production.

Node.js 24 est actuellement une branche LTS, tandis que Node.js 26 est encore en phase *Current* au moment de la rédaction de ce document.

Ce choix permet donc de privilégier la stabilité et la maintenance plutôt que l'utilisation immédiate de la version majeure la plus récente.

---

## 4.8 API — Express 5.x

Express est utilisé pour construire l'API REST de Spotly.

L'API permet au frontend de communiquer avec le backend afin de :

* récupérer les spots ;
* créer et modifier des spots ;
* gérer les utilisateurs ;
* gérer les favoris ;
* gérer les notes ;
* gérer les commentaires ;
* gérer les signalements ;
* effectuer les opérations d'administration.

Express est retenu car il fournit une base légère et flexible pour construire une API REST avec Node.js.

Cette approche permet de ne pas imposer une architecture trop lourde au projet et de conserver un contrôle important sur l'organisation des routes, middlewares et règles métier.

La branche **Express 5.x** est privilégiée afin de rester sur une version majeure moderne et maintenue.

**Version exacte : à renseigner selon la version installée dans le projet.**

---

## 4.9 Base de données — PostgreSQL 18.6

PostgreSQL est utilisé comme système de gestion de base de données relationnelle.

Le choix de PostgreSQL est adapté à Spotly car l'application possède de nombreuses relations entre ses données.

Par exemple :

* un utilisateur peut créer plusieurs spots ;
* un spot appartient à un utilisateur ;
* un spot peut avoir plusieurs commentaires ;
* un utilisateur peut enregistrer plusieurs favoris ;
* plusieurs utilisateurs peuvent enregistrer un même spot.

Une base relationnelle permet donc de représenter clairement ces relations et de garantir l'intégrité des données.

La version **18.6** est retenue car PostgreSQL 18 est actuellement une version majeure supportée et 18.6 correspond à une version corrective récente. PostgreSQL recommande l'utilisation de la dernière version mineure disponible d'une branche supportée, notamment pour bénéficier des corrections de bugs et de sécurité.

Le choix d'une version supportée permet d'éviter d'utiliser une version ancienne qui ne reçoit plus de correctifs.

---

## 4.10 ORM — Prisma

Prisma est utilisé comme ORM entre le backend TypeScript et PostgreSQL.

Il permet de :

* définir le modèle de données ;
* effectuer les opérations CRUD ;
* gérer les migrations ;
* bénéficier d'un typage des données ;
* simplifier les requêtes vers PostgreSQL.

Le choix de Prisma est particulièrement adapté à Spotly en raison de l'utilisation de TypeScript.

Le typage généré par Prisma permet de limiter les erreurs lors de la manipulation des données et améliore la maintenabilité du projet.

**Version : à renseigner selon la version réellement utilisée dans le projet.**

La version devra être figée afin de garantir la reproductibilité de l'environnement.

---

## 4.11 Gestion des images — Cloudinary

Cloudinary est utilisé pour gérer les images associées aux spots et éventuellement aux profils utilisateurs.

Ce choix répond à un besoin important de Spotly : les utilisateurs peuvent ajouter des photos à leurs découvertes.

Cloudinary permet notamment de gérer :

* l'upload des images ;
* leur stockage ;
* leur transformation ;
* leur optimisation ;
* leur diffusion.

Le service est particulièrement intéressant dans le contexte de Spotly car l'éco-conception constitue une contrainte du projet. L'utilisation d'un service spécialisé permet de réduire le poids des médias transmis aux utilisateurs grâce à l'optimisation et à la transformation des images. La documentation Cloudinary fournit notamment des fonctionnalités d'upload, transformation, optimisation et diffusion adaptées aux applications Node.js.

---

## 4.12 Gestion des versions et reproductibilité

Les versions des technologies et dépendances doivent être explicitement définies dans le projet.

L'objectif est d'éviter qu'une mise à jour automatique d'une dépendance puisse modifier le comportement de l'application sans contrôle.

Les versions majeures et mineures importantes doivent donc être maîtrisées et le gestionnaire de paquets doit conserver un fichier de verrouillage permettant de reproduire l'installation des dépendances.

Cette approche est particulièrement importante pour un projet CDA car elle permet de documenter précisément l'environnement utilisé et de faciliter sa reproduction par un autre développeur.

---

## 4.13 Sécurité

La sécurité est prise en compte au niveau du frontend, du backend et de la base de données.

Les principales mesures prévues sont :

* authentification des utilisateurs ;
* hashage sécurisé des mots de passe ;
* validation des données côté serveur ;
* gestion des rôles et permissions ;
* protection contre les injections SQL ;
* protection contre les attaques XSS ;
* contrôle des fichiers envoyés ;
* limitation des interactions afin de réduire le spam ;
* protection des données personnelles.

Le backend constitue la couche de confiance de l'application. Les règles de sécurité ne doivent donc pas uniquement être appliquées dans le frontend : toutes les données reçues par l'API doivent être contrôlées côté serveur.

### Choix retenus

| Besoin | Solution | Décision |
| --- | --- | --- |
| Authentification | Session côté serveur (`express-session`) stockée dans PostgreSQL (`connect-pg-simple`), cookie `httpOnly`, `Secure`, `SameSite=Lax` | D23 |
| Hachage des mots de passe | Argon2id | D23 |
| Limitation des tentatives de connexion | `express-rate-limit` | D23 |
| Validation des données | Zod, schémas partagés entre le frontend et l'API | D25 |
| Géocodage | Nominatim (OpenStreetMap), appelé par l'API avec cache | D24 |

---

## 4.14 Performance et éco-conception

L'éco-conception constitue une contrainte importante du projet.

Les choix techniques doivent permettre de limiter :

* le poids des ressources ;
* le nombre de requêtes réseau ;
* le volume de données transférées ;
* les traitements inutiles côté client et serveur.

Les principales mesures prévues sont :

* compression des images ;
* utilisation de formats adaptés au web ;
* lazy loading ;
* pagination ;
* mise en cache lorsque cela est pertinent ;
* limitation des appels API ;
* chargement dynamique des données ;
* optimisation des requêtes SQL ;
* limitation du nombre de dépendances ;
* limitation des animations inutiles.

Ces optimisations ont un double objectif : améliorer les performances de l'application et réduire son impact environnemental.

---

## 4.15 Responsive et accessibilité

Spotly est conçu selon une approche **mobile-first**, car l'application est destinée à être utilisée principalement par des voyageurs depuis leur smartphone.

L'interface doit également rester fonctionnelle sur tablette et ordinateur.

Les principales contraintes sont :

* interface responsive ;
* contraste suffisant ;
* navigation au clavier ;
* textes lisibles ;
* textes alternatifs pour les images ;
* éléments interactifs clairement identifiables.

Ces contraintes permettent de rendre l'application utilisable par un public plus large tout en améliorant l'expérience utilisateur.

---

## 4.16 Synthèse des choix techniques

| Domaine         | Technologie / version | Justification                                                                  |
| --------------- | --------------------- | ------------------------------------------------------------------------------ |
| Interface       | React 19.2            | Interface interactive basée sur des composants réutilisables et version stable |
| Build           | Vite 8.1              | Développement rapide et chaîne de build moderne                                |
| Langage         | TypeScript            | Typage statique et meilleure maintenabilité                                    |
| CSS             | Tailwind CSS          | Responsive mobile-first et cohérence de l'interface                            |
| Cartographie    | MapLibre GL JS 6.x + tuiles OpenFreeMap | Carte interactive libre, tuiles vectorielles gratuites et légères |
| Runtime backend | Node.js 24.20.0 LTS   | Stabilité, maintenance et support à long terme                                 |
| API             | Express 5.x           | API REST légère et flexible                                                    |
| Base de données | PostgreSQL 18.6       | Base relationnelle robuste et actuellement supportée                           |
| ORM             | Prisma                | Accès typé à PostgreSQL et gestion des migrations                              |
| Médias          | Cloudinary            | Stockage, optimisation et diffusion des images                                 |
| Authentification | Sessions + Argon2id  | Session révocable, cookie inaccessible aux scripts                              |
| Validation      | Zod                   | Règles partagées entre le frontend et l'API                                     |
| Géocodage       | Nominatim             | Gratuit, mondial, cohérent avec OpenStreetMap                                   |
| Versionnement   | Git                   | Suivi des modifications et collaboration                                       |

## 4.17 Versions à figer dans le projet

Les versions exactes suivantes devront être renseignées dans les fichiers de configuration du projet avant validation définitive du cahier des charges :

| Technologie    | Version                          |
| -------------- | -------------------------------- |
| Node.js        | 24.20.0 LTS                      |
| React          | 19.2                             |
| Vite           | 8.1.x                            |
| TypeScript     | À vérifier dans `package.json`   |
| Tailwind CSS   | À vérifier dans `package.json`   |
| MapLibre GL JS | 6.x                              |
| Express        | 5.x                              |
| PostgreSQL     | 18.6                             |
| Prisma         | À vérifier dans `package.json`   |
| Cloudinary SDK | À vérifier dans `package.json`   |
| express-session, connect-pg-simple, argon2, express-rate-limit, Zod | À vérifier dans `package.json` |
| Git            | À préciser selon l'environnement |

> **Principe de versionnement :** les versions retenues doivent être des versions stables et maintenues au moment de leur adoption. Les versions expérimentales ou arrivées en fin de vie ne sont pas retenues. Les versions exactes des dépendances du projet doivent être figées afin d'assurer la reproductibilité de l'environnement.
