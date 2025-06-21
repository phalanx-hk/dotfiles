#!/usr/bin/env zsh

set -Eeuxo pipefail

function install_mise() {
    curl https://mise.run | sh

    if [ -n "${GITHUB_ACTIONS-}" ]; then
        echo "skip mise installation in CI."
    else
        # shellcheck source=/dev/null
        source ~/.zshenv
        # shellcheck source=/dev/null
        source ~/.zshrc
        export MISE_HTTP_TIMEOUT=120s
        export MISE_FETCH_REMOTE_VERSIONS_TIMEOUT=30s
        mise install -y
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