# GESTAUTO

GESTAUTO est une application Flutter de gestion de flotte destinée aux gestionnaires de véhicules utilisés notamment pour le VTC et la livraison.

L'application permet de suivre les véhicules, les versements attendus, les dépenses, les pannes, les entretiens et les alertes administratives et techniques.

Le projet est réalisé dans le cadre du projet Flutter « App connectée avec backend réel ».

---

## Fonctionnalités

### Authentification

- Inscription d'un utilisateur
- Connexion
- Déconnexion
- Authentification par JWT
- Protection des routes de l'API

### Gestion des véhicules

- Ajout d'un véhicule
- Consultation des véhicules
- Modification d'un véhicule
- Suppression d'un véhicule
- Gestion des voitures et motos
- Suivi du kilométrage
- Suivi du statut du véhicule
- Montant de versement attendu

### Versements

- Enregistrement des versements
- Montant attendu
- Montant effectivement versé
- Calcul de l'écart
- Détection des versements conformes ou en infraction

### Dépenses

- Enregistrement des dépenses
- Association à un véhicule
- Catégories de dépenses
- Création de catégories personnalisées
- Catégories par défaut :
  - Carburant
  - Entretien
  - Réparation
  - Assurance
  - Patente

### Pannes

- Déclaration d'une panne
- Niveau de gravité
- Suivi de la résolution
- Date de résolution
- Modification et suppression d'une panne

### Tableau de bord et alertes

- Tableau de bord de la flotte
- Suivi des performances
- Alertes administratives
- Alertes de maintenance
- Suivi des véhicules nécessitant une intervention

---

## Architecture

Le projet Flutter utilise une architecture inspirée de la **Clean Architecture**, avec une séparation entre le domaine, les données et la présentation.

```text
lib/
├── coeur/
│   ├── di/
│   ├── erreurs/
│   ├── reseau/
│   ├── stockage/
│   └── theme/
│
├── domaine/
│   ├── entites/
│   ├── depots/
│   └── cas_utilisation/
│
├── donnees/
│   ├── modeles/
│   ├── sources/
│   │   ├── distantes/
│   │   └── locales/
│   └── depots/
│
└── presentation/
    ├── authentification/
    ├── accueil/
    ├── vehicules/
    ├── versements/
    ├── depenses/
    ├── pannes/
    └── widgets/
```

### Principe de fonctionnement

```text
Présentation
     ↓
Cas d'utilisation
     ↓
Dépôts (Repository)
     ↓
Sources de données
     ↓
API distante / Cache local
```

La couche domaine ne dépend pas directement de l'API ou de la base de données.

Les dépôts servent d'intermédiaires entre le domaine et les sources de données.

---

## Backend

Le backend est développé avec :

- Dart
- Dart Frog
- PostgreSQL
- JWT
- bcrypt

Le backend est intégré directement dans le dépôt principal :

```text
backend/
├── lib/
├── routes/
├── test/
├── pubspec.yaml
└── README.md
```

Le backend possède sa propre architecture séparée :

```text
lib/
├── coeur/
├── domaine/
└── donnees/
```

Les routes protégées nécessitent un jeton JWT valide.

---

## API principale

Les routes sont organisées sous :

```text
/api
```

Les routes nécessitant une authentification sont organisées sous :

```text
/api/protegee
```

Principales ressources :

```text
/api/auth/inscription
/api/auth/connexion

/api/protegee/vehicules
/api/protegee/versements
/api/protegee/depenses
/api/protegee/categories_depenses
/api/protegee/pannes
/api/protegee/tableau_de_bord
/api/protegee/alertes
```

---

## Communication avec l'API

L'application Flutter utilise **Dio** pour communiquer avec le backend.

Un intercepteur réseau permet notamment d'ajouter automatiquement le jeton JWT aux requêtes authentifiées.

Le jeton de session est conservé localement afin de maintenir la session de l'utilisateur.

---

## Cache local et mode hors ligne

GESTAUTO utilise **Hive** pour le stockage local.

Les données des véhicules récupérées depuis l'API sont mises en cache localement.

Le fonctionnement est le suivant :

```text
              API disponible
                    │
                    ▼
              API distante
                    │
                    ▼
             Mise à jour cache
                    │
                    ▼
             Données affichées


              API indisponible
                    │
                    ▼
              Cache local
                    │
                    ▼
             Données affichées
```

Ainsi, lorsqu'une requête distante échoue et que des données sont disponibles localement, l'application peut utiliser les données mises en cache.

---

## Technologies utilisées

### Application mobile

- Flutter
- Dart
- Dio
- Hive
- Shared Preferences

### Backend

- Dart
- Dart Frog
- PostgreSQL
- JWT
- bcrypt
- UUID

### Tests

- Flutter Test
- Dart Test
- Mocktail

---

## Prérequis

Pour exécuter le projet, il faut disposer de :

- Flutter
- Dart
- PostgreSQL
- Dart Frog CLI

Vérifier Flutter :

```bash
flutter --version
```

Vérifier Dart :

```bash
dart --version
```

Vérifier Dart Frog :

```bash
dart_frog --version
```

---

## Installation

### 1. Cloner le projet

```bash
git clone https://github.com/frejusseka/gestauto.git
cd gestauto
```

### 2. Installer les dépendances Flutter

```bash
flutter pub get
```

### 3. Configurer PostgreSQL

Créer une base de données PostgreSQL nommée :

```text
gestauto
```

Créer ensuite les tables nécessaires à partir de la structure SQL utilisée par le backend.

### 4. Configurer les variables d'environnement du backend

Le backend utilise notamment les variables d'environnement :

```text
GESTAUTO_DB_PASSWORD
GESTAUTO_JWT_SECRET
```

Ces valeurs doivent être définies dans l'environnement local avant de lancer le backend.

**Ne jamais publier les secrets dans Git.**

---

## Lancer le backend

Depuis la racine du projet :

```bash
cd backend
```

Puis lancer Dart Frog :

```bash
dart_frog dev
```

Le backend est alors disponible localement.

Pour revenir à la racine du projet :

```bash
cd ..
```

---

## Lancer l'application Flutter

Dans un autre terminal, depuis la racine du projet :

```bash
flutter run
```

---

## Tests

### Tests Flutter

Depuis la racine du projet :

```bash
flutter test
```

Le projet contient des tests couvrant notamment :

- les entités du domaine ;
- les cas d'utilisation ;
- les dépôts ;
- les sources de données ;
- l'authentification ;
- le cache local ;
- le comportement hors ligne.

### Tests backend

Depuis la racine du projet :

```bash
cd backend
dart test
```

### Vérification de l'analyse statique Flutter

Depuis la racine du projet :

```bash
flutter analyze lib test
```

L'application Flutter doit être exempte d'erreurs d'analyse.

### Vérification de l'analyse statique du backend

Depuis le dossier `backend` :

```bash
dart analyze
```

---

## Organisation Git

Le développement est organisé par étapes fonctionnelles.

Les principales étapes sont enregistrées dans Git afin de conserver un historique clair de l'évolution du projet.

---

## Objectif du projet

GESTAUTO a été conçu comme une base fonctionnelle pouvant évoluer progressivement vers une solution complète de gestion de flotte.

Les évolutions possibles comprennent notamment :

- gestion avancée des conducteurs ;
- infractions routières et radars ;
- statistiques avancées ;
- rapports PDF et Excel ;
- notifications ;
- géolocalisation ;
- gestion du carburant ;
- gestion multi-utilisateurs ;
- déploiement du backend ;
- synchronisation et fonctionnalités hors ligne plus avancées.

Ces fonctionnalités ne font pas partie du périmètre fonctionnel principal de la première version livrable.

---

## État du projet

Version livrable du projet Flutter :

- Authentification JWT : ✅
- API REST réelle : ✅
- PostgreSQL : ✅
- Gestion des véhicules : ✅
- Versements : ✅
- Dépenses : ✅
- Catégories de dépenses : ✅
- Pannes : ✅
- Alertes : ✅
- Tableau de bord : ✅
- Cache local Hive : ✅
- Mode hors ligne : ✅
- Tests automatisés : ✅
- Analyse statique : ✅

Le projet est destiné à continuer d'évoluer après la validation de cette première version.