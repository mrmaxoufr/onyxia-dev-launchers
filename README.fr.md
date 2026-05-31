# Onyxia Dev Launchers

> Scripts et modèles orientés développement pour [Onyxia](https://www.onyxia.sh/) et [SSP Cloud](https://datalab.sspcloud.fr/).

[🇬🇧 Read the English version](./README.md)

## Sommaire

* [Vue d’ensemble](#vue-densemble)
* [Pourquoi ce projet ?](#pourquoi-ce-projet-)
* [État du projet](#état-du-projet)
* [Lanceurs disponibles](#lanceurs-disponibles)
* [Documentation](#documentation)
* [Structure du dépôt](#structure-du-dépôt)
* [Démarrage rapide](#démarrage-rapide)
* [Exemples de cas d’usage](#exemples-de-cas-dusage)
* [Liens utiles](#liens-utiles)
* [Feuille de route](#feuille-de-route)
* [Contribution](#contribution)
* [Licence](#licence)

## Vue d’ensemble

**Onyxia Dev Launchers** est une collection de scripts, de modèles et d’aides à la configuration conçus pour initialiser rapidement des environnements adaptés au développement sur des plateformes basées sur Onyxia.

L’objectif de ce projet est de compléter les services existants orientés data science disponibles sur Onyxia / SSP Cloud avec des environnements davantage orientés développement logiciel.

Par exemple :

* un environnement VS Code Python solide avec `uv`, `ruff`, `pytest` et des outils modernes ;
* un environnement Java prêt à l’emploi avec JDK, Maven et Gradle ;
* des environnements orientés backend pour FastAPI ou Spring Boot ;
* des environnements orientés frontend pour Node.js, TypeScript ou React ;
* des scripts de configuration réutilisables pour l’enseignement, les projets, le prototypage et les workflows de développement.

## Pourquoi ce projet ?

Onyxia permet de lancer facilement des environnements de travail dans le cloud comme JupyterLab, RStudio, VS Code, des bases de données et d’autres services conteneurisés.

Cependant, de nombreux services par défaut sont principalement orientés vers des workflows de data science.

Ce dépôt explore une autre direction :

> faire d’Onyxia une plateforme pratique non seulement pour la data science, mais aussi pour le développement logiciel.

Au lieu d’installer manuellement les outils à chaque lancement d’un nouveau service, ce dépôt fournit des scripts qui préparent automatiquement l’espace de travail.

## État du projet

Ce projet est actuellement à un stade expérimental précoce.

Le premier objectif est de fournir des scripts shell simples, lisibles et réutilisables.

Par la suite, le projet pourra évoluer vers :

* des images Docker personnalisées ;
* des charts Helm ;
* un catalogue de services compatible avec Onyxia ;
* des stacks de développement prêtes à l’emploi.

## Lanceurs disponibles

### Python

| Lanceur                             | Description                                          | Statut     |
| ----------------------------------- | ---------------------------------------------------- | ---------- |
| `vscode-python-uv-minimal.sh`       | Installer `uv` et une boîte à outils Python minimale | Disponible |
| `vscode-python-dev-tools.sh`        | Installer une boîte à outils Python plus complète    | Disponible |
| `vscode-python-fastapi.sh`          | Créer un petit projet FastAPI                        | Disponible |
| `vscode-python-data-dev.sh`         | Créer un projet Python orienté data                  | Disponible |
| `vscode-python-software-project.sh` | Créer un projet structuré de conception logicielle   | Disponible |

### Environnements prévus

| Environnement        | Description                        | Statut |
| -------------------- | ---------------------------------- | ------ |
| `vscode-java-maven`  | Java, JDK, Maven                   | Prévu  |
| `vscode-java-gradle` | Java, JDK, Gradle                  | Prévu  |
| `vscode-node`        | Node.js, npm, pnpm, TypeScript     | Prévu  |
| `vscode-spring-boot` | Java, Spring Boot, Maven ou Gradle | Prévu  |
| `vscode-react`       | Node.js, React, TypeScript         | Prévu  |
| `vscode-rust`        | Rust, cargo, clippy                | Prévu  |
| `vscode-cpp`         | C/C++, CMake, gdb                  | Prévu  |

## Documentation

Une documentation détaillée est disponible dans le dossier [`docs/`](./docs/).

| Document                                         | Description                                 |
| ------------------------------------------------ | ------------------------------------------- |
| [Python launchers](./docs/python-launchers.md)   | Documentation anglaise des lanceurs Python  |
| [Lanceurs Python](./docs/python-launchers.fr.md) | Documentation française des lanceurs Python |

## Structure du dépôt

Le dépôt suivra progressivement cette structure :

```text
onyxia-dev-launchers/
├── README.md
├── README.fr.md
├── LICENSE
├── .gitignore
├── scripts/
│   ├── python/
│   │   ├── vscode-python-uv-minimal.sh
│   │   ├── vscode-python-dev-tools.sh
│   │   ├── vscode-python-fastapi.sh
│   │   ├── vscode-python-data-dev.sh
│   │   └── vscode-python-software-project.sh
│   ├── java/
│   │   └── vscode-java-maven.sh
│   ├── node/
│   │   └── vscode-node.sh
│   └── misc/
├── templates/
│   ├── python/
│   ├── java/
│   └── node/
├── docker/
└── docs/
    ├── python-launchers.md
    └── python-launchers.fr.md
```

## Démarrage rapide

Les scripts sont conçus pour être exécutés directement depuis un terminal VS Code Onyxia ou via une URL de lancement Onyxia.

Exemple :

```bash
curl -LsSf https://raw.githubusercontent.com/mrmaxoufr/onyxia-dev-launchers/main/scripts/python/vscode-python-dev-tools.sh | bash
```

Exemple de projet FastAPI :

```bash
curl -LsSf https://raw.githubusercontent.com/mrmaxoufr/onyxia-dev-launchers/main/scripts/python/vscode-python-fastapi.sh | bash
```

Exemple de projet orienté data :

```bash
curl -LsSf https://raw.githubusercontent.com/mrmaxoufr/onyxia-dev-launchers/main/scripts/python/vscode-python-data-dev.sh | bash
```

Exemple de projet structuré de conception logicielle :

```bash
curl -LsSf https://raw.githubusercontent.com/mrmaxoufr/onyxia-dev-launchers/main/scripts/python/vscode-python-software-project.sh | bash
```

## Exemples de cas d’usage

Ce dépôt peut être utile pour :

* des étudiants travaillant sur des projets de programmation ;
* des enseignants préparant des environnements de développement reproductibles ;
* des développeurs qui veulent un espace de travail cloud prêt à l’emploi ;
* des utilisateurs qui veulent étendre Onyxia au-delà des workflows classiques de data science ;
* des équipes recherchant des scripts d’initialisation de projet légers et partageables.

## Liens utiles

* [Site web d’Onyxia](https://www.onyxia.sh/)
* [Documentation d’Onyxia](https://docs.onyxia.sh/)
* [Dépôt GitHub d’Onyxia](https://github.com/InseeFrLab/onyxia)
* [SSP Cloud](https://datalab.sspcloud.fr/)

## Feuille de route

### Étape 1 — Lanceurs Python

* [x] Ajouter un script minimal Python + uv
* [x] Ajouter un script d’outillage Python pour le développement
* [x] Ajouter un lanceur de projet FastAPI
* [x] Ajouter un lanceur de projet Python orienté data
* [x] Ajouter un lanceur de projet Python structuré de conception logicielle
* [x] Ajouter la documentation des lanceurs Python

### Étape 2 — Lanceurs Java

* [ ] Ajouter un script Java + Maven
* [ ] Ajouter un script Java + Gradle
* [ ] Ajouter un lanceur de projet Spring Boot
* [ ] Ajouter la documentation des lanceurs Java

### Étape 3 — Lanceurs Node.js et frontend

* [ ] Ajouter un script Node.js / TypeScript
* [ ] Ajouter un lanceur de projet React
* [ ] Ajouter la documentation des lanceurs frontend

### Étape 4 — Images réutilisables

* [ ] Créer des images Docker pour certains environnements
* [ ] Documenter comment les utiliser dans Onyxia
* [ ] Ajouter des conventions de versionnement

### Étape 5 — Intégration Onyxia

* [ ] Explorer l’intégration avec des charts Helm
* [ ] Fournir des exemples de configuration compatibles avec Onyxia
* [ ] Construire un petit catalogue de services orienté développement

## Contribution

Les contributions, idées et améliorations sont les bienvenues.

Vous pouvez contribuer en :

* proposant de nouveaux environnements de développement ;
* améliorant les scripts existants ;
* ajoutant de la documentation ;
* testant les scripts sur Onyxia / SSP Cloud ;
* signalant des bugs ou des limites.

Avant de contribuer, merci de garder les scripts :

* simples ;
* lisibles ;
* reproductibles ;
* sûrs à exécuter dans un espace de travail vierge.

## Licence

Ce projet est distribué sous licence MIT.

Voir [`LICENSE`](./LICENSE) pour plus d’informations.
