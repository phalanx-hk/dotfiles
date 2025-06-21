#!/usr/bin/env bash
set -Eeuxo pipefail

#### setting env ####
CUR_DIR=$(dirname "$(readlink -f "$0")")
ROOT_DIR=$(dirname "$CUR_DIR")
readonly CUR_DIR ROOT_DIR

#### apt ####
# shellcheck source=/dev/null
sudo bash "${CUR_DIR}"/apt.sh

#### link dotfiles ####
bash "${ROOT_DIR}"/link.sh

#### common tools ####
# install mise
readonly MISE_SCRIPT="${ROOT_DIR}"/common/mise.sh
echo "Executing ${MISE_SCRIPT}..."
chmod +x "${MISE_SCRIPT}"
bash "${MISE_SCRIPT}"

# install vscode extensions
readonly VSCODE_SCRIPT="${ROOT_DIR}"/common/vscode.sh
echo "Executing ${VSCODE_SCRIPT}..."
chmod +x "${VSCODE_SCRIPT}"
bash "${VSCODE_SCRIPT}"

# mise install
zsh << EOF
    # shellcheck source=/dev/null
    source ~/.zshenv
    # shellcheck source=/dev/null
    source ~/.zshrc
    mise install -y
EOF

# install claude code
readonly SCRIPT="${ROOT_DIR}"/common/claude_code.sh
echo "Executing ${SCRIPT}..."
chmod +x "${SCRIPT}"
bash "${SCRIPT}"

# install battery
curl -s https://raw.githubusercontent.com/actuallymentor/battery/main/setup.sh | bash
