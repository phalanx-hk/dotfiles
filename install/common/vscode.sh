#!/usr/bin/env bash

set -Eeuxo pipefail

CUR_DIR="$(dirname "$(readlink -f "$0")")"
readonly CUR_DIR
dir=$CUR_DIR

while [[ "$dir" != "/" ]]; do
  if [[ -d "$dir/.git" ]]; then
    readonly REPO_DIR=$dir
    break
  fi
  dir=$(dirname "$dir")
done

function install_extension() {
  if [ -n "${GITHUB_ACTIONS-}" ]; then
        echo "skip vscode extension installation in CI."
  else
    while read -r line
    do
      code --install-extension "$line"
    done < "${REPO_DIR}"/config/vscode/extensions
  fi
}

function main() {
    install_extension
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi