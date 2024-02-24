#!/usr/bin/env bash

set -Eeuxo pipefail

readonly INSTALL_DIR="$HOME/.local/"

function install_poetry() {
    curl -sSL https://install.python-poetry.org | POETRY_HOME="${INSTALL_DIR}" python3 -
}

function uninstall_poetry() {
    rm "${INSTALL_DIR}"/bin/poetry
}

function main() {
    install_poetry
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi