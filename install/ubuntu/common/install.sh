#!/usr/bin/env bash

source "$(dirname "$0")/common.bash"

# apt
echo "--- apt install is start! ---"
sudo /bin/sh "$CUR_DIR/apt.sh"
echo "--- apt install is done! ---"



# dotfiles
echo "--- Link dotfiles is Start! ---"

## starship
mkdir -p ~/.config
ln -sf "$REPO_DIR"/ubuntu/starship/starship.toml ~/.config/starship.toml

## zsh
ln -sf "$REPO_DIR"/ubuntu/zsh/.zshrc ~/.zshrc

## sheldon
mkdir -p ~/.config/sheldon
ln -sf "$REPO_DIR"/ubuntu/sheldon/plugins.toml ~/.config/sheldon/plugins.toml

## gh
mkdir -p ~/.config/gh
ln -sf "$REPO_DIR"/ubuntu/gh/config.yml ~/.config/gh/config.yml
ln -sf "$REPO_DIR"/ubuntu/gh/hosts.yml ~/.config/gh/hosts.yml

echo "--- Link dotfiles is Done!  ---"
