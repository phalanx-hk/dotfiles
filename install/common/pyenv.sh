#!/usr/bin/env bash
set -Eeuo pipefail

echo "--- install pyenv is start! ---"
if [ -d "$HOME/.pyenv" ]; then
    read -rp ".pyenv already exists. Reinstall? [y/N] > " ans
    if [[ $ans =~ ^[Yy]$ ]]; then
        echo "Remove .pyenv"
        rm -rf ~/.pyenv
        curl https://pyenv.run | bash
    else
        echo "Skipped pyenv install"
        exit 0
    fi
else
    curl https://pyenv.run | bash
fi
echo "--- install pyenv is done! ---"
