#!/usr/bin/env bash

set -Eeuxo pipefail

function install_mise() {
    curl https://mise.run | sh

    if [ -n "${GITHUB_ACTIONS-}" ]; then
        echo "skip mise installation in CI."
    else
        zsh -c '
            source ~/.zshenv
            source ~/.zshrc
            mise install -y
        '
    fi
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
