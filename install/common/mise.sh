#!/usr/bin/env bash

set -Eeuxo pipefail

function install_mise() {
    curl https://mise.run | sh
}

function uninstall_mise() {
    rm ~/.local/bin/mise
}

function main() {
    install_mise
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi