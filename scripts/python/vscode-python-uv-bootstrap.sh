#!/usr/bin/env bash

set -euo pipefail

WORK_DIR="${WORK_DIR:-$HOME/work}"
PROJECT_NAME="${PROJECT_NAME:-python-project}"
PROJECT_DIR="${PROJECT_DIR:-$WORK_DIR/$PROJECT_NAME}"
PYTHON_VERSION="${PYTHON_VERSION:-3.12}"

echo "=================================================="
echo "🚀 Onyxia Dev Launchers — Python + uv bootstrap"
echo "=================================================="

echo ""
echo "This script creates a ready-to-use Python project with:"
echo "  - uv"
echo "  - ruff"
echo "  - pytest"
echo "  - pyright"
echo "  - pre-commit"
echo "  - a src/ layout"
echo "  - a small README.md"
echo ""

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
echo "2. Creating project directory"
echo "--------------------------------------------------"

if [ -e "$PROJECT_DIR/pyproject.toml" ]; then
    echo "✅ Project already exists: $PROJECT_DIR"
    echo "Skipping uv init."
else
    mkdir -p "$PROJECT_DIR"
    cd "$PROJECT_DIR"

    echo "📦 Initializing project: $PROJECT_NAME"
    uv init --name "$PROJECT_NAME" --python "$PYTHON_VERSION" --package
fi

cd "$PROJECT_DIR"

echo ""
echo "--------------------------------------------------"
echo "3. Installing development dependencies"
echo "--------------------------------------------------"

uv add --dev ruff pytest pyright pre-commit

echo ""
echo "--------------------------------------------------"
echo "4. Creating project structure"
echo "--------------------------------------------------"

PACKAGE_NAME="$(echo "$PROJECT_NAME" | tr '-' '_' | tr '[:upper:]' '[:lower:]')"

mkdir -p "src/$PACKAGE_NAME" tests

if [ ! -f "src/$PACKAGE_NAME/__init__.py" ]; then
    cat > "src/$PACKAGE_NAME/__init__.py" <<'EOF'
"""Example Python package created on Onyxia."""
EOF
fi

if [ ! -f "src/$PACKAGE_NAME/main.py" ]; then
    cat > "src/$PACKAGE_NAME/main.py" <<EOF
def hello() -> str:
    return "Hello from Onyxia + Python + uv!"


def main() -> None:
    print(hello())


if __name__ == "__main__":
    main()
EOF
fi

if [ ! -f "tests/test_main.py" ]; then
    cat > "tests/test_main.py" <<EOF
from $PACKAGE_NAME.main import hello


def test_hello() -> None:
    assert hello() == "Hello from Onyxia + Python + uv!"
EOF
fi

echo ""
echo "--------------------------------------------------"
echo "5. Creating configuration files"
echo "--------------------------------------------------"

if [ ! -f ".gitignore" ]; then
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

# Jupyter
.ipynb_checkpoints/

# VS Code
.vscode/

# OS
.DS_Store
Thumbs.db
EOF
fi

if [ ! -f ".pre-commit-config.yaml" ]; then
    cat > ".pre-commit-config.yaml" <<'EOF'
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.15.15
    hooks:
      - id: ruff
      - id: ruff-format
EOF
fi

echo ""
echo "--------------------------------------------------"
echo "6. Updating pyproject.toml"
echo "--------------------------------------------------"

python - <<'PY'
from pathlib import Path

path = Path("pyproject.toml")
text = path.read_text(encoding="utf-8")

ruff_config = """
[tool.ruff]
line-length = 88
target-version = "py312"

[tool.ruff.lint]
select = ["E", "F", "I", "B", "UP"]
ignore = []

[tool.pytest.ini_options]
testpaths = ["tests"]

[tool.pyright]
include = ["src", "tests"]
typeCheckingMode = "basic"
"""

if "[tool.ruff]" not in text:
    text = text.rstrip() + "\n" + ruff_config + "\n"
    path.write_text(text, encoding="utf-8")
PY

echo ""
echo "--------------------------------------------------"
echo "7. Creating project README"
echo "--------------------------------------------------"

cat > "README.md" <<EOF
# $PROJECT_NAME

This project was initialized with **Onyxia Dev Launchers**.

It uses a modern Python development setup based on:

| Tool | Purpose |
|---|---|
| \`uv\` | Fast Python package and project manager |
| \`ruff\` | Fast Python linter and formatter |
| \`pytest\` | Python testing framework |
| \`pyright\` | Static type checker |
| \`pre-commit\` | Git hooks manager |

## Project structure

~~~text
$PROJECT_NAME/
├── pyproject.toml
├── README.md
├── .gitignore
├── .pre-commit-config.yaml
├── src/
│   └── $PACKAGE_NAME/
│       ├── __init__.py
│       └── main.py
└── tests/
    └── test_main.py
~~~

## Getting started

Open a terminal in this folder:

~~~bash
cd $PROJECT_DIR
~~~

Run the example program:

~~~bash
uv run python -m $PACKAGE_NAME.main
~~~

Run the tests:

~~~bash
uv run pytest
~~~

Check code quality:

~~~bash
uv run ruff check .
~~~

Format the code:

~~~bash
uv run ruff format .
~~~

Run type checking:

~~~bash
uv run pyright
~~~

## Add dependencies

Add a runtime dependency:

~~~bash
uv add requests
~~~

Add a development dependency:

~~~bash
uv add --dev pytest
~~~

## Pre-commit

Install the pre-commit hooks:

~~~bash
uv run pre-commit install
~~~

Run all hooks manually:

~~~bash
uv run pre-commit run --all-files
~~~

## Notes

This project uses the \`src/\` layout.

The Python package name is:

~~~text
$PACKAGE_NAME
~~~

The project metadata and tool configuration are stored in:

~~~text
pyproject.toml
~~~
EOF

echo ""
echo "--------------------------------------------------"
echo "8. Installing pre-commit hooks"
echo "--------------------------------------------------"

uv run pre-commit install || true

echo ""
echo "--------------------------------------------------"
echo "9. Running checks"
echo "--------------------------------------------------"

uv run python -m "$PACKAGE_NAME.main"
uv run pytest
uv run ruff check .
uv run pyright || true

echo ""
echo "--------------------------------------------------"
echo "10. Updating shell configuration"
echo "--------------------------------------------------"

uv tool update-shell || true

echo ""
echo "=================================================="
echo "✅ Python project is ready!"
echo "=================================================="
echo ""
echo "Project created in:"
echo "  $PROJECT_DIR"
echo ""
echo "Open this file to get started:"
echo "  $PROJECT_DIR/README.md"
echo ""
