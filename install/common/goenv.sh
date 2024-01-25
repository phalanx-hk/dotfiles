#!/usr/bin/env bash
set -Eeuo pipefail

echo "--- install goenv is start! ---"
if [ -d "$HOME/.goenv" ]; then
    read -rp ".goenv already exists. Reinstall? [y/N] > " ans
    if [[ $ans =~ ^[Yy]$ ]]; then
        echo "Remove .goenv"
        rm -rf ~/.goenv
        git clone https://github.com/go-nv/goenv.git "$HOME/.goenv"
    else
        echo "Skipped goenv install"
        exit 0
    fi
else
    git clone https://github.com/go-nv/goenv.git "$HOME/.goenv"
fi
echo "--- install goenv is done! ---"