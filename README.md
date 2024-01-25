# dotfiles

[![lint](https://github.com/phalanx-hk/dotfiles/actions/workflows/lint.yml/badge.svg)](https://github.com/phalanx-hk/dotfiles/actions/workflows/lint.yml)

## install just command runner
```bash
INSTALL_DIR=~/.local/bin
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ${INSTALL_DIR}
# echo "export PATH=$PATH:$INSTALL_DIR" >> ~/.zshenv
export PATH=$PATH:$INSTALL_DIR
just --version
```

## Setup

### mac [![macOS](https://github.com/phalanx-hk/dotfiles/actions/workflows/mac.yml/badge.svg)](https://github.com/phalanx-hk/dotfiles/actions/workflows/mac.yml)

```bash
just mac
```

### ubuntu client
```bash
just ubuntu-client
```

### ubuntu server
```bash
just ubuntu-server
```