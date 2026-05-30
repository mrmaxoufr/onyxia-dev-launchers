# Onyxia Dev Launchers

> Developer-oriented scripts and templates for [Onyxia](https://www.onyxia.sh/) and [SSP Cloud](https://datalab.sspcloud.fr/).

[🇫🇷 Lire la version française](./README.fr.md)

## Table of contents

* [Overview](#overview)
* [Why this project?](#why-this-project)
* [Project status](#project-status)
* [Available launchers](#available-launchers)
* [Documentation](#documentation)
* [Repository structure](#repository-structure)
* [Quick start](#quick-start)
* [Example use cases](#example-use-cases)
* [Useful links](#useful-links)
* [Roadmap](#roadmap)
* [Contributing](#contributing)
* [License](#license)

## Overview

**Onyxia Dev Launchers** is a collection of scripts, templates and configuration helpers designed to quickly bootstrap development-friendly environments on Onyxia-based platforms.

The goal of this project is to complement the existing data science-oriented services available on Onyxia / SSP Cloud with more software development-oriented environments.

For example:

* a solid VS Code Python environment with `uv`, `ruff`, `pytest` and modern tooling;
* a ready-to-use Java environment with JDK, Maven and Gradle;
* backend-oriented environments for FastAPI or Spring Boot;
* frontend-oriented environments for Node.js, TypeScript or React;
* reusable setup scripts for teaching, projects, prototyping and development workflows.

## Why this project?

Onyxia makes it easy to launch cloud-based working environments such as JupyterLab, RStudio, VS Code, databases and other containerized services.

However, many default services are mainly focused on data science workflows.

This repository explores another direction:

> making Onyxia a convenient platform not only for data science, but also for software development.

Instead of manually installing tools every time a new service is launched, this repository provides scripts that automatically prepare the workspace.

## Project status

This project is currently in an early experimental stage.

The first objective is to provide simple, readable and reusable shell scripts.

Later, the project may evolve toward:

* custom Docker images;
* Helm charts;
* an Onyxia-compatible service catalog;
* ready-to-use development stacks.

## Available launchers

### Python

| Launcher                            | Description                                      | Status    |
| ----------------------------------- | ------------------------------------------------ | --------- |
| `vscode-python-uv-minimal.sh`       | Install `uv` and a minimal Python toolchain      | Available |
| `vscode-python-dev-tools.sh`        | Install a broader Python development toolbox     | Available |
| `vscode-python-fastapi.sh`          | Create a small FastAPI project                   | Available |
| `vscode-python-data-dev.sh`         | Create a data-oriented Python project            | Available |
| `vscode-python-software-project.sh` | Create a structured software engineering project | Available |

### Planned environments

| Environment          | Description                        | Status  |
| -------------------- | ---------------------------------- | ------- |
| `vscode-java-maven`  | Java, JDK, Maven                   | Planned |
| `vscode-java-gradle` | Java, JDK, Gradle                  | Planned |
| `vscode-node`        | Node.js, npm, pnpm, TypeScript     | Planned |
| `vscode-spring-boot` | Java, Spring Boot, Maven or Gradle | Planned |
| `vscode-react`       | Node.js, React, TypeScript         | Planned |
| `vscode-rust`        | Rust, cargo, clippy                | Planned |
| `vscode-cpp`         | C/C++, CMake, gdb                  | Planned |

## Documentation

Detailed documentation is available in the [`docs/`](./docs/) folder.

| Document                                         | Description                                    |
| ------------------------------------------------ | ---------------------------------------------- |
| [Python launchers](./docs/python-launchers.md)   | English documentation for all Python launchers |
| [Lanceurs Python](./docs/python-launchers.fr.md) | French documentation for all Python launchers  |

## Repository structure

The repository will progressively follow this structure:

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

## Quick start

Scripts are designed to be executed directly from an Onyxia VS Code terminal or through an Onyxia launch URL.

Example:

```bash
curl -LsSf https://raw.githubusercontent.com/mrmaxoufr/onyxia-dev-launchers/main/scripts/python/vscode-python-dev-tools.sh | bash
```

FastAPI project example:

```bash
curl -LsSf https://raw.githubusercontent.com/mrmaxoufr/onyxia-dev-launchers/main/scripts/python/vscode-python-fastapi.sh | bash
```

Data-oriented project example:

```bash
curl -LsSf https://raw.githubusercontent.com/mrmaxoufr/onyxia-dev-launchers/main/scripts/python/vscode-python-data-dev.sh | bash
```

Structured software project example:

```bash
curl -LsSf https://raw.githubusercontent.com/mrmaxoufr/onyxia-dev-launchers/main/scripts/python/vscode-python-software-project.sh | bash
```

## Example use cases

This repository may be useful for:

* students working on programming projects;
* teachers preparing reproducible development environments;
* developers who want a ready-to-use cloud workspace;
* users who want to extend Onyxia beyond classical data science workflows;
* teams looking for lightweight, shareable project bootstrap scripts.

## Useful links

* [Onyxia website](https://www.onyxia.sh/)
* [Onyxia documentation](https://docs.onyxia.sh/)
* [Onyxia GitHub repository](https://github.com/InseeFrLab/onyxia)
* [SSP Cloud](https://datalab.sspcloud.fr/)

## Roadmap

### Step 1 — Python launchers

* [x] Add a minimal Python + uv setup script
* [x] Add a Python development tools setup script
* [x] Add a FastAPI project launcher
* [x] Add a Python data development launcher
* [x] Add a structured Python software project launcher
* [x] Add Python launchers documentation

### Step 2 — Java launchers

* [ ] Add a Java + Maven setup script
* [ ] Add a Java + Gradle setup script
* [ ] Add a Spring Boot project launcher
* [ ] Add Java launcher documentation

### Step 3 — Node.js and frontend launchers

* [ ] Add a Node.js / TypeScript setup script
* [ ] Add a React project launcher
* [ ] Add frontend launcher documentation

### Step 4 — Reusable images

* [ ] Create Docker images for selected environments
* [ ] Document how to use them in Onyxia
* [ ] Add versioning conventions

### Step 5 — Onyxia integration

* [ ] Explore Helm chart integration
* [ ] Provide Onyxia-compatible configuration examples
* [ ] Build a small development-oriented service catalog

## Contributing

Contributions, ideas and improvements are welcome.

You can contribute by:

* proposing new development environments;
* improving existing scripts;
* adding documentation;
* testing scripts on Onyxia / SSP Cloud;
* reporting bugs or limitations.

Before contributing, please keep scripts:

* simple;
* readable;
* reproducible;
* safe to run in a fresh workspace.

## License

This project is distributed under the MIT License.

See [`LICENSE`](./LICENSE) for more information.
