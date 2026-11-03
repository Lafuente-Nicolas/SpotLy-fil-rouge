# Analyse des impacts environnementaux et pistes d'amélioration

## Analyse des impacts

Le parcours utilisateur étudié repose principalement sur l'utilisation d'une carte interactive et l'affichage de contenus publiés par la communauté. Certains éléments présentent un impact plus important que d'autres sur la consommation de ressources.

| Élément                        | Impact estimé | Justification                                                                         |
| ------------------------------ | ------------- | ------------------------------------------------------------------------------------- |
| Images des spots               | Élevé         | Les photos représentent la majorité des données transférées et stockées.              |
| Carte interactive              | Élevé         | L'affichage de la carte nécessite le chargement de nombreuses tuiles cartographiques. |
| Chargement des spots           | Moyen         | Les données des spots sont récupérées depuis l'API et la base de données.             |
| Requêtes API                   | Moyen         | Les échanges entre le client et le serveur génèrent du trafic réseau.                 |
| Base de données                | Moyen         | Les recherches et filtres sollicitent régulièrement la base de données.               |
| Authentification               | Faible        | Fonction utilisée ponctuellement grâce à la persistance de session.                   |
| Favoris, notes et commentaires | Faible        | Peu de données échangées lors de ces actions.                                         |

L'analyse met en évidence que les images et la carte interactive constituent les principaux postes d'impact du projet.

---

## Pistes d'amélioration

Afin de réduire l'impact environnemental de l'application, plusieurs pistes d'amélioration ont été identifiées.

| Amélioration                            | Impact attendu | Difficulté |
| --------------------------------------- | -------------- | ---------- |
| Compression automatique des images      | Élevé          | Faible     |
| Conversion des images au format WebP    | Élevé          | Faible     |
| Chargement dynamique des spots visibles | Élevé          | Moyenne    |
| Clustering des marqueurs sur la carte   | Élevé          | Moyenne    |
| Lazy Loading des images                 | Moyen          | Faible     |
| Pagination des commentaires             | Moyen          | Faible     |
| Mise en cache des ressources            | Moyen          | Moyenne    |
| Suppression des métadonnées EXIF        | Faible         | Faible     |
| Limitation des animations               | Faible         | Faible     |
| Mode sombre optionnel                   | Faible         | Faible     |

---

## Priorisation des améliorations

Les améliorations retenues en priorité sont celles qui présentent un fort impact environnemental tout en restant relativement simples à mettre en œuvre.

### Priorité haute

* Compression automatique des images
* Conversion au format WebP
* Chargement dynamique des spots
* Clustering des marqueurs

### Priorité moyenne

* Lazy Loading
* Pagination
* Mise en cache

### Priorité faible

* Suppression des métadonnées EXIF
* Limitation des animations
* Mode sombre

---

## Conclusion

L'analyse montre que les principaux impacts environnementaux de Spotly proviennent des médias et de la cartographie. Les améliorations retenues visent principalement à réduire les volumes de données transférées, optimiser les chargements et limiter les traitements inutiles tout en conservant une expérience utilisateur fluide sur mobile.
