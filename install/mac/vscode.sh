#!/usr/bin/env bash
set -Eeuo pipefail
set -x

echo "--- Install vscode extensions is Start! ---"
VSCODE_SETTING_DIR="$HOME/Library/Application\ Support/Code/User"
if [ ! -d "$VSCODE_SETTING_DIR" ]; then
  mkdir -p "$VSCODE_SETTING_DIR"
fi
ln -sf "${REPO_DIR}/config/vscode/settings.json" "${VSCODE_SETTING_DIR}/settings.json"
echo "--- Install vscode extensions is Done!  ---"
