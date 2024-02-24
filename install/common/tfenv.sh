#!/usr/bin/env bash

set -Eeuxo pipefail

readonly INSTALL_DIR="$HOME/.tfenv"

function install_tfenv() {
    if [ -d "${INSTALL_DIR}" ]; then
        read -rp ".tfenv already exists. Reinstall? [y/N] > " ans
        if [[ $ans =~ ^[Yy]$ ]]; then
            echo "Remove .tfenv"
            rm -rf "$INSTALL_DIR"
            git clone --depth=1 https://github.com/tfutils/tfenv.git "$INSTALL_DIR"
        else
            echo "Skipped tfenv install"
            exit 0
        fi
    else
        git clone --depth=1 https://github.com/tfutils/tfenv.git "$INSTALL_DIR"
    fi
}

function uninstall_tfenv() {
    rm -rf "${INSTALL_DIR}"
}

function main() {
    install_tfenv
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi