#!/bin/sh
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
VSCODE_SETTING_DIR=~/Library/Application\ Support/Code/User

# backup
mkdir "$SCRIPT_DIR/backup"
cp "$VSCODE_SETTING_DIR/settings.json" "$SCRIPT_DIR/backup"
code --list-extensions > "$SCRIPT_DIR/backup/extensions"


rm "$VSCODE_SETTING_DIR/settings.json"
ln -sf "$SCRIPT_DIR/settings.json" "${VSCODE_SETTING_DIR}/settings.json"

while read -r line
do
  code --install-extension "$line"
done < extensions

code --list-extensions > extensions