#!/usr/bin/env bash

set -euo pipefail

WORK_DIR="${WORK_DIR:-$HOME/work}"
PROJECT_NAME="${PROJECT_NAME:-fastapi-project}"
PACKAGE_NAME="${PACKAGE_NAME:-app}"
PYTHON_VERSION="${PYTHON_VERSION:-3.12}"
PROJECT_DIR="${PROJECT_DIR:-$WORK_DIR/$PROJECT_NAME}"

echo "=================================================="
echo "🚀 Onyxia Dev Launchers — FastAPI project"
echo "=================================================="

mkdir -p "$WORK_DIR"

if ! command -v curl >/dev/null 2>&1; then
    echo "❌ curl is required but is not installed."
    exit 1
fi

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
    exit 1
fi

echo "✅ uv ready: $(uv --version)"

echo ""
echo "--------------------------------------------------"
echo "1. Creating FastAPI project"
echo "--------------------------------------------------"

if [ -f "$PROJECT_DIR/pyproject.toml" ]; then
    echo "✅ Existing project found: $PROJECT_DIR"
else
    mkdir -p "$PROJECT_DIR"
    cd "$PROJECT_DIR"
    uv init --name "$PROJECT_NAME" --python "$PYTHON_VERSION"
fi

cd "$PROJECT_DIR"

if [ -f "main.py" ]; then
    rm -f "main.py"
fi

echo ""
echo "--------------------------------------------------"
echo "2. Installing dependencies"
echo "--------------------------------------------------"

uv add fastapi "uvicorn[standard]" pydantic python-dotenv
uv add --dev ruff pytest httpx pyright pre-commit

echo ""
echo "--------------------------------------------------"
echo "3. Creating FastAPI source files"
echo "--------------------------------------------------"

mkdir -p "src/$PACKAGE_NAME" tests docs

touch "src/$PACKAGE_NAME/__init__.py"

cat > "src/$PACKAGE_NAME/main.py" <<'EOF'
from __future__ import annotations

import os

from dotenv import load_dotenv
from fastapi import FastAPI
from pydantic import BaseModel


load_dotenv()


class Message(BaseModel):
    message: str


class HealthResponse(BaseModel):
    status: str


class EchoRequest(BaseModel):
    text: str


class EchoResponse(BaseModel):
    echoed: str


APP_NAME = os.getenv("APP_NAME", "FastAPI Onyxia App")

app = FastAPI(title=APP_NAME)


@app.get("/", response_model=Message)
def root() -> Message:
    return Message(
        message=(
            "FastAPI is running. Open /docs, /health, or /echo/{text}."
        )
    )


@app.get("/health", response_model=HealthResponse)
def health_check() -> HealthResponse:
    return HealthResponse(status="ok")


@app.get("/echo/{text}", response_model=EchoResponse)
def echo_text(text: str) -> EchoResponse:
    return EchoResponse(echoed=text)


@app.post("/echo", response_model=EchoResponse)
def echo_body(payload: EchoRequest) -> EchoResponse:
    return EchoResponse(echoed=payload.text)
EOF

cat > "tests/test_api.py" <<EOF
from __future__ import annotations

from fastapi.testclient import TestClient

from $PACKAGE_NAME.main import app


client = TestClient(app)


def test_root() -> None:
    response = client.get("/")

    assert response.status_code == 200
    assert "FastAPI is running" in response.json()["message"]


def test_health() -> None:
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_echo_path() -> None:
    response = client.get("/echo/hello")

    assert response.status_code == 200
    assert response.json() == {"echoed": "hello"}


def test_echo_body() -> None:
    response = client.post("/echo", json={"text": "hello"})

    assert response.status_code == 200
    assert response.json() == {"echoed": "hello"}
EOF

echo ""
echo "--------------------------------------------------"
echo "4. Creating configuration files"
echo "--------------------------------------------------"

cat > ".env.template" <<'EOF'
APP_NAME=FastAPI Onyxia App
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
]

[lint]
select = ["E", "F", "W", "I", "B", "UP", "N"]
ignore = ["E501"]

[format]
quote-style = "double"
indent-style = "space"
line-ending = "lf"
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

python - <<'PY'
from pathlib import Path

path = Path("pyproject.toml")
text = path.read_text(encoding="utf-8")

config = """
[tool.pytest.ini_options]
testpaths = ["tests"]
pythonpath = ["src"]
"""

if "[tool.pytest.ini_options]" not in text:
    text = text.rstrip() + "\n\n" + config.strip() + "\n"

path.write_text(text, encoding="utf-8")
PY

echo ""
echo "--------------------------------------------------"
echo "5. Creating README"
echo "--------------------------------------------------"

cat > "README.md" <<EOF
# $PROJECT_NAME

FastAPI project generated with **Onyxia Dev Launchers**.

## Installed tools

| Tool | Purpose |
|---|---|
| \`uv\` | Python project and dependency manager |
| \`FastAPI\` | Web API framework |
| \`Uvicorn\` | ASGI server |
| \`Ruff\` | Linter and formatter |
| \`pytest\` | Testing framework |
| \`Pyright\` | Static type checker |
| \`pre-commit\` | Git hooks manager |

## Project structure

~~~text
$PROJECT_NAME/
├── README.md
├── pyproject.toml
├── ruff.toml
├── .env.template
├── .pre-commit-config.yaml
├── src/
│   └── $PACKAGE_NAME/
│       ├── __init__.py
│       └── main.py
└── tests/
    └── test_api.py
~~~

## Run locally

~~~bash
PYTHONPATH=src uv run uvicorn $PACKAGE_NAME.main:app --reload --host 0.0.0.0 --port 8000
~~~

Open:

~~~text
http://localhost:8000
http://localhost:8000/docs
http://localhost:8000/health
~~~

## Run on SSPCloud / Onyxia

When using the SSPCloud proxy, run:

~~~bash
PYTHONPATH=src uv run uvicorn $PACKAGE_NAME.main:app --reload --host 0.0.0.0 --port 8000 --root-path /proxy/8000
~~~

Then open:

~~~text
/proxy/8000/
/proxy/8000/docs
/proxy/8000/health
/proxy/8000/openapi.json
~~~

The \`--root-path /proxy/8000\` option is important because Swagger UI needs to find \`openapi.json\` behind the SSPCloud proxy.

## Available endpoints

~~~text
GET  /
GET  /health
GET  /echo/{text}
POST /echo
~~~

## Test with curl

~~~bash
curl http://localhost:8000/health
curl http://localhost:8000/echo/hello
curl -X POST http://localhost:8000/echo \\
  -H "Content-Type: application/json" \\
  -d '{"text": "hello"}'
~~~

## Run tests

~~~bash
uv run pytest
~~~

## Lint and format

~~~bash
uv run ruff check .
uv run ruff format .
~~~

## Type checking

~~~bash
uv run pyright
~~~

## Pre-commit

~~~bash
uv run pre-commit install
uv run pre-commit run --all-files
~~~

## Configuration

Copy the template file:

~~~bash
cp .env.template .env
~~~

Then edit \`.env\`.

Never commit real secrets.
EOF

echo ""
echo "--------------------------------------------------"
echo "6. Running checks"
echo "--------------------------------------------------"

uv run pytest
uv run ruff check .
uv run ruff format .
uv run pyright || true
uv run pre-commit install || true
uv tool update-shell || true

echo ""
echo "=================================================="
echo "✅ FastAPI project is ready!"
echo "=================================================="
echo ""
echo "Project created here:"
echo "  $PROJECT_DIR"
echo ""
echo "Open:"
echo "  $PROJECT_DIR/README.md"
echo ""
echo "Run locally:"
echo "  cd $PROJECT_DIR"
echo "  PYTHONPATH=src uv run uvicorn $PACKAGE_NAME.main:app --reload --host 0.0.0.0 --port 8000"
echo ""
echo "Run on SSPCloud / Onyxia:"
echo "  PYTHONPATH=src uv run uvicorn $PACKAGE_NAME.main:app --reload --host 0.0.0.0 --port 8000 --root-path /proxy/8000"
echo ""
