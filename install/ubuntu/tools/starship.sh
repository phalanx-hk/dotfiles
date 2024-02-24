#!/usr/bin/env bash

set -Eeuxo pipefail

function install_starship() {
	curl https://starship.rs/install.sh | sh -s -- -y
}

function uninstall_starship() {
    rm "$(which starship)"
}

function main() {
    install_starship
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi