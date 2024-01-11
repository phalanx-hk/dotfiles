#!/bin/sh
# brew がインストールされていなければインストール
if [ -z "$(command -v brew)" ]; then
    echo "--- Install Homebrew is Start! ---"

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/${USER}/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    brew bundle
    echo "--- Install Homebrew is Done!  ---"
fi

if [ -z "$(command -v poetry)" ];then
    echo "--- install poetry is start ---"
    curl -sSL https://install.python-poetry.org | python3 -
    echo "--- install poetry is done---"
fi
# dotfilesを配置
echo "--- Link dotfiles is Start! ---"

# starship
mkdir -p ~/.config
ln -sf ~/dotfiles/mac/starship/starship.toml ~/.config/starship.toml

# zsh
ln -sf ~/dotfiles/mac/zsh/.zshrc ~/.zshrc

# sheldon
ln -sf .~/dotfiles/mac/sheldon/sheldon.toml ~/.config/sheldon.toml

echo "--- Link dotfiles is Done!  ---"