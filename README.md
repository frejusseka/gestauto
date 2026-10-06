# GESTAUTO

GESTAUTO est une application Flutter de gestion de flotte destinée aux gestionnaires de véhicules utilisés notamment pour le VTC et la livraison.

L'application permet de suivre les véhicules, les versements attendus, les dépenses, les pannes, les entretiens et les alertes administratives et techniques.

Le projet est réalisé dans le cadre du projet Flutter **« App connectée avec backend réel »**.

---

## Fonctionnalités

### Authentification

- Inscription d'un utilisateur
- Connexion
- Déconnexion
- Authentification par JWT
- Protection des routes de l'API
- Gestion du jeton de session côté Flutter

### Gestion des véhicules

- Ajout d'un véhicule
- Consultation des véhicules
- Modification d'un véhicule
- Suppression d'un véhicule
- Gestion des voitures et motos
- Suivi du kilométrage
- Suivi du statut du véhicule
- Montant de versement attendu
- Association d'une photo au véhicule

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

### Entretiens

- Enregistrement des entretiens
- Type d'entretien
- Date
- Kilométrage
- Montant
- Prochaine échéance kilométrique
- Prochaine échéance de date
- Notes

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
    ├── entretiens/
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

Le dépôt choisit la source de données appropriée :

```text
Connexion disponible
        ↓
   API distante
        ↓
   Mise à jour du cache
        ↓
      Données

Connexion indisponible
        ↓
    Cache local
        ↓
      Données
```

Lorsque l'API est indisponible, le dépôt tente d'utiliser les données présentes dans le cache local. Si aucune donnée locale n'est disponible, l'erreur est transmise à la présentation afin qu'un état d'erreur soit affiché à l'utilisateur.

Cette organisation permet notamment de conserver une séparation claire entre la logique métier, l'accès aux données et l'interface utilisateur.

---

## Backend

Le backend est développé avec :

- Dart
- Dart Frog
- PostgreSQL
- JWT
- bcrypt
- UUID

Le backend est intégré directement dans le dépôt principal :

```text
backend/
├── lib/
├── routes/
├── test/
├── schema.sql
├── pubspec.yaml
└── README.md
```

Le backend possède sa propre architecture :

```text
lib/
├── coeur/
├── domaine/
└── donnees/
```

Les routes protégées nécessitent un jeton JWT valide.

L'authentification et les données sont stockées dans PostgreSQL.

---

## Base de données PostgreSQL

La base de données utilisée par le backend est PostgreSQL.

La base principale utilisée localement est :

```text
gestauto
```

Le projet contient le fichier :

```text
backend/schema.sql
```

Ce fichier contient le schéma PostgreSQL nécessaire au fonctionnement du backend et permet de recréer la structure de la base dans un environnement vierge.

Les principales tables sont notamment :

```text
utilisateurs
vehicules
versements
depenses
categories_depenses
pannes
entretiens
documents
types_documents
```

### Import du schéma

Après avoir créé la base `gestauto`, le schéma peut être importé avec PostgreSQL :

```bash
psql -U postgres -d gestauto -f backend/schema.sql
```

Le mot de passe PostgreSQL doit être fourni par l'environnement local.

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

### Authentification

```text
/api/auth/inscription
/api/auth/connexion
```

### Ressources protégées

```text
/api/protegee/vehicules
/api/protegee/versements
/api/protegee/depenses
/api/protegee/categories_depenses
/api/protegee/pannes
/api/protegee/entretiens
/api/protegee/tableau_de_bord
/api/protegee/alertes
```

### Écrans Flutter connectés à l'API

L'application utilise notamment l'API réelle pour alimenter :

- l'écran des véhicules ;
- l'écran des versements ;
- l'écran des dépenses ;
- l'écran des pannes ;
- l'écran des entretiens ;
- le tableau de bord ;
- les alertes.

Les données affichées dans ces écrans ne reposent donc pas uniquement sur des données fictives intégrées à l'interface.

---

## Communication avec l'API

L'application Flutter utilise **Dio** pour communiquer avec le backend.

Un intercepteur réseau permet notamment d'ajouter automatiquement le jeton JWT aux requêtes authentifiées.

Le jeton de session est conservé localement afin de maintenir la session de l'utilisateur.

Le backend vérifie le jeton avant d'autoriser l'accès aux routes protégées.

---
## Gestion de l'état Flutter

L'application utilise principalement `ChangeNotifier` pour gérer l'état des écrans Flutter.

Les contrôleurs de présentation centralisent l'état nécessaire à chaque écran et utilisent `notifyListeners()` pour informer l'interface lorsqu'une donnée ou un état change.

Le flux général est le suivant :

```text
Interface Flutter
       ↓
Contrôleur de présentation
       ↓
Cas d'utilisation
       ↓
Dépôt (Repository)
       ↓
API distante / Cache local
```

Un contrôleur peut notamment exposer les états suivants :

```text
chargement
erreur
données
création en cours
source des données (API ou cache local)
```

Par exemple, pour la gestion des véhicules, le contrôleur charge les données via le cas d'utilisation, conserve la liste des véhicules et indique à l'interface si les données proviennent de l'API distante ou du cache local.

Cette approche permet de séparer la gestion de l'état de l'interface graphique tout en conservant une organisation simple et adaptée au périmètre de la première version.
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

Lorsqu'une requête distante échoue et que des données sont disponibles localement, le dépôt utilise les données mises en cache.

Dans ce cas, l'interface des véhicules indique explicitement que les données affichées proviennent du **cache local** et que l'application fonctionne en **mode hors ligne**.

Si l'API est indisponible et qu'aucune donnée locale n'est disponible, l'erreur est transmise à l'interface.

Ce mécanisme permet à l'application de conserver un fonctionnement utile lorsque le réseau ou le backend est momentanément indisponible.

---

## Gestion des erreurs réseau

Les accès aux données distantes passent par la couche des dépôts.

Lorsqu'une requête API échoue :

1. l'erreur réseau est détectée ;
2. le dépôt tente d'utiliser les données locales disponibles ;
3. si des données locales existent, elles sont affichées et l'interface indique le mode hors ligne ;
4. si aucune donnée locale n'est disponible, l'erreur est transmise à la couche de présentation.

Dans ce dernier cas, l'écran affiche un état d'erreur explicite avec un message indiquant que les véhicules ne peuvent pas être chargés et un bouton **« Réessayer »** permettant de relancer la requête.

Cette organisation évite de placer directement la logique réseau dans les écrans Flutter.

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

### Intégration continue

- GitHub Actions
- Flutter
- Dart
- PostgreSQL

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

Depuis la racine du projet :

```bash
flutter pub get
```

### 3. Configurer PostgreSQL

Créer une base de données PostgreSQL nommée :

```text
gestauto
```

Puis importer le schéma :

```bash
psql -U postgres -d gestauto -f backend/schema.sql
```

### 4. Configurer les variables d'environnement du backend

Le backend utilise notamment les variables d'environnement :

```text
GESTAUTO_DB_PASSWORD
GESTAUTO_JWT_SECRET
```

Ces valeurs doivent être définies dans l'environnement local avant de lancer le backend.

Exemple PowerShell :

```powershell
$env:GESTAUTO_DB_PASSWORD = "mot_de_passe_postgresql"
$env:GESTAUTO_JWT_SECRET = "secret_jwt_local"
```

Les valeurs utilisées dans cet exemple sont uniquement des exemples locaux.

**Ne jamais publier de véritables secrets dans Git ou dans le dépôt GitHub.**

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

Pour revenir à la racine :

```bash
cd ..
```

---

## Lancer l'application Flutter

Dans un autre terminal, depuis la racine du projet :

```bash
flutter run
```

L'application Flutter communique alors avec le backend configuré localement.

---

## Tests

Le projet possède des tests automatisés couvrant les principales couches de l'application.

### Tests Flutter

Depuis la racine du projet :

```bash
flutter test
```

Les tests couvrent notamment :

- les entités du domaine ;
- les cas d'utilisation ;
- les dépôts ;
- les sources de données ;
- l'authentification ;
- les écrans principaux ;
- le cache local ;
- le comportement hors ligne ;
- la gestion des erreurs réseau.

**Dernière vérification locale : 74 tests Flutter passent.**

### Tests backend

Depuis le dossier `backend` :

```bash
dart test
```

Les tests backend couvrent notamment :

- les dépôts PostgreSQL ;
- l'authentification ;
- les véhicules ;
- les versements ;
- les dépenses ;
- les catégories de dépenses ;
- les pannes ;
- les entretiens ;
- les contrôles d'autorisation.

**Dernière vérification locale : 41 tests backend passent.**

### Analyse statique Flutter

Depuis la racine du projet :

```bash
flutter analyze lib test
```

L'analyse Flutter ne doit produire aucune erreur.

### Analyse statique backend

Depuis le dossier `backend` :

```bash
dart analyze
```

---

## Intégration continue — GitHub Actions

Le projet utilise GitHub Actions afin de vérifier automatiquement le code lors des `push` et des `pull requests` vers `main`.

Le workflow se trouve dans :

```text
.github/workflows/verification.yml
```

### Vérification Flutter

La CI :

1. installe Flutter ;
2. installe les dépendances ;
3. exécute l'analyse statique ;
4. exécute les tests Flutter.

### Vérification backend

La CI :

1. démarre un service PostgreSQL ;
2. crée la base `gestauto` ;
3. charge `backend/schema.sql` ;
4. installe Dart ;
5. installe les dépendances backend ;
6. exécute `dart analyze` ;
7. exécute `dart test`.

Cette configuration permet de vérifier le backend dans une base PostgreSQL propre, indépendamment des données présentes sur la machine du développeur.

### État actuel de la CI

Les deux vérifications suivantes sont actuellement validées :

```text
Vérification Flutter       ✅
Vérification backend       ✅
```

---

## Organisation Git

Le développement est organisé par étapes fonctionnelles.

Les principales étapes sont enregistrées dans Git afin de conserver un historique clair de l'évolution du projet.

Le dépôt principal contient à la fois :

```text
gestauto/
├── lib/                    # Application Flutter
├── test/                   # Tests Flutter
├── backend/                # Backend Dart Frog
├── .github/workflows/      # CI GitHub Actions
├── assets/                 # Ressources de l'application
├── pubspec.yaml            # Dépendances Flutter
└── README.md
```

Le dossier `backend` fait partie du même dépôt Git que l'application Flutter.

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

### Version livrable

- Authentification JWT : ✅
- API REST réelle : ✅
- PostgreSQL : ✅
- Gestion des véhicules : ✅
- Versements : ✅
- Dépenses : ✅
- Catégories de dépenses : ✅
- Pannes : ✅
- Entretiens : ✅
- Alertes : ✅
- Tableau de bord : ✅
- Cache local Hive : ✅
- Mode hors ligne : ✅
- Indication visuelle du mode hors ligne : ✅
- Gestion des erreurs réseau : ✅
- État d'erreur avec bouton « Réessayer » : ✅
- Tests automatisés Flutter : ✅
- Tests automatisés backend : ✅
- Analyse statique Flutter : ✅
- Analyse statique backend : ✅
- CI GitHub Actions : ✅

### Tests validés

```text
Tests Flutter       : 74
Tests backend       : 41
Total               : 115
```

La CI GitHub valide actuellement les deux parties du projet :

```text
Flutter + tests + analyse       ✅
Backend + PostgreSQL + tests    ✅
```

---

## Périmètre de la première version

La première version livrable se concentre sur la gestion opérationnelle de la flotte :

```text
Utilisateur
    │
    ▼
Véhicules
    │
    ├── Versements
    ├── Dépenses
    ├── Pannes
    ├── Entretiens
    └── Documents / Alertes
```

Les fonctionnalités plus avancées sont volontairement réservées aux évolutions futures afin de conserver un périmètre cohérent et stable pour cette première version.

---

## Licence

Projet réalisé dans le cadre de l'apprentissage et du projet Flutter **« App connectée avec backend réel »**.