#!/usr/bin/env bash
set -Eeuo pipefail
set -x

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
# shellcheck source=/dev/null
source "$(dirname "$SCRIPT_DIR")"/common/common.sh

CONFIG_DIR="$HOME/.config/"
mkdir -p "$CONFIG_DIR"

echo "--- Link dotfiles is Start! ---"

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
ln -sf "$REPO_DIR"/config/git/config ~/.gitconfig

### homebrew ###
ln -sf "$REPO_DIR"/config/homebrew/Brewfile ~/.Brewfile

### onepassword ###
mkdir -p "$CONFIG_DIR"/op
ln -sf "$REPO_DIR"/config/op/plugins.sh "$CONFIG_DIR"/op/plugins.sh

### sheldon ###
mkdir -p "$CONFIG_DIR"/sheldon
ln -sf "$REPO_DIR"/config/sheldon/plugins.toml ~/.config/sheldon/plugins.toml

### starship ###
ln -sf "$REPO_DIR"/config/starship/starship.toml "$CONFIG_DIR"/starship.toml

### zsh ###
ln -sf "$REPO_DIR"/config/zsh/.zshrc ~/.zshrc
ln -sf "$REPO_DIR"/config/zsh/.zshenv ~/.zshenv

echo "--- Link dotfiles is Done!  ---"
