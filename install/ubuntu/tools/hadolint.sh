#!/usr/bin/env bash

set -Eeuxo pipefail

readonly BIN_DIR=/usr/local/bin/
readonly BIN_PATH="${BIN_DIR}"/hadolint

function install_hadolint() {
	api_url="https://api.github.com/repos/hadolint/hadolint/releases/latest"
    tag_name=$(curl -s $api_url | jq -r '.tag_name')
    readonly tag_name api_url

    if [ "$(uname -m)" != "x86_64" ]; then 
        curl -fSL "https://github.com/hadolint/hadolint/releases/download/${tag_name}/hadolint-Linux-arm64" -o "${BIN_PATH}"
    else
        curl -fSL "https://github.com/hadolint/hadolint/releases/download/${tag_name}/hadolint-Linux-x86_64" -o "${BIN_PATH}"
    fi
    chmod 755 "${BIN_PATH}"
}


function uninstall_hadolint() {
    rm "${BIN_PATH}"
}

function main() {
    install_hadolint
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
