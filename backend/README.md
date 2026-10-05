# GESTAUTO — Backend

Backend de l'application **GESTAUTO**, une application Flutter de gestion de flotte.

Le backend fournit une API REST réelle permettant à l'application Flutter de gérer l'authentification, les véhicules, les versements, les dépenses, les pannes, les alertes et le tableau de bord.

---

## Technologies

Le backend utilise :

- Dart
- Dart Frog
- PostgreSQL
- JWT
- bcrypt
- UUID

Les tests utilisent notamment :

- Dart Test
- Mocktail

---

## Architecture

Le backend est organisé autour d'une séparation entre le domaine, les données et les éléments techniques :

```text
backend/
├── lib/
│   ├── coeur/
│   ├── domaine/
│   └── donnees/
│
├── routes/
│   ├── api/
│   │   ├── auth/
│   │   └── protegee/
│   └── index.dart
│
├── test/
│
├── pubspec.yaml
└── README.md
```

### Domaine

Le domaine contient notamment :

- les entités ;
- les dépôts abstraits ;
- les cas d'utilisation.

### Données

La couche données contient notamment :

- les implémentations des dépôts ;
- l'accès à PostgreSQL ;
- les services liés aux données.

### Routes

Les routes Dart Frog exposent l'API REST.

Les routes protégées utilisent un middleware d'authentification JWT.

---

## API

### Route principale

```text
GET /api
```

Cette route permet de vérifier que l'API GESTAUTO est opérationnelle.

### Authentification

```text
POST /api/auth/inscription
POST /api/auth/connexion
```

L'inscription crée un utilisateur et ses catégories de dépenses par défaut.

La connexion retourne un jeton JWT.

### Routes protégées

Les principales ressources protégées sont :

```text
/api/protegee/vehicules
/api/protegee/versements
/api/protegee/depenses
/api/protegee/categories_depenses
/api/protegee/pannes
/api/protegee/tableau_de_bord
/api/protegee/alertes
```

Ces routes nécessitent un en-tête d'authentification :

```text
Authorization: Bearer <JWT>
```

---

## Base de données

Le backend utilise **PostgreSQL**.

La base utilisée par le projet est :

```text
gestauto
```

La connexion PostgreSQL utilise la variable d'environnement :

```text
GESTAUTO_DB_PASSWORD
```

Le secret utilisé pour signer et vérifier les JWT est défini avec :

```text
GESTAUTO_JWT_SECRET
```

**Les valeurs réelles de ces variables ne doivent jamais être publiées dans Git.**

---

## Installation

Depuis la racine du projet :

```bash
cd backend
```

Installer les dépendances :

```bash
dart pub get
```

Configurer PostgreSQL et les variables d'environnement nécessaires :

```text
GESTAUTO_DB_PASSWORD
GESTAUTO_JWT_SECRET
```

---

## Lancer le backend

Depuis le dossier `backend` :

```bash
dart_frog dev
```

L'API est alors disponible localement.

---

## Tests

Depuis le dossier `backend` :

```bash
dart test
```

Les tests couvrent notamment :

- les dépôts ;
- les services ;
- l'authentification ;
- les routes ;
- l'accès à PostgreSQL.

---

## Analyse statique

Pour analyser le code backend :

```bash
dart analyze
```

---

## Relation avec l'application Flutter

L'application Flutter située à la racine du projet communique avec ce backend grâce à **Dio**.

Le flux général est :

```text
Application Flutter
        │
        │ HTTP / Dio
        ▼
Backend Dart Frog
        │
        ▼
Authentification JWT
        │
        ▼
PostgreSQL
```

Pour les requêtes protégées :

```text
Flutter
  │
  │ Authorization: Bearer JWT
  ▼
Middleware JWT
  │
  ▼
Route protégée
  │
  ▼
Dépôt
  │
  ▼
PostgreSQL
```

---

## Sécurité

Les mots de passe utilisateurs sont hachés avec **bcrypt**.

Les routes protégées vérifient la validité du JWT avant d'autoriser l'accès aux données.

Les secrets de connexion PostgreSQL et de signature JWT sont fournis par les variables d'environnement et ne doivent pas être stockés dans le dépôt.

---

## Version

Version actuelle du backend :

```text
1.0.0+1
```

Le backend fait partie intégrante du dépôt principal GESTAUTO.

Dépôt GitHub :

```text
https://github.com/frejusseka/gestauto
```