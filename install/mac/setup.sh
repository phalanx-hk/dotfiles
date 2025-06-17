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
# install mise
readonly SCRIPT="${ROOT_DIR}"/common/mise.sh
echo "Executing ${SCRIPT}..."
chmod +x "${SCRIPT}"
bash "${SCRIPT}"

# install vscode extensions
readonly SCRIPT="${ROOT_DIR}"/common/vscode.sh
echo "Executing ${SCRIPT}..."
chmod +x "${SCRIPT}"
bash "${SCRIPT}"

# mise install
source ~/.zshenv
source ~/.zshrc
mise install -y

# install claude code
readonly SCRIPT="${ROOT_DIR}"/common/claude_code.sh
echo "Executing ${SCRIPT}..."
chmod +x "${SCRIPT}"
bash "${SCRIPT}"

# install battery
curl -s https://raw.githubusercontent.com/actuallymentor/battery/main/setup.sh | bash