#!/usr/bin/env bash

set -euo pipefail

WORK_DIR="${WORK_DIR:-$HOME/work}"
HELP_FILE="$WORK_DIR/PYTHON_UV_README.md"

echo "=================================================="
echo "🚀 Onyxia Dev Launchers — Python + uv"
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
echo "2. Installing Python tools with uv"
echo "--------------------------------------------------"

uv tool install ruff
uv tool install pyright
uv tool install pytest
uv tool install pre-commit

echo ""
echo "--------------------------------------------------"
echo "3. Updating shell configuration"
echo "--------------------------------------------------"

uv tool update-shell || true

export PATH="$HOME/.local/bin:$PATH"

echo ""
echo "--------------------------------------------------"
echo "4. Creating help file"
echo "--------------------------------------------------"

cat > "$HELP_FILE" <<'EOF'
# Python + uv environment

Welcome! This VS Code workspace has been prepared with a minimal modern Python toolchain.

## Installed tools

The following tools have been installed with `uv tool`:

| Tool | Purpose |
|---|---|
| `uv` | Fast Python package and project manager |
| `ruff` | Fast Python linter and formatter |
| `pytest` | Python testing framework |
| `pyright` | Static type checker for Python |
| `pre-commit` | Git hooks manager |

## Check the installation

Open a new terminal and run:

~~~bash
uv --version
ruff --version
pytest --version
pyright --version
pre-commit --version
~~~

If one of the tools is not found, restart the terminal and try again.

## Create a new Python project

~~~bash
uv init my-project
cd my-project
~~~

## Add dependencies

Add a runtime dependency:

~~~bash
uv add requests
~~~

Add development dependencies:

~~~bash
uv add --dev ruff pytest pyright pre-commit
~~~

## Run Python

~~~bash
uv run python
~~~

Or run a Python file:

~~~bash
uv run python main.py
~~~

## Run tests

~~~bash
uv run pytest
~~~

## Lint and format code

Check code with Ruff:

~~~bash
ruff check .
~~~

Format code with Ruff:

~~~bash
ruff format .
~~~

## Type-check code

~~~bash
pyright
~~~

## Notes

This setup does not create a Python project automatically.

It only installs the basic tools so you can start from a clean VS Code workspace.
EOF

echo "✅ Help file created: $HELP_FILE"

echo ""
echo "=================================================="
echo "✅ Python + uv environment is ready!"
echo "=================================================="
echo ""
echo "A help file has been created here:"
echo "  $HELP_FILE"
echo ""
echo "Open PYTHON_UV_README.md in VS Code to get started."
echo ""
