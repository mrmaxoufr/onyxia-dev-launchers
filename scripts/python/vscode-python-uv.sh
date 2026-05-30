#!/usr/bin/env bash

set -euo pipefail

echo "=================================================="
echo "🚀 Onyxia Dev Launchers — Python + uv"
echo "=================================================="

echo ""
echo "Installing basic Python development tools..."

if ! command -v curl >/dev/null 2>&1; then
    echo "❌ curl is required but is not installed."
    exit 1
fi

echo ""
echo "--------------------------------------------------"
echo "1. Installing uv if needed"
echo "--------------------------------------------------"

if command -v uv >/dev/null 2>&1; then
    echo "✅ uv already installed: $(uv --version)"
else
    echo "📦 Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

if ! command -v uv >/dev/null 2>&1; then
    echo "❌ uv installation failed or uv is not available in PATH."
    echo "Try restarting the terminal."
    exit 1
fi

echo "✅ uv ready: $(uv --version)"

echo ""
echo "--------------------------------------------------"
echo "2. Installing global Python tools with uv"
echo "--------------------------------------------------"

uv tool install ruff
uv tool install pyright
uv tool install pytest
uv tool install pre-commit

echo ""
echo "--------------------------------------------------"
echo "3. Checking installed tools"
echo "--------------------------------------------------"

echo "uv:         $(uv --version)"
echo "ruff:       $(ruff --version || true)"
echo "pyright:    $(pyright --version || true)"
echo "pytest:     $(pytest --version || true)"
echo "pre-commit: $(pre-commit --version || true)"

echo ""
echo "=================================================="
echo "✅ Python + uv environment is ready!"
echo "=================================================="
echo ""
echo "Nothing else was created or modified."
echo ""
echo "Useful commands:"
echo "  uv init"
echo "  uv add <package>"
echo "  uv add --dev ruff pytest pyright pre-commit"
echo "  uv run python"
echo "  uv run pytest"
echo "  ruff check ."
echo "  ruff format ."
echo ""
