#!/usr/bin/env bash

set -euo pipefail

WORK_DIR="${WORK_DIR:-$HOME/work}"
HELP_FILE="$WORK_DIR/PYTHON_DEV_TOOLS.md"

echo "=================================================="
echo "🚀 Onyxia Dev Launchers — Python dev tools"
echo "=================================================="

mkdir -p "$WORK_DIR"

if ! command -v curl >/dev/null 2>&1; then
    echo "❌ curl is required but is not installed."
    exit 1
fi

echo ""
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
echo "2. Installing global Python development tools"
echo "--------------------------------------------------"

uv tool install ruff
uv tool install pyright
uv tool install pytest
uv tool install pre-commit
uv tool install httpie

echo ""
echo "--------------------------------------------------"
echo "3. Installing shell integration for uv tools"
echo "--------------------------------------------------"

uv tool update-shell || true

export PATH="$HOME/.local/bin:$PATH"

echo ""
echo "--------------------------------------------------"
echo "4. Creating help file"
echo "--------------------------------------------------"

cat > "$HELP_FILE" <<'EOF'
# Python development tools

Welcome! This VS Code workspace has been prepared with a modern Python development toolbox.

This setup does **not** create a Python project.

It only installs useful tools so you can start from a clean workspace.

## Installed tools

| Tool | Purpose |
|---|---|
| `uv` | Fast Python package and project manager |
| `ruff` | Python linter and formatter |
| `pytest` | Python testing framework |
| `pyright` | Static type checker for Python |
| `pre-commit` | Git hooks manager |
| `httpie` | Friendly command-line HTTP client |

## Restart your terminal

If one of the commands below is not found, open a new terminal.

The setup updates your shell configuration with:

~~~bash
uv tool update-shell
~~~

## Check the installation

~~~bash
uv --version
ruff --version
pytest --version
pyright --version
pre-commit --version
http --version
~~~

## Create a new Python project

~~~bash
uv init my-project
cd my-project
~~~

## Create a virtual environment

~~~bash
uv venv
~~~

Activate it manually if needed:

~~~bash
source .venv/bin/activate
~~~

## Add dependencies

Add a runtime dependency:

~~~bash
uv add requests
~~~

Add development dependencies:

~~~bash
uv add --dev ruff pytest pyright pre-commit pytest-mock
~~~

## Useful Python development dependencies

For a standard software engineering project:

~~~bash
uv add --dev ruff pytest pytest-mock pyright pre-commit
uv add python-dotenv pydantic requests httpx
~~~

For a FastAPI backend:

~~~bash
uv add fastapi "uvicorn[standard]" pydantic python-dotenv
uv add --dev pytest httpx pytest-mock ruff pyright pre-commit
~~~

For web scraping:

~~~bash
uv add requests beautifulsoup4 lxml
uv add --dev pytest pytest-mock ruff pyright pre-commit
~~~

For working with databases:

~~~bash
uv add sqlalchemy
uv add psycopg2-binary
~~~

For data files:

~~~bash
uv add pandas pyarrow openpyxl
~~~

## Run Python

Open an interactive Python shell:

~~~bash
uv run python
~~~

Run a file:

~~~bash
uv run python main.py
~~~

Run a module:

~~~bash
uv run python -m package.module
~~~

## Run tests

~~~bash
uv run pytest
~~~

Run tests with verbose output:

~~~bash
uv run pytest -v
~~~

Run a specific test file:

~~~bash
uv run pytest tests/test_example.py
~~~

## Lint and format with Ruff

Check code:

~~~bash
uv run ruff check .
~~~

Fix simple issues automatically:

~~~bash
uv run ruff check --fix .
~~~

Format code:

~~~bash
uv run ruff format .
~~~

Check formatting without modifying files:

~~~bash
uv run ruff format --check .
~~~

## Type-check with Pyright

~~~bash
uv run pyright
~~~

## Use pre-commit

Install hooks in a Git repository:

~~~bash
uv run pre-commit install
~~~

Run all hooks manually:

~~~bash
uv run pre-commit run --all-files
~~~

## Test an HTTP API

With HTTPie:

~~~bash
http GET http://localhost:8000
~~~

With curl:

~~~bash
curl http://localhost:8000
~~~

## Start a FastAPI application

If your project contains an application object named `app` in `main.py`:

~~~bash
uv run uvicorn main:app --reload --host 0.0.0.0 --port 8000
~~~

If your application is in `src/app/main.py`:

~~~bash
uv run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
~~~

## Configuration and secrets

A good project should separate code from configuration.

Recommended files:

~~~text
.env
.env.local
.env.template
~~~

Do not commit real secrets.

Commit only a template file such as:

~~~text
.env.template
~~~

Example:

~~~env
APP_ENV=development
LOG_LEVEL=INFO
DATABASE_URL=sqlite:///data/app.db
~~~

## Recommended project practices

A clean software project should usually include:

~~~text
README.md
pyproject.toml
.gitignore
.env.template
src/
tests/
docs/
~~~

Useful quality commands:

~~~bash
uv run ruff check .
uv run ruff format .
uv run pytest
uv run pyright
~~~

## Notes

This launcher only prepares the tools.

It does not impose a project structure, so you can use it for:

- scripts;
- Python packages;
- FastAPI backends;
- web scraping projects;
- data processing projects;
- teaching and prototyping.
EOF

echo "✅ Help file created: $HELP_FILE"

echo ""
echo "--------------------------------------------------"
echo "5. Quick check"
echo "--------------------------------------------------"

echo "uv:         $(uv --version)"
echo "ruff:       $(ruff --version || true)"
echo "pyright:    $(pyright --version || true)"
echo "pytest:     $(pytest --version || true)"
echo "pre-commit: $(pre-commit --version || true)"
echo "httpie:     $(http --version || true)"

echo ""
echo "=================================================="
echo "✅ Python development tools are ready!"
echo "=================================================="
echo ""
echo "Open this file in VS Code:"
echo "  $HELP_FILE"
echo ""
echo "If some commands are not found, open a new terminal."
echo ""
