#!/usr/bin/env bash

set -euo pipefail

WORK_DIR="${WORK_DIR:-$HOME/work}"
PROJECT_NAME="${PROJECT_NAME:-data-dev-project}"
PYTHON_VERSION="${PYTHON_VERSION:-3.12}"
PROJECT_DIR="${PROJECT_DIR:-$WORK_DIR/$PROJECT_NAME}"

echo "=================================================="
echo "🚀 Onyxia Dev Launchers — Python data + dev project"
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
echo "1. Creating data project"
echo "--------------------------------------------------"

if [ -f "$PROJECT_DIR/pyproject.toml" ]; then
    echo "✅ Existing project found: $PROJECT_DIR"
else
    mkdir -p "$PROJECT_DIR"
    cd "$PROJECT_DIR"
    uv init --name "$PROJECT_NAME" --python "$PYTHON_VERSION"
fi

cd "$PROJECT_DIR"

echo ""
echo "--------------------------------------------------"
echo "2. Installing data and development dependencies"
echo "--------------------------------------------------"

uv add \
    pandas \
    polars \
    duckdb \
    pyarrow \
    openpyxl \
    matplotlib \
    requests \
    python-dotenv \
    ipykernel

uv add --dev \
    ruff \
    pytest \
    pytest-mock \
    pyright \
    pre-commit

echo ""
echo "--------------------------------------------------"
echo "3. Creating folders"
echo "--------------------------------------------------"

mkdir -p data/raw data/processed notebooks src tests docs

if [ -f "main.py" ]; then
    mkdir -p src
    mv main.py src/main.py || true
fi

cat > "tests/test_environment.py" <<'EOF'
from __future__ import annotations


def test_environment_is_ready() -> None:
    assert 1 + 1 == 2
EOF

echo ""
echo "--------------------------------------------------"
echo "4. Creating configuration files"
echo "--------------------------------------------------"

cat > ".env.template" <<'EOF'
APP_ENV=development
DATA_DIR=data
RAW_DATA_DIR=data/raw
PROCESSED_DATA_DIR=data/processed
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

# Data
data/raw/*
data/processed/*
!data/raw/.gitkeep
!data/processed/.gitkeep

# Jupyter
.ipynb_checkpoints/

# VS Code
.vscode/

# OS
.DS_Store
Thumbs.db
EOF

touch data/raw/.gitkeep
touch data/processed/.gitkeep

cat > "ruff.toml" <<'EOF'
line-length = 88
target-version = "py312"
show-fixes = true

exclude = [
    ".venv",
    "venv",
    "__pycache__",
    ".ipynb_checkpoints",
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

Python data + development environment generated with **Onyxia Dev Launchers**.

This project is designed for data analysis, reproducible scripts and clean Python development.

## Installed tools and libraries

| Tool / library | Purpose |
|---|---|
| \`uv\` | Python project and dependency manager |
| \`pandas\` | Data analysis |
| \`polars\` | Fast dataframe library |
| \`duckdb\` | SQL analytics engine |
| \`pyarrow\` | Columnar data and Parquet support |
| \`openpyxl\` | Excel file support |
| \`matplotlib\` | Plotting |
| \`requests\` | HTTP client |
| \`python-dotenv\` | Environment variable loading |
| \`ipykernel\` | Jupyter kernel support |
| \`ruff\` | Linter and formatter |
| \`pytest\` | Testing framework |
| \`pyright\` | Static type checker |
| \`pre-commit\` | Git hooks manager |

## Project structure

~~~text
$PROJECT_NAME/
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

## Data folders

Use:

~~~text
data/raw/
~~~

for original input files.

Use:

~~~text
data/processed/
~~~

for generated or cleaned files.

By default, data files are ignored by Git.

Only the folder structure is kept.

## Start Python

~~~bash
uv run python
~~~

## Run a script

~~~bash
uv run python src/main.py
~~~

## Use pandas

~~~python
import pandas as pd

df = pd.read_csv("data/raw/file.csv")
print(df.head())
~~~

## Use polars

~~~python
import polars as pl

df = pl.read_csv("data/raw/file.csv")
print(df.head())
~~~

## Use DuckDB

~~~python
import duckdb

result = duckdb.sql("SELECT 1 AS value").df()
print(result)
~~~

## Work with Parquet

~~~python
import pandas as pd

df = pd.read_parquet("data/raw/file.parquet")
df.to_parquet("data/processed/output.parquet")
~~~

## Work with Excel

~~~python
import pandas as pd

df = pd.read_excel("data/raw/file.xlsx")
df.to_excel("data/processed/output.xlsx", index=False)
~~~

## Environment variables

Copy the template file:

~~~bash
cp .env.template .env
~~~

Then edit \`.env\`.

Example usage:

~~~python
import os
from dotenv import load_dotenv

load_dotenv()

data_dir = os.getenv("DATA_DIR", "data")
print(data_dir)
~~~

Never commit real secrets.

## Jupyter kernel

Register the project kernel:

~~~bash
uv run python -m ipykernel install --user --name "$PROJECT_NAME" --display-name "$PROJECT_NAME"
~~~

Then select the kernel in Jupyter or VS Code.

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

## Recommended workflow

~~~bash
uv sync --dev
uv run pytest
uv run ruff check .
uv run ruff format .
uv run pyright
~~~

## Notes

This setup is useful for:

- data analysis;
- reproducible scripts;
- exploratory work;
- small data pipelines;
- teaching;
- projects mixing data and software engineering practices.
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
echo "✅ Python data + dev project is ready!"
echo "=================================================="
echo ""
echo "Project created here:"
echo "  $PROJECT_DIR"
echo ""
echo "Open:"
echo "  $PROJECT_DIR/README.md"
echo ""
