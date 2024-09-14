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
readonly COMMON_DIR="${ROOT_DIR}"/common/
for SCRIPT in "${COMMON_DIR}"/*.sh; do
  if [ -f "$SCRIPT" ]; then
    echo "Executing ${SCRIPT}..."
    chmod +x "${SCRIPT}"
    bash "${SCRIPT}"
  else
    echo "No shell scripts found in ${COMMON_DIR}."
  fi
done

#### install mise dependencies ####
mise install -y