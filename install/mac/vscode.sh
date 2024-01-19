#!/usr/bin/env bash
set -x

echo "--- Install vscode extensions is Start! ---"
VSCODE_SETTING_DIR=~/Library/Application\ Support/Code/User
ln -sf "${REPO_DIR}/config/vscode/settings.json" "${VSCODE_SETTING_DIR}/settings.json"
echo "--- Install vscode extensions is Done!  ---"
