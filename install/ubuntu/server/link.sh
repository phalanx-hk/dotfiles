
#!/usr/bin/env bash

source "$(dirname "$0")/common.bash"

echo "--- Link dotfiles is Start! ---"

mkdir -p ~/.config
ln -sf "$REPO_DIR"/ubuntu/starship/starship.toml ~/.config/starship.toml

ln -sf "$REPO_DIR"/ubuntu/zsh/.zshrc ~/.zshrc

mkdir -p ~/.config/sheldon
ln -sf "$REPO_DIR"/ubuntu/sheldon/plugins.toml ~/.config/sheldon/plugins.toml

mkdir -p ~/.config/gh
ln -sf "$REPO_DIR"/ubuntu/gh/config.yml ~/.config/gh/config.yml

echo "--- Link dotfiles is Done!  ---"
