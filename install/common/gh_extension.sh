#!/usr/bin/env bash
set -Eeuxo pipefail

install_gh_extension() {
    if [ -z "${GITHUB_ACTIONS-}" ]; then
        gh auth login
    fi
    gh extension install mislav/gh-branch
    gh extension install dlvhdr/gh-dash
    gh extension install yusukebe/gh-markdown-preview
    gh extension install seachicken/gh-poi
    gh extension install mislav/gh-cp
}

function main() {
    install_gh_extension
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi