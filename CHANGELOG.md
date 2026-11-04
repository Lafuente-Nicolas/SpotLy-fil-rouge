# Journal des versions

Toutes les évolutions notables de Spotly sont consignées ici.

Le format s'inspire de [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/) et le projet suit le [versionnement sémantique](https://semver.org/lang/fr/).

## [Non publié]

### Ajouté

- Initialisation du backend : Express et TypeScript, route de test `GET /api/sante`, ESLint et Prettier, version de Node fixée par `.nvmrc`.

- Base de données PostgreSQL pour le développement avec Docker Compose, modèle des variables d'environnement (`.env.example`) et décision D26.
- Instructions d'installation dans le README.

## [0.2.0] — 2026-11-03 — Conception technique

### Ajouté

- Décision D22 : carte avec MapLibre GL JS, tuiles vectorielles OpenFreeMap et style personnalisé.
- Décisions D23 à D25 : authentification par session, géocodage avec Nominatim, validation des données avec Zod.
- Conception technique : schéma d'architecture, routes de l'API et diagrammes de séquence (connexion, création d'un spot).

### Modifié

- US-04 : la recherche d'une ville ou d'une adresse part uniquement à la validation, pour respecter la politique d'utilisation de Nominatim.
- MPD : ajout de la table technique des sessions.

## [0.1.0] — 2026-11-03 — Conception

### Ajouté

- Présentation du projet, expression du besoin et personas.
- Spécifications fonctionnelles : contraintes et livrables, acteurs, cas d'utilisation (diagramme PlantUML), parcours utilisateurs et User Journeys.
- Cahier des charges fonctionnel.
- Backlog de 18 User Stories et registre des décisions de conception (D1 à D21).
- Export des maquettes Figma.
- Modélisation des données : MCD, MLD (Looping) et MPD avec son script SQL pour PostgreSQL.
- Démarche et analyse d'éco-conception.
- Brouillon du cahier des charges technique.
- Règles de contribution : Git Flow, commits conventionnels, modèle de Pull Request.
