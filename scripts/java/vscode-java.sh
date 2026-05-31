#!/usr/bin/env bash
set -e

JAVA_VERSION=21

echo "Installing Java ${JAVA_VERSION} and Maven..."

sudo apt-get update -y
sudo apt-get install -y --no-install-recommends \
  ca-certificates-java \
  openjdk-${JAVA_VERSION}-jdk \
  maven

export JAVA_HOME
JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(which java)")")")"
export PATH="$JAVA_HOME/bin:$PATH"

echo "Java version:"
java --version

echo "Maven version:"
mvn --version

echo "Installing Java extensions for code-server..."

code-server --install-extension vscjava.vscode-java-pack
code-server --install-extension vmware.vscode-boot-dev-pack
code-server --install-extension visualstudioexptteam.vscodeintellicode
code-server --install-extension sonarsource.sonarlint-vscode

echo "Uninstalling Python and Jupyter extensions..."

code-server --uninstall-extension ms-python.flake8 || true
code-server --uninstall-extension charliermarsh.ruff || true
code-server --uninstall-extension ms-python.debugpy || true
code-server --uninstall-extension ms-python.python || true
code-server --uninstall-extension ms-python.vscode-python-envs || true
code-server --uninstall-extension ms-toolsai.jupyter || true
code-server --uninstall-extension ms-toolsai.jupyter-keymap || true
code-server --uninstall-extension ms-toolsai.jupyter-renderers || true
code-server --uninstall-extension ms-toolsai.vscode-jupyter-cell-tags || true
code-server --uninstall-extension ms-toolsai.vscode-jupyter-slideshow || true

echo "Configuring Git branch display in terminal prompt..."

BASHRC="$HOME/.bashrc"

if command -v __git_ps1 >/dev/null 2>&1; then
  sed -i "/PS1='.*01;32m.*\\\\u@\\\\h/c\\
    PS1='\\\${debian_chroot:+(\\\$debian_chroot)}\\\[\\\033[01;32m\\\]\\\u@\\\h\\\[\\\033[00m\\\]:\\\[\\\033[01;34m\\\]\\\w\\\[\\\033[33m\\\]\\\$(__git_ps1 \" (%s)\")\\\[\\\033[00m\\\]\\\$ '" \
  "$BASHRC" || true
else
  echo "__git_ps1 not found, skipping Git branch prompt configuration."
fi

echo "Java environment setup completed."
