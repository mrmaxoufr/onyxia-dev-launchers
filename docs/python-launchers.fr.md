# Lanceurs Python

> Documentation des scripts de lancement Python fournis par **Onyxia Dev Launchers**.

[🇬🇧 Read the English version](./python-launchers.md)

## Présentation

Ce dépôt propose plusieurs scripts de lancement Python pour Onyxia / SSP Cloud.

Ils sont conçus pour préparer des environnements VS Code adaptés à différents usages Python :

- outillage Python minimal ;
- outillage général de développement ;
- développement backend avec FastAPI ;
- développement orienté data ;
- projets structurés de conception logicielle.

Ces scripts sont destinés à être exécutés dans un service VS Code Onyxia, qui tourne dans un conteneur Linux.

Ils ne sont pas destinés à être exécutés directement sur une machine Windows locale.

## Scripts disponibles

| Script | Objectif | Crée un projet ? |
|---|---|---|
| `vscode-python-uv-minimal.sh` | Installer `uv` et une boîte à outils Python minimale | Non |
| `vscode-python-dev-tools.sh` | Installer une boîte à outils Python plus complète | Non |
| `vscode-python-fastapi.sh` | Créer un petit projet FastAPI | Oui |
| `vscode-python-data-dev.sh` | Créer un projet Python orienté data | Oui |
| `vscode-python-software-project.sh` | Créer un projet structuré de conception logicielle | Oui |

## `vscode-python-uv-minimal.sh`

C’est le lanceur Python le plus simple.

Il installe :

- `uv` ;
- `ruff` ;
- `pytest` ;
- `pyright` ;
- `pre-commit`.

Il ne crée pas de projet Python.

Il prépare seulement l’environnement VS Code avec les outils de développement Python de base.

### Cas d’usage

Utilisez ce script lorsque vous voulez un environnement VS Code propre avec des outils Python modernes, sans imposer de structure de projet.

### Commandes typiques après lancement

~~~bash
uv init my-project
cd my-project
uv add requests
uv add --dev ruff pytest pyright pre-commit
~~~

## `vscode-python-dev-tools.sh`

Ce script installe une boîte à outils Python plus complète.

Il installe :

- `uv` ;
- `ruff` ;
- `pytest` ;
- `pyright` ;
- `pre-commit` ;
- `httpie`.

Il crée aussi un fichier d’aide dans l’espace de travail :

~~~text
~/work/PYTHON_DEV_TOOLS.md
~~~

Ce fichier Markdown explique comment utiliser les outils installés.

### Cas d’usage

Utilisez ce script lorsque vous voulez un environnement Python généraliste, mais que vous souhaitez partir d’un espace de travail vide.

Il est utile pour :

- des scripts ;
- des packages Python ;
- des clients d’API ;
- de l’enseignement ;
- du prototypage ;
- de petits projets logiciels.

## `vscode-python-fastapi.sh`

Ce script crée un projet FastAPI minimal.

Par défaut, il crée :

~~~text
~/work/fastapi-project
~~~

Le projet généré contient :

~~~text
fastapi-project/
├── README.md
├── pyproject.toml
├── ruff.toml
├── .env.template
├── .pre-commit-config.yaml
├── src/
│   └── app/
│       ├── __init__.py
│       └── main.py
└── tests/
    └── test_api.py
~~~

Il installe :

- `fastapi` ;
- `uvicorn[standard]` ;
- `pydantic` ;
- `python-dotenv` ;
- `ruff` ;
- `pytest` ;
- `httpx` ;
- `pyright` ;
- `pre-commit`.

L’API générée expose :

~~~text
GET  /
GET  /health
GET  /echo/{text}
POST /echo
~~~

### Lancer l’API localement

~~~bash
PYTHONPATH=src uv run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
~~~

### Lancer l’API sur SSP Cloud / Onyxia

Avec le proxy SSP Cloud, utilisez :

~~~bash
PYTHONPATH=src uv run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000 --root-path /proxy/8000
~~~

L’option `--root-path /proxy/8000` est importante, car Swagger UI doit trouver `openapi.json` derrière le proxy SSP Cloud.

### Tester les endpoints

~~~bash
curl http://localhost:8000/health
curl http://localhost:8000/echo/hello
~~~

Avec le proxy Onyxia, ouvrez :

~~~text
/proxy/8000/
/proxy/8000/docs
/proxy/8000/health
/proxy/8000/openapi.json
~~~

### Cas d’usage

Utilisez ce script lorsque vous voulez démarrer rapidement un petit backend FastAPI.

Il est idéal pour :

- des tutoriels API ;
- des prototypes backend ;
- tester des routes ;
- apprendre FastAPI ;
- exposer un petit service depuis Onyxia.

## `vscode-python-data-dev.sh`

Ce script crée un projet Python orienté data avec de bonnes pratiques de développement.

Par défaut, il crée :

~~~text
~/work/data-dev-project
~~~

La structure générée est :

~~~text
data-dev-project/
├── README.md
├── pyproject.toml
├── ruff.toml
├── .env.template
├── .pre-commit-config.yaml
├── data/
│   ├── raw/
│   └── processed/
├── notebooks/
├── src/
├── tests/
└── docs/
~~~

Il installe :

- `pandas` ;
- `polars` ;
- `duckdb` ;
- `pyarrow` ;
- `openpyxl` ;
- `matplotlib` ;
- `requests` ;
- `python-dotenv` ;
- `ipykernel` ;
- `ruff` ;
- `pytest` ;
- `pytest-mock` ;
- `pyright` ;
- `pre-commit`.

### Dossiers de données

Le projet sépare les données brutes et les données produites :

~~~text
data/raw/
data/processed/
~~~

Les fichiers de données sont ignorés par Git par défaut.

Seule la structure des dossiers est conservée avec des fichiers `.gitkeep`.

### Cas d’usage

Utilisez ce script lorsque vous voulez un projet Python orienté data qui respecte quand même de bonnes pratiques de développement logiciel.

Il est utile pour :

- l’analyse de données ;
- les scripts reproductibles ;
- le travail exploratoire ;
- les notebooks ;
- les petits pipelines de données ;
- l’enseignement ;
- les projets mêlant data science et conception logicielle.

## `vscode-python-software-project.sh`

Ce script crée un projet Python structuré de conception logicielle.

Par défaut, il crée :

~~~text
~/work/software-project
~~~

Le projet généré suit une architecture en couches :

~~~text
src/app/
├── main.py
├── config.py
├── api/
│   ├── health_router.py
│   └── item_router.py
├── models/
│   └── item.py
├── repositories/
│   └── item_repository.py
└── services/
    └── item_service.py
~~~

Le sens des dépendances est :

~~~text
api -> services -> repositories -> models
~~~

Il crée aussi :

- des tests unitaires ;
- des tests d’intégration ;
- un fichier `ruff.toml` ;
- un fichier `.pre-commit-config.yaml` ;
- un fichier `.env.template` ;
- une CI GitHub Actions ;
- des fichiers de documentation dans `docs/`.

### Cas d’usage

Utilisez ce script lorsque vous voulez un point de départ propre pour un projet de conception logicielle.

Il sert à illustrer :

- l’architecture en couches ;
- la séparation des responsabilités ;
- la logique métier dans les services ;
- l’accès aux données dans les repositories ;
- les routes API dans les routers ;
- les tests ;
- le linting ;
- le formatage ;
- le typage statique ;
- l’automatisation CI.

## Choisir le bon lanceur

| Besoin | Script recommandé |
|---|---|
| Installer seulement `uv` et les outils de base | `vscode-python-uv-minimal.sh` |
| Installer une boîte à outils Python complète sans créer de projet | `vscode-python-dev-tools.sh` |
| Démarrer une petite API FastAPI | `vscode-python-fastapi.sh` |
| Démarrer un projet orienté data | `vscode-python-data-dev.sh` |
| Démarrer un projet structuré de conception logicielle | `vscode-python-software-project.sh` |

## Commandes communes

### Lancer les tests

~~~bash
uv run pytest
~~~

### Analyser le code

~~~bash
uv run ruff check .
~~~

### Formater le code

~~~bash
uv run ruff format .
~~~

### Vérifier le typage

~~~bash
uv run pyright
~~~

### Installer les hooks pre-commit

~~~bash
uv run pre-commit install
~~~

### Lancer tous les hooks pre-commit manuellement

~~~bash
uv run pre-commit run --all-files
~~~

## Notes sur Onyxia

Ces lanceurs sont conçus pour les services Onyxia / SSP Cloud.

Ce sont des scripts Bash exécutés dans des conteneurs Linux.

Sur Windows, vous pouvez modifier et versionner les scripts avec Git, mais les scripts eux-mêmes sont faits pour être exécutés dans l’environnement Onyxia.

## Améliorations futures

Futurs lanceurs Python possibles :

- projet Python prêt pour Docker ;
- projet FastAPI + PostgreSQL ;
- projet FastAPI + React fullstack ;
- projet Django ;
- projet de web scraping ;
- projet orienté tests avec Selenium ou Playwright.
