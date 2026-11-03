# User Journeys — Spotly

Ces parcours représentent le ressenti de l'utilisateur à chaque étape, sur une échelle de 1 (difficile) à 5 (agréable). Ils correspondent aux parcours détaillés dans [3.4 Parcours utilisateurs et scénarios](3.4_Parcours_utilisateurs_et_scenarios.md).

> Dans le premier parcours, la notation et les commentaires sont des évolutions (P2) : ils ne font pas partie du MVP.

## Découverte d’un spot

```mermaid
journey
    title Trouver rapidement un spot autour de soi

    section Ouverture de l'application
      Ouvrir Spotly (session conservée): 5: Utilisateur
      Autoriser la géolocalisation: 4: Utilisateur

    section Découverte
      Consulter la carte interactive: 5: Utilisateur
      Voir les spots proches: 5: Utilisateur
      Indiquer son temps disponible: 5: Utilisateur
      Utiliser les filtres: 4: Utilisateur

    section Consultation du spot
      Ouvrir un spot: 5: Utilisateur
      Voir les photos et informations: 5: Utilisateur
      Vérifier la durée et la distance: 5: Utilisateur

    section Interaction
      Ajouter le spot en favoris: 5: Utilisateur
      Noter ou commenter le spot: 4: Utilisateur
```
![Diagramme](img/Diagramme-TrouverUnSpot.png)

## Publication d’un spot

```mermaid
journey
    title Publier un nouveau spot

    section Connexion
      Ouvrir Spotly: 5: Utilisateur
      Se connecter à son compte: 4: Utilisateur

    section Création du spot
      Cliquer sur ajouter un spot: 5: Utilisateur
      Ajouter un titre et une description: 4: Utilisateur
      Ajouter 1 à 5 photos: 4: Utilisateur
      Sélectionner une catégorie: 4: Utilisateur

    section Localisation
      Ajouter la position GPS: 5: Utilisateur
      Indiquer la durée estimée: 4: Utilisateur
      Ajouter des tags (facultatif): 4: Utilisateur

    section Publication
      Vérifier les informations: 4: Utilisateur
      Publier le spot: 5: Utilisateur
      Voir le spot apparaître sur la carte: 5: Utilisateur
```
![Diagramme](img/Diagramme-PublierUnSpot.png)
