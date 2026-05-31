#!/usr/bin/env bash
set -e

JAVA_VERSION=21

echo "Installing full Java development environment..."

sudo apt-get update -y
sudo apt-get install -y --no-install-recommends \
  ca-certificates-java \
  openjdk-${JAVA_VERSION}-jdk \
  maven \
  gradle \
  curl \
  unzip \
  zip \
  git \
  jq \
  tree

export JAVA_HOME
JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(which java)")")")"
export PATH="$JAVA_HOME/bin:$PATH"

echo "Java version:"
java --version

echo "Maven version:"
mvn --version

echo "Gradle version:"
gradle --version

echo "Installing full Java extensions for code-server..."

code-server --install-extension vscjava.vscode-java-pack
code-server --install-extension vmware.vscode-boot-dev-pack
code-server --install-extension vscjava.vscode-gradle
code-server --install-extension visualstudioexptteam.vscodeintellicode
code-server --install-extension sonarsource.sonarlint-vscode
code-server --install-extension redhat.vscode-xml
code-server --install-extension humao.rest-client
code-server --install-extension eamodio.gitlens

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

echo "Full Java development environment setup completed."
