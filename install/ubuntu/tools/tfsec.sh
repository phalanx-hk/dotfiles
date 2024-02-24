#!/usr/bin/env bash

set -Eeuxo pipefail

function install_tfsec() {
	curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
}


function uninstall_tfsec() {
    rm "$(which tfsec)"
}

function main() {
    install_tfsec
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi