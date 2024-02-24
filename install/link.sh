#!/usr/bin/env bash
set -Eeuxo pipefail

CUR_DIR=$(dirname "$(readlink -f "$0")")
readonly CUR_DIR

dir=$CUR_DIR
while [[ "$dir" != "/" ]]; do
  if [[ -d "$dir/.git" ]]; then
    readonly REPO_DIR=$dir
    break
  fi
  dir=$(dirname "$dir")
done

#### make config dir ####
readonly CONFIG_DIR="$HOME/.config/"
mkdir -p "$CONFIG_DIR"

### bat ###
mkdir -p "$CONFIG_DIR"/bat
ln -sf "$REPO_DIR"/config/bat/config "$CONFIG_DIR"/bat/config

### fd ###
mkdir -p "$CONFIG_DIR"/fd
ln -sf "$REPO_DIR"/config/fd/ignore "$CONFIG_DIR"/fd/ignore

### gh ###
mkdir -p "$CONFIG_DIR"/gh
ln -sf "$REPO_DIR"/config/gh/config.yml "$CONFIG_DIR"/gh/config.yml

### git ###
mkdir -p "$CONFIG_DIR"/git
ln -sf "$REPO_DIR"/config/git/config "$CONFIG_DIR"/git/config

### homebrew ###
if [ "$(uname -s)" == "Darwin" ]; then
    ln -sf "$REPO_DIR"/config/homebrew/Brewfile ~/.Brewfile
fi

### onepassword ###
mkdir -p "$CONFIG_DIR"/op
ln -sf "$REPO_DIR"/config/op/plugins.sh "$CONFIG_DIR"/op/plugins.sh

### sheldon ###
mkdir -p "$CONFIG_DIR"/sheldon
ln -sf "$REPO_DIR"/config/sheldon/plugins.toml ~/.config/sheldon/plugins.toml

### starship ###
ln -sf "$REPO_DIR"/config/starship/starship.toml "$CONFIG_DIR"/starship.toml

### vscode ###
if [ "$(uname -s)" == "Darwin" ]; then
  readonly VSCODE_SETTING_DIR="$HOME/Library/Application\ Support/Code/User"
else
  readonly VSCODE_SETTING_DIR="$HOME/.config/Code/User"
fi
if [ ! -d "$VSCODE_SETTING_DIR" ]; then
    mkdir -p "$VSCODE_SETTING_DIR"
fi
ln -sf "${REPO_DIR}/config/vscode/settings.json" "${VSCODE_SETTING_DIR}/settings.json"

### zsh ###
ln -sf "$REPO_DIR"/config/zsh/.zshrc ~/.zshrc
ln -sf "$REPO_DIR"/config/zsh/.zshenv ~/.zshenv
