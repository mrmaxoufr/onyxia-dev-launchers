# Onyxia Dev Launchers

> Developer-oriented scripts and templates for [Onyxia](https://www.onyxia.sh/) and [SSP Cloud](https://datalab.sspcloud.fr/).

[🇫🇷 Lire la version française](./README.fr.md)

## Overview

**Onyxia Dev Launchers** is a collection of scripts, templates and configuration helpers designed to quickly bootstrap development-friendly environments on Onyxia-based platforms.

The goal of this project is to complement the existing data science-oriented services available on Onyxia / SSP Cloud with more software development-oriented environments.

For example:

- a solid VS Code Python environment with `uv`, `ruff`, `pytest` and modern tooling;
- a ready-to-use Java environment with JDK, Maven and Gradle;
- backend-oriented environments for FastAPI or Spring Boot;
- frontend-oriented environments for Node.js, TypeScript or React;
- reusable setup scripts for teaching, projects, prototyping and development workflows.

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

- custom Docker images;
- Helm charts;
- an Onyxia-compatible service catalog;
- ready-to-use development stacks.

## Planned environments

| Environment | Description | Status |
|---|---|---|
| `vscode-python-uv` | Python, uv, ruff, pytest, pyright | Planned |
| `vscode-java-maven` | Java, JDK, Maven | Planned |
| `vscode-java-gradle` | Java, JDK, Gradle | Planned |
| `vscode-node` | Node.js, npm, pnpm, TypeScript | Planned |
| `vscode-fastapi` | Python, FastAPI, uvicorn | Planned |
| `vscode-spring-boot` | Java, Spring Boot, Maven or Gradle | Planned |
| `vscode-react` | Node.js, React, TypeScript | Planned |
| `vscode-rust` | Rust, cargo, clippy | Planned |
| `vscode-cpp` | C/C++, CMake, gdb | Planned |

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
│   │   └── vscode-python-uv.sh
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
```

## Quick start

Once scripts are available, they will be executable directly from an Onyxia VS Code terminal.

Example:

```bash
curl -LsSf https://raw.githubusercontent.com/mrmaxoufr/onyxia-dev-launchers/main/scripts/python/vscode-python-uv.sh | bash
```

or:

```bash
curl -LsSf https://raw.githubusercontent.com/mrmaxoufr/onyxia-dev-launchers/main/scripts/java/vscode-java-maven.sh | bash
```

## Example use cases

This repository may be useful for:

- students working on programming projects;
- teachers preparing reproducible development environments;
- developers who want a ready-to-use cloud workspace;
- users who want to extend Onyxia beyond classical data science workflows;
- teams looking for lightweight, shareable project bootstrap scripts.

## Useful links

- [Onyxia website](https://www.onyxia.sh/)
- [Onyxia documentation](https://docs.onyxia.sh/)
- [Onyxia GitHub repository](https://github.com/InseeFrLab/onyxia)
- [SSP Cloud](https://datalab.sspcloud.fr/)

## Roadmap

### Step 1 — Simple launch scripts

- [ ] Add a Python + uv setup script
- [ ] Add a Java + Maven setup script
- [ ] Add basic documentation for each script
- [ ] Add usage examples

### Step 2 — Development templates

- [ ] Add a minimal Python project template
- [ ] Add a minimal Java Maven project template
- [ ] Add a minimal Node.js / TypeScript template

### Step 3 — Reusable images

- [ ] Create Docker images for selected environments
- [ ] Document how to use them in Onyxia
- [ ] Add versioning conventions

### Step 4 — Onyxia integration

- [ ] Explore Helm chart integration
- [ ] Provide Onyxia-compatible configuration examples
- [ ] Build a small development-oriented service catalog

## Contributing

Contributions, ideas and improvements are welcome.

You can contribute by:

- proposing new development environments;
- improving existing scripts;
- adding documentation;
- testing scripts on Onyxia / SSP Cloud;
- reporting bugs or limitations.

Before contributing, please keep scripts:

- simple;
- readable;
- reproducible;
- safe to run in a fresh workspace.

## License

This project is distributed under the MIT License.

See [`LICENSE`](./LICENSE) for more information.
