#!/usr/bin/env bash

set -euo pipefail

WORK_DIR="${WORK_DIR:-$HOME/work}"
PROJECT_NAME="${PROJECT_NAME:-software-project}"
PACKAGE_NAME="${PACKAGE_NAME:-app}"
PYTHON_VERSION="${PYTHON_VERSION:-3.12}"
PROJECT_DIR="${PROJECT_DIR:-$WORK_DIR/$PROJECT_NAME}"

echo "=================================================="
echo "🚀 Onyxia Dev Launchers — Python software project"
echo "=================================================="

echo ""
echo "Project name:    $PROJECT_NAME"
echo "Package name:    $PACKAGE_NAME"
echo "Python version:  $PYTHON_VERSION"
echo "Project folder:  $PROJECT_DIR"
echo ""

mkdir -p "$WORK_DIR"

if ! command -v curl >/dev/null 2>&1; then
    echo "❌ curl is required but is not installed."
    exit 1
fi

echo "--------------------------------------------------"
echo "1. Installing uv if needed"
echo "--------------------------------------------------"

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

if command -v uv >/dev/null 2>&1; then
    echo "✅ uv already installed: $(uv --version)"
else
    echo "📦 Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
fi

if ! command -v uv >/dev/null 2>&1; then
    echo "❌ uv installation failed or uv is not available in PATH."
    echo "Try restarting the terminal."
    exit 1
fi

echo "✅ uv ready: $(uv --version)"

echo ""
echo "--------------------------------------------------"
echo "2. Creating project"
echo "--------------------------------------------------"

if [ -f "$PROJECT_DIR/pyproject.toml" ]; then
    echo "✅ Existing uv project found: $PROJECT_DIR"
else
    mkdir -p "$PROJECT_DIR"
    cd "$PROJECT_DIR"
    uv init --name "$PROJECT_NAME" --python "$PYTHON_VERSION"
fi

cd "$PROJECT_DIR"

# uv init may create a simple main.py. We remove it because this launcher
# creates a src/ application layout instead.
if [ -f "main.py" ]; then
    rm -f "main.py"
fi

echo ""
echo "--------------------------------------------------"
echo "3. Installing project dependencies"
echo "--------------------------------------------------"

uv add \
    fastapi \
    "uvicorn[standard]" \
    pydantic \
    python-dotenv \
    requests \
    httpx \
    sqlalchemy

uv add --dev \
    ruff \
    pytest \
    pytest-mock \
    pyright \
    pre-commit

echo ""
echo "--------------------------------------------------"
echo "4. Creating source architecture"
echo "--------------------------------------------------"

mkdir -p \
    "src/$PACKAGE_NAME/api" \
    "src/$PACKAGE_NAME/models" \
    "src/$PACKAGE_NAME/repositories" \
    "src/$PACKAGE_NAME/services" \
    "tests/unit" \
    "tests/integration" \
    "docs" \
    ".github/workflows"

touch "src/$PACKAGE_NAME/__init__.py"
touch "src/$PACKAGE_NAME/api/__init__.py"
touch "src/$PACKAGE_NAME/models/__init__.py"
touch "src/$PACKAGE_NAME/repositories/__init__.py"
touch "src/$PACKAGE_NAME/services/__init__.py"

cat > "src/$PACKAGE_NAME/config.py" <<EOF
from __future__ import annotations

import os

from dotenv import load_dotenv
from pydantic import BaseModel


load_dotenv()


class Settings(BaseModel):
    app_name: str = os.getenv("APP_NAME", "Software Engineering API")
    app_env: str = os.getenv("APP_ENV", "development")
    log_level: str = os.getenv("LOG_LEVEL", "INFO")


settings = Settings()
EOF

cat > "src/$PACKAGE_NAME/models/item.py" <<EOF
from __future__ import annotations

from pydantic import BaseModel, Field


class Item(BaseModel):
    id: int
    name: str = Field(min_length=1)
    price: float = Field(ge=0)
EOF

cat > "src/$PACKAGE_NAME/repositories/item_repository.py" <<EOF
from __future__ import annotations

from $PACKAGE_NAME.models.item import Item


class ItemRepository:
    """In-memory repository used as a simple example.

    In a real project, this layer would contain database access code.
    """

    def __init__(self) -> None:
        self._items = [
            Item(id=1, name="Notebook", price=4.5),
            Item(id=2, name="Keyboard", price=49.9),
            Item(id=3, name="Mouse", price=19.9),
        ]

    def list_items(self) -> list[Item]:
        return list(self._items)

    def get_item_by_id(self, item_id: int) -> Item | None:
        for item in self._items:
            if item.id == item_id:
                return item
        return None
EOF

cat > "src/$PACKAGE_NAME/services/item_service.py" <<EOF
from __future__ import annotations

from $PACKAGE_NAME.models.item import Item
from $PACKAGE_NAME.repositories.item_repository import ItemRepository


class ItemService:
    """Business layer for item-related use cases."""

    def __init__(self, repository: ItemRepository | None = None) -> None:
        self.repository = repository or ItemRepository()

    def list_items(self) -> list[Item]:
        return self.repository.list_items()

    def get_item_by_id(self, item_id: int) -> Item:
        item = self.repository.get_item_by_id(item_id)

        if item is None:
            raise ValueError(f"Item with id {item_id} was not found.")

        return item
EOF

cat > "src/$PACKAGE_NAME/api/health_router.py" <<EOF
from __future__ import annotations

from fastapi import APIRouter


router = APIRouter(tags=["health"])


@router.get("/health")
def health_check() -> dict[str, str]:
    return {"status": "ok"}
EOF

cat > "src/$PACKAGE_NAME/api/item_router.py" <<EOF
from __future__ import annotations

from fastapi import APIRouter, HTTPException

from $PACKAGE_NAME.models.item import Item
from $PACKAGE_NAME.services.item_service import ItemService


router = APIRouter(prefix="/items", tags=["items"])
item_service = ItemService()


@router.get("/", response_model=list[Item])
def list_items() -> list[Item]:
    return item_service.list_items()


@router.get("/{item_id}", response_model=Item)
def get_item(item_id: int) -> Item:
    try:
        return item_service.get_item_by_id(item_id)
    except ValueError as error:
        raise HTTPException(status_code=404, detail=str(error)) from error
EOF

cat > "src/$PACKAGE_NAME/main.py" <<EOF
from __future__ import annotations

from fastapi import FastAPI

from $PACKAGE_NAME.api.health_router import router as health_router
from $PACKAGE_NAME.api.item_router import router as item_router
from $PACKAGE_NAME.config import settings


def create_app() -> FastAPI:
    app = FastAPI(title=settings.app_name)

    app.include_router(health_router)
    app.include_router(item_router)

    return app


app = create_app()
EOF

echo ""
echo "--------------------------------------------------"
echo "5. Creating tests"
echo "--------------------------------------------------"

cat > "tests/unit/test_item_service.py" <<EOF
from __future__ import annotations

import pytest

from $PACKAGE_NAME.services.item_service import ItemService


def test_list_items_returns_items() -> None:
    service = ItemService()

    items = service.list_items()

    assert len(items) >= 1
    assert items[0].name == "Notebook"


def test_get_item_by_id_returns_expected_item() -> None:
    service = ItemService()

    item = service.get_item_by_id(1)

    assert item.id == 1
    assert item.name == "Notebook"


def test_get_item_by_id_raises_error_for_missing_item() -> None:
    service = ItemService()

    with pytest.raises(ValueError):
        service.get_item_by_id(999)
EOF

cat > "tests/integration/test_api.py" <<EOF
from __future__ import annotations

from fastapi.testclient import TestClient

from $PACKAGE_NAME.main import app


client = TestClient(app)


def test_health_endpoint() -> None:
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_list_items_endpoint() -> None:
    response = client.get("/items/")

    assert response.status_code == 200
    assert len(response.json()) >= 1


def test_get_missing_item_endpoint() -> None:
    response = client.get("/items/999")

    assert response.status_code == 404
EOF

echo ""
echo "--------------------------------------------------"
echo "6. Creating configuration files"
echo "--------------------------------------------------"

cat > ".env.template" <<EOF
APP_NAME=Software Engineering API
APP_ENV=development
LOG_LEVEL=INFO
EOF

cat > ".gitignore" <<'EOF'
# Python
__pycache__/
*.py[cod]
.pytest_cache/
.ruff_cache/
.mypy_cache/
.pyright/
.coverage
htmlcov/

# Virtual environments
.venv/
venv/

# Environment variables
.env
.env.*
!.env.template

# Jupyter
.ipynb_checkpoints/

# VS Code
.vscode/

# OS
.DS_Store
Thumbs.db
EOF

cat > "ruff.toml" <<'EOF'
line-length = 88
target-version = "py312"
show-fixes = true

exclude = [
    ".venv",
    "venv",
    "__pycache__",
    "migrations",
]

[lint]
select = [
    "E",
    "F",
    "W",
    "I",
    "B",
    "C4",
    "SIM",
    "UP",
    "N",
    "ARG",
]
ignore = [
    "E501",
]

[lint.isort]
combine-as-imports = true
force-sort-within-sections = true
lines-after-imports = 2

[format]
quote-style = "double"
indent-style = "space"
line-ending = "lf"
EOF

cat > "pyrightconfig.json" <<EOF
{
  "include": ["src", "tests"],
  "exclude": [".venv", "**/__pycache__"],
  "venvPath": ".",
  "venv": ".venv",
  "typeCheckingMode": "basic"
}
EOF

cat > ".pre-commit-config.yaml" <<'EOF'
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.15.15
    hooks:
      - id: ruff
        args: ["--fix"]
      - id: ruff-format
EOF

cat > ".github/workflows/ci.yml" <<'EOF'
name: CI Python with uv

on:
  push:
    branches: ["**"]
  pull_request:
    branches: [main, develop]

jobs:
  format:
    name: Format check with Ruff
    runs-on: ubuntu-22.04

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Install uv
        uses: astral-sh/setup-uv@v4
        with:
          version: "latest"

      - name: Install Python
        run: uv python install

      - name: Install dependencies
        run: uv sync --dev

      - name: Check formatting
        run: uv run ruff format --check .

  lint:
    name: Lint with Ruff
    runs-on: ubuntu-22.04

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Install uv
        uses: astral-sh/setup-uv@v4
        with:
          version: "latest"

      - name: Install Python
        run: uv python install

      - name: Install dependencies
        run: uv sync --dev

      - name: Run Ruff
        run: uv run ruff check .

  test:
    name: Tests with pytest
    runs-on: ubuntu-22.04

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Install uv
        uses: astral-sh/setup-uv@v4
        with:
          version: "latest"

      - name: Install Python
        run: uv python install

      - name: Install dependencies
        run: uv sync --dev

      - name: Run tests
        run: uv run pytest
EOF

echo ""
echo "--------------------------------------------------"
echo "7. Updating pyproject.toml"
echo "--------------------------------------------------"

python - <<'PY'
from pathlib import Path

path = Path("pyproject.toml")
text = path.read_text(encoding="utf-8")

pytest_config = """
[tool.pytest.ini_options]
testpaths = ["tests"]
pythonpath = ["src"]
"""

if "[tool.pytest.ini_options]" not in text:
    text = text.rstrip() + "\n\n" + pytest_config.strip() + "\n"

path.write_text(text, encoding="utf-8")
PY

echo ""
echo "--------------------------------------------------"
echo "8. Creating documentation"
echo "--------------------------------------------------"

cat > "README.md" <<EOF
# $PROJECT_NAME

This project was generated with **Onyxia Dev Launchers**.

It is a small Python software engineering project using:

| Tool | Purpose |
|---|---|
| \`uv\` | Python project and dependency manager |
| \`FastAPI\` | API framework |
| \`Ruff\` | Linter and formatter |
| \`pytest\` | Testing framework |
| \`pytest-mock\` | Mocking support for tests |
| \`Pyright\` | Static type checker |
| \`pre-commit\` | Local Git hooks |
| \`GitHub Actions\` | CI automation |

## Architecture

The project follows a simple layered architecture:

~~~text
src/$PACKAGE_NAME/
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

The API layer should not contain business logic.

The service layer contains business use cases.

The repository layer contains data access logic.

The model layer contains shared data structures.

## Run the API

~~~bash
uv run uvicorn $PACKAGE_NAME.main:app --reload --host 0.0.0.0 --port 8000
~~~

Then open:

~~~text
http://localhost:8000/docs
~~~

Available endpoints:

~~~text
GET /health
GET /items/
GET /items/{item_id}
~~~

## Run tests

~~~bash
uv run pytest
~~~

Verbose mode:

~~~bash
uv run pytest -v
~~~

## Lint and format

Check code:

~~~bash
uv run ruff check .
~~~

Fix simple issues:

~~~bash
uv run ruff check --fix .
~~~

Format code:

~~~bash
uv run ruff format .
~~~

Check formatting:

~~~bash
uv run ruff format --check .
~~~

## Type checking

~~~bash
uv run pyright
~~~

## Pre-commit

Install hooks:

~~~bash
uv run pre-commit install
~~~

Run all hooks manually:

~~~bash
uv run pre-commit run --all-files
~~~

## Configuration

Copy the template file:

~~~bash
cp .env.template .env
~~~

Edit values in \`.env\`.

Never commit real secrets.

## CI

A GitHub Actions workflow is available in:

~~~text
.github/workflows/ci.yml
~~~

It runs:

- Ruff format check;
- Ruff linting;
- pytest tests.

## Useful development workflow

~~~bash
uv sync --dev
uv run pytest
uv run ruff check .
uv run ruff format .
uv run pyright
~~~
EOF

cat > "docs/architecture.md" <<EOF
# Architecture notes

This project uses a simple layered architecture.

## Layers

~~~text
api -> services -> repositories -> models
~~~

## API layer

The API layer exposes HTTP endpoints.

It should:

- receive HTTP requests;
- validate simple route parameters;
- call services;
- translate errors into HTTP responses.

It should not contain business rules.

## Service layer

The service layer contains business logic.

It should:

- implement use cases;
- orchestrate repositories;
- enforce business rules.

## Repository layer

The repository layer contains data access logic.

In this generated project, the repository is in memory.

In a real project, it could use:

- SQLite;
- PostgreSQL;
- an external API;
- S3;
- another storage system.

## Model layer

The model layer contains shared data structures.

Here, models are implemented with Pydantic.

## Why this structure?

This structure keeps the code easy to understand, test and evolve.

It also avoids mixing HTTP concerns, business logic and data access in the same files.
EOF

cat > "docs/commands.md" <<EOF
# Useful commands

## Install dependencies

~~~bash
uv sync --dev
~~~

## Run the API

~~~bash
uv run uvicorn $PACKAGE_NAME.main:app --reload --host 0.0.0.0 --port 8000
~~~

## Run tests

~~~bash
uv run pytest
~~~

## Lint

~~~bash
uv run ruff check .
~~~

## Format

~~~bash
uv run ruff format .
~~~

## Type-check

~~~bash
uv run pyright
~~~

## Pre-commit

~~~bash
uv run pre-commit install
uv run pre-commit run --all-files
~~~
EOF

cat > "docs/workflow.md" <<EOF
# Development workflow

A recommended workflow is:

1. Create or update code in \`src/\`.
2. Add or update tests in \`tests/\`.
3. Run tests locally.
4. Run linting and formatting.
5. Commit only coherent changes.

## Suggested commands

~~~bash
uv run pytest
uv run ruff check .
uv run ruff format .
uv run pyright
~~~

## Git workflow

~~~bash
git status
git add .
git commit -m "✨ feat: describe your change"
git push
~~~

## Quality principle

A project should stay simple, explicit and easy to evolve.

Avoid:

- duplicated code;
- very long functions;
- hidden configuration;
- business logic inside API endpoints;
- secrets committed in Git.
EOF

echo ""
echo "--------------------------------------------------"
echo "9. Installing pre-commit hooks"
echo "--------------------------------------------------"

uv run pre-commit install || true

echo ""
echo "--------------------------------------------------"
echo "10. Running checks"
echo "--------------------------------------------------"

uv run pytest
uv run ruff check .
uv run ruff format .
uv run pyright || true

echo ""
echo "--------------------------------------------------"
echo "11. Updating shell configuration"
echo "--------------------------------------------------"

uv tool update-shell || true

echo ""
echo "=================================================="
echo "✅ Python software project is ready!"
echo "=================================================="
echo ""
echo "Project created here:"
echo "  $PROJECT_DIR"
echo ""
echo "Open this file in VS Code:"
echo "  $PROJECT_DIR/README.md"
echo ""
echo "Run the API with:"
echo "  cd $PROJECT_DIR"
echo "  uv run uvicorn $PACKAGE_NAME.main:app --reload --host 0.0.0.0 --port 8000"
echo ""
