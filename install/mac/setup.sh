#!/usr/bin/env bash
set -Eeuo pipefail
set -x

#### setting env ####
CUR_DIR=$(dirname "$(readlink -f "$0")")
ROOT_DIR=$(dirname "$CUR_DIR")
readonly CUR_DIR ROOT_DIR

### install homebrew ###
bash "$CUR_DIR/homebrew.sh"

### link dotfiles ###
bash "${ROOT_DIR}"/link.sh

#### common tools ####

# install sheldon
readonly SHELDON_SCRIPT="${ROOT_DIR}"/common/sheldon.sh
echo "Executing ${SHELDON_SCRIPT}..."
chmod +x "${SHELDON_SCRIPT}"
bash "${SHELDON_SCRIPT}"

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

# install claude code
readonly SCRIPT="${ROOT_DIR}"/common/claude_code.sh
echo "Executing ${SCRIPT}..."
chmod +x "${SCRIPT}"
bash "${SCRIPT}"

# install battery
curl -s https://raw.githubusercontent.com/actuallymentor/battery/main/setup.sh | bash
