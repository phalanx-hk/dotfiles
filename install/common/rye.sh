#!/usr/bin/env bash

set -Eeuxo pipefail

readonly RYE_HOME="$HOME/.rye"

function install_rye() {
    curl -sSf https://rye.astral.sh/get | RYE_NO_AUTO_INSTALL=1 RYE_INSTALL_OPTION="--yes" bash
}

function uninstall_rye() {
    rm -rf "${RYE_HOME}"
}

function main() {
    install_rye
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi