#!/usr/bin/env bash

set -Eeuxo pipefail

readonly BIN_DIR=/usr/local/bin

function install_just() {
    if [ -f "${BIN_DIR}"/just ]; then
        echo "just has been already installed, skip."
    else
        curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to "${BIN_DIR}"
    fi
}

function uninstall_just() {
    rm "${BIN_DIR}/just"
}


function main() {
    install_just
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi