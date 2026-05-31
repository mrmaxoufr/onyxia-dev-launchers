# Python launchers

> Documentation for the Python launch scripts provided by **Onyxia Dev Launchers**.

[🇫🇷 Lire la version française](./python-launchers.fr.md)

## Overview

This repository provides several Python launch scripts for Onyxia / SSP Cloud.

They are designed to prepare VS Code environments for different Python workflows:

- minimal Python tooling;
- general development tooling;
- FastAPI backend development;
- data-oriented development;
- structured software engineering projects.

The scripts are meant to be executed inside an Onyxia VS Code service, which runs in a Linux container.

They are not intended to be executed directly on a local Windows machine.

## Available scripts

| Script | Purpose | Creates a project? |
|---|---|---|
| `vscode-python-uv-minimal.sh` | Install `uv` and a minimal Python toolchain | No |
| `vscode-python-dev-tools.sh` | Install a broader Python development toolbox | No |
| `vscode-python-fastapi.sh` | Create a small FastAPI project | Yes |
| `vscode-python-data-dev.sh` | Create a data-oriented Python project | Yes |
| `vscode-python-software-project.sh` | Create a structured software engineering project | Yes |

## `vscode-python-uv-minimal.sh`

This is the simplest Python launcher.

It installs:

- `uv`;
- `ruff`;
- `pytest`;
- `pyright`;
- `pre-commit`.

It does not create a Python project.

It only prepares the VS Code environment with basic Python development tools.

### Use case

Use this script when you want a clean VS Code environment with modern Python tools, but you do not want the launcher to impose any project structure.

### Typical next commands

~~~bash
uv init my-project
cd my-project
uv add requests
uv add --dev ruff pytest pyright pre-commit
~~~

## `vscode-python-dev-tools.sh`

This script installs a broader Python development toolbox.

It installs:

- `uv`;
- `ruff`;
- `pytest`;
- `pyright`;
- `pre-commit`;
- `httpie`.

It also creates a help file in the workspace:

~~~text
~/work/PYTHON_DEV_TOOLS.md
~~~

This Markdown file explains how to use the installed tools.

### Use case

Use this script when you want a general-purpose Python development environment, but still want to start from an empty workspace.

It is useful for:

- scripts;
- Python packages;
- API clients;
- teaching;
- prototyping;
- small software projects.

## `vscode-python-fastapi.sh`

This script creates a minimal FastAPI project.

By default, it creates:

~~~text
~/work/fastapi-project
~~~

The generated project contains:

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

It installs:

- `fastapi`;
- `uvicorn[standard]`;
- `pydantic`;
- `python-dotenv`;
- `ruff`;
- `pytest`;
- `httpx`;
- `pyright`;
- `pre-commit`.

The generated API provides:

~~~text
GET  /
GET  /health
GET  /echo/{text}
POST /echo
~~~

### Run the API locally

~~~bash
PYTHONPATH=src uv run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
~~~

### Run the API on SSP Cloud / Onyxia

When using the SSP Cloud proxy, use:

~~~bash
PYTHONPATH=src uv run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000 --root-path /proxy/8000
~~~

The `--root-path /proxy/8000` option is important because Swagger UI needs to find `openapi.json` behind the SSP Cloud proxy.

### Test the endpoints

~~~bash
curl http://localhost:8000/health
curl http://localhost:8000/echo/hello
~~~

With the Onyxia proxy, open:

~~~text
/proxy/8000/
/proxy/8000/docs
/proxy/8000/health
/proxy/8000/openapi.json
~~~

### Use case

Use this script when you want to quickly start a small FastAPI backend project.

It is ideal for:

- API tutorials;
- backend prototypes;
- testing routes;
- learning FastAPI;
- exposing a simple service from Onyxia.

## `vscode-python-data-dev.sh`

This script creates a Python project oriented toward data work and clean development practices.

By default, it creates:

~~~text
~/work/data-dev-project
~~~

The generated structure is:

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

It installs:

- `pandas`;
- `polars`;
- `duckdb`;
- `pyarrow`;
- `openpyxl`;
- `matplotlib`;
- `requests`;
- `python-dotenv`;
- `ipykernel`;
- `ruff`;
- `pytest`;
- `pytest-mock`;
- `pyright`;
- `pre-commit`.

### Data folders

The project separates raw and processed data:

~~~text
data/raw/
data/processed/
~~~

Data files are ignored by Git by default.

Only the folder structure is kept with `.gitkeep` files.

### Use case

Use this script when you want a data-oriented Python project that still follows good software development practices.

It is useful for:

- data analysis;
- reproducible scripts;
- exploratory work;
- notebooks;
- small data pipelines;
- teaching;
- projects mixing data science and software engineering.

## `vscode-python-software-project.sh`

This script creates a structured Python software engineering project.

By default, it creates:

~~~text
~/work/software-project
~~~

The generated project follows a layered architecture:

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

The dependency direction is:

~~~text
api -> services -> repositories -> models
~~~

It also creates:

- unit tests;
- integration tests;
- `ruff.toml`;
- `.pre-commit-config.yaml`;
- `.env.template`;
- GitHub Actions CI;
- documentation files in `docs/`.

### Use case

Use this script when you want a clean starting point for a software engineering project.

It is designed to illustrate:

- layered architecture;
- separation of responsibilities;
- business logic in services;
- data access in repositories;
- API routes in routers;
- testing;
- linting;
- formatting;
- type checking;
- CI automation.

## Choosing the right launcher

| Need | Recommended script |
|---|---|
| Just install `uv` and basic tools | `vscode-python-uv-minimal.sh` |
| Install a broad Python toolbox without creating a project | `vscode-python-dev-tools.sh` |
| Start a small FastAPI API | `vscode-python-fastapi.sh` |
| Start a data-oriented project | `vscode-python-data-dev.sh` |
| Start a structured software engineering project | `vscode-python-software-project.sh` |

## Common commands

### Run tests

~~~bash
uv run pytest
~~~

### Lint code

~~~bash
uv run ruff check .
~~~

### Format code

~~~bash
uv run ruff format .
~~~

### Type-check code

~~~bash
uv run pyright
~~~

### Install pre-commit hooks

~~~bash
uv run pre-commit install
~~~

### Run all pre-commit hooks manually

~~~bash
uv run pre-commit run --all-files
~~~

## Notes about Onyxia

These launchers are designed for Onyxia / SSP Cloud services.

They are Bash scripts executed inside Linux containers.

On Windows, you should edit and version the scripts with Git, but the scripts themselves are meant to run inside the Onyxia environment.

## Future improvements

Possible future Python launchers:

- Docker-ready Python project;
- FastAPI + PostgreSQL project;
- FastAPI + React fullstack project;
- Django project;
- web scraping project;
- testing-oriented project with Selenium or Playwright.
