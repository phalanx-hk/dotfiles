#!/usr/bin/env bash

set -Eeuxo pipefail

function install_skills() {
    zsh -c '
        source ~/.zshenv
        source ~/.zshrc
        npx -y skills@latest add yizhiyanhua-ai/fireworks-tech-graph -g -y -a claude-code -a codex
        npx -y skills@latest add mattpocock/skills --skill grill-me -g -y -a claude-code -a codex
        npx -y skills@latest add mattpocock/skills --skill to-prd -g -y -a claude-code -a codex
    '
}

function main() {
    install_skills
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
