#!/usr/bin/env bash

set -Eeuxo pipefail

readonly BIN_DIR=/usr/local/bin

function install_act() {
    tmp_file="$(mktemp /tmp/act-install-XXXXXXXXXX.sh)"
    curl -Lo "${tmp_file}" https://raw.githubusercontent.com/nektos/act/master/install.sh
    bash "${tmp_file}" -b "${BIN_DIR}"
}

function uninstall_act() {
    rm "${BIN_DIR}"/act
}

function main() {
    install_act
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi