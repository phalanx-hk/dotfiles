#!/usr/bin/env bash
set -x

source "$(dirname "$0")/common.bash"

# apt
echo "--- apt install is start! ---"
sudo /bin/sh "$CUR_DIR/apt.sh"
echo "--- apt install is done! ---"

# xh client
if ! command -v "xh" >/dev/null 2>&1
then
  echo "--- install xh is start! ---"
  curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh | sh
  echo "--- install xh is done! ---"
else
    echo "--- xh is installed! ---"
fi


# goenv
if ! command -v "goenv" >/dev/null 2>&1
then
  echo "--- install goenv is start! ---"
  git clone https://github.com/go-nv/goenv.git ~/.goenv
  echo "--- install goenv is done! ---"
else
    echo "--- goenv is installed! ---"
fi

# python
## pyenv
if ! command -v "pyenv" >/dev/null 2>&1
then
  echo "--- install pyenv is start! ---"
  xh https://pyenv.run | bash
  echo "--- install pyenv is done! ---"
else
    echo "--- pyenv is installed! ---"
fi

## poetry
if ! command -v "poetry" >/dev/null 2>&1
then
  echo "--- install poetry is start! ---"
  xh --follow https://install.python-poetry.org | python3 -
  echo "--- install poetry is done! ---"
else
    echo "--- poetry is installed! ---"
fi

# rust
if ! command -v "rustup" >/dev/null 2>&1
then
  echo "--- install rust is start! ---"
  xh https://sh.rustup.rs --https --ssl tls1.2 | sh
  source $HOME/.cargo/env
  echo "--- install rust is done! ---"
else
    echo "--- rust is installed! ---"
fi

# starship
if ! command -v "starship" >/dev/null 2>&1
then
  echo "--- install starship is start! ---"
  xh https://starship.rs/install.sh | sh
  echo "--- install starship is done! ---"
else
    echo "--- starship is installed! ---"
fi

# sheldon
cargo install sheldon

# terminal command
cargo install bat eza fd-find procs ripgrep du-dust bottom --locked

# act
if ! command -v "act" >/dev/null 2>&1
then
  echo "--- install act is start! ---"
  xh https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
  echo "--- install act is done! ---"
else
    echo "--- act is installed! ---"
fi

# terraform
if ! command -v "tfenv" >/dev/null 2>&1
then
  echo "--- install tfenv is start! ---"
  git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
  echo "--- install tfenv is done! ---"
else
    echo "--- tfenv is installed! ---"
fi

# dotfiles
echo "--- Link dotfiles is Start! ---"

## starship
mkdir -p ~/.config
ln -sf $REPO_DIR/ubuntu/starship/starship.toml ~/.config/starship.toml

## zsh
ln -sf $REPO_DIR/ubuntu/zsh/.zshrc ~/.zshrc

## sheldon
mkdir -p ~/.config/sheldon
ln -sf $REPO_DIR/ubuntu/sheldon/sheldon.toml ~/.config/sheldon/sheldon.toml

## gh
mkdir -p ~/.config/gh
ln -sf $REPO_DIR/ubuntu/gh/config.yml ~/.config/sheldon/config.yml
ln -sf $REPO_DIR/ubuntu/gh/hosts.yml ~/.config/sheldon/hosts.yml

echo "--- Link dotfiles is Done!  ---"