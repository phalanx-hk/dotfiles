#!/usr/bin/env bash
set -Eeuo pipefail

echo "--- install tfenv is start! ---"
if [ -d "$HOME/.tfenv" ]; then
    read -rp ".tfenv already exists. Reinstall? [y/N] > " ans
    if [[ $ans =~ ^[Yy]$ ]]; then
        echo "Remove .tfenv"
        rm -rf ~/.tfenv
        git clone --depth=1 https://github.com/tfutils/tfenv.git "$HOME/.tfenv"
    else
        echo "Skipped tfenv install"
        exit 0
    fi
else
    git clone --depth=1 https://github.com/tfutils/tfenv.git "$HOME/.tfenv"
fi
echo "--- install tfenv is done! ---"