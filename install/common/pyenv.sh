#!/usr/bin/env bash

set -Eeuxo pipefail

function install_pyenv() {
    if [ -d "$HOME"/.pyenv ]; then
        read -rp ".pyenv already exists. Reinstall? [y/N] > " ans
        if [[ $ans =~ ^[Yy]$ ]]; then
            echo "Remove .pyenv"
            rm -rf "$HOME"/.pyenv/
            curl https://pyenv.run | bash
        else
            echo "Skipped pyenv install"
            exit 0
        fi
    else
        curl https://pyenv.run | bash
    fi
}

function uninstall_pyenv() {
    rm -rf "$HOME"/.pyenv/
}

function main() {
    install_pyenv
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi