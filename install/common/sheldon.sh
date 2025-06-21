#!/usr/bin/env bash

set -Eeuxo pipefail

function install_sheldon() {
    curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
        | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
}

function uninstall_sheldon() {
    rm ~/.local/bin/sheldon
}

function main() {
    install_sheldon
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi





