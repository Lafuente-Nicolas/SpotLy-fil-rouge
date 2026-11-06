# Règles de contribution — Spotly

Ce document décrit l'organisation du travail sur le dépôt : les branches, les messages de commit, les Pull Requests et les versions. Il s'applique à toutes les modifications, code comme documentation.

---

## 1. Organisation des branches (Git Flow)

| Branche | Rôle | Part de | Revient dans |
| --- | --- | --- | --- |
| `main` | Versions livrées. Chaque version y reçoit une étiquette (`v0.1.0`…). | — | — |
| `develop` | Travail intégré, prêt pour la prochaine version. | `main` | — |
| `feature/US-XX-description` | Une User Story ou une tâche de développement. | `develop` | `develop` |
| `docs/description` | Une modification de la documentation. | `develop` | `develop` |
| `release/X.Y.Z` | Préparation d'une version : derniers correctifs, numéro de version, journal des versions. | `develop` | `main` puis `develop` |
| `hotfix/description` | Correction urgente d'un bug présent sur `main`. | `main` | `main` puis `develop` |

**Règles :**

- On ne pousse **jamais** directement sur `main` ou `develop` : toute modification passe par une **Pull Request**.
- Une branche correspond à **une seule** User Story ou tâche.
- Les noms de branches sont en minuscules, sans accents, avec des tirets : `feature/US-07-ajouter-spot`, `docs/mpd`, `hotfix/connexion-session`.
- Une branche est supprimée une fois fusionnée.

### Exemple : développer une User Story

```bash
git switch develop
git pull
git switch -c feature/US-07-ajouter-spot
# … travail et commits …
git push -u origin feature/US-07-ajouter-spot
# puis ouverture d'une Pull Request vers develop sur GitHub
```

---

## 2. Messages de commit (commits conventionnels)

Chaque message suit le format :

```
type(portée): description
```

- **type** : la nature du changement (voir le tableau) ;
- **portée** (facultative) : la partie concernée, par exemple `auth`, `spots`, `carte`, `favoris`, `api`, `bdd`, `mcd` ;
- **description** : en français, au présent, sans majuscule ni point final, 100 caractères maximum.

| Type | Usage | Exemple |
| --- | --- | --- |
| `feat` | Nouvelle fonctionnalité | `feat(spots): ajouter le filtre par temps disponible` |
| `fix` | Correction de bug | `fix(auth): refuser un pseudo déjà utilisé` |
| `docs` | Documentation | `docs(mpd): ajouter le script SQL` |
| `style` | Mise en forme sans changement de comportement | `style(carte): aligner les boutons de zoom` |
| `refactor` | Code réorganisé sans changement visible | `refactor(api): extraire la validation des spots` |
| `perf` | Amélioration des performances | `perf(carte): charger uniquement les spots visibles` |
| `test` | Ajout ou modification de tests | `test(favoris): vérifier l'unicité d'un favori` |
| `build` | Dépendances, outils de build | `build: mettre à jour Vite` |
| `ci` | Intégration continue | `ci: lancer les tests à chaque Pull Request` |
| `chore` | Maintenance, configuration | `chore: ajouter docker-compose pour PostgreSQL` |

Un commit qui casse la compatibilité (par exemple une route d'API modifiée) ajoute `!` après le type : `feat(api)!: renommer la route des favoris`.

Le corps du message, facultatif, explique **pourquoi** le changement a été fait. La User Story concernée peut y être citée : `Réf. US-07`.

**Vérification automatique :** le format est contrôlé à chaque commit par [commitlint](https://commitlint.js.org/) et [Husky](https://typicode.github.io/husky/). Après avoir cloné le dépôt, lancer une fois :

```bash
npm install
```

Un commit dont le message ne respecte pas le format est alors refusé.

---

## 3. Pull Requests

- Une Pull Request vise `develop`, sauf pour une `release` ou un `hotfix`.
- Son titre suit le format des commits : `feat(spots): ajouter un spot (US-07)`.
- Sa description suit le modèle proposé (User Story, changements, vérifications).
- Le lien de la Pull Request est ajouté sur la carte Trello de la User Story.
- La Pull Request est fusionnée quand les critères d'acceptation sont remplis et que l'**intégration continue** réussit : GitHub Actions vérifie automatiquement le lint, la compilation et les tests du backend et du frontend.

**Protection des branches :** sur GitHub, `main` et `develop` sont protégées (*Settings → Branches*). Une Pull Request est obligatoire pour les modifier, et les vérifications « Backend » et « Frontend » de l'intégration continue doivent réussir.

---

## 4. Versions

Le projet suit le **versionnement sémantique** `MAJEUR.MINEUR.CORRECTIF` :

| Partie | Augmente quand… |
| --- | --- |
| MAJEUR | Un changement casse la compatibilité. `1.0.0` correspond au MVP livré. |
| MINEUR | Une fonctionnalité est ajoutée. |
| CORRECTIF | Un bug est corrigé. |

Tant que le MVP n'est pas livré, les versions restent en `0.x.y`.

### Publier une version

1. Créer `release/X.Y.Z` depuis `develop`.
2. Mettre à jour le numéro dans `package.json` et compléter le [journal des versions](CHANGELOG.md).
3. Fusionner dans `main` par Pull Request, puis ajouter l'étiquette :
   ```bash
   git switch main
   git pull
   git tag -a vX.Y.Z -m "vX.Y.Z — titre de la version"
   git push origin vX.Y.Z
   ```
4. Fusionner `main` dans `develop`, pour que `develop` contienne aussi les changements de la version.

---

## 5. Lien avec le suivi de projet

Le backlog est suivi dans **Trello** (voir le [backlog](docs/backlog.md)). Le chemin d'une User Story est le suivant :

```
Carte Trello US-XX → branche feature/US-XX-… → commits → Pull Request → develop → version sur main
```

La carte passe de « À faire » à « En cours » à la création de la branche, puis à « En test » à l'ouverture de la Pull Request, et enfin à « Terminé » à la fusion.
