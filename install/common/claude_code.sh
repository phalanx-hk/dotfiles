#!/usr/bin/env bash

set -Eeuxo pipefail

function install_claude_code() {
    npm install -g @anthropic-ai/claude-code
}

function uninstall_claude_code() {
    npm uninstall -g @anthropic-ai/claude-code
}

function main() {
    install_claude_code
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi