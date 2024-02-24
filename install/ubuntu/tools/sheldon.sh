#!/usr/bin/env bash

set -Eeuxo pipefail

readonly BIN_DIR=/usr/local/bin

function install_sheldon() {
    if [ -f "${BIN_DIR}"/sheldon ]; then
        echo "sheldon has been already installed, skip."
    else
        curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
        | bash -s -- --repo rossmacarthur/sheldon --to "${BIN_DIR}"
    fi
}

function uninstall_sheldon() {
    rm "${BIN_DIR}"/sheldon
}

function main() {
    install_sheldon
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi