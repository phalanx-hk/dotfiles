#!/usr/bin/env bash
set -x

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PARENT_DIR=$(dirname "$SCRIPT_DIR")

# shellcheck source=/dev/null
source "$PARENT_DIR"/common/common.sh

### install homebrew ###
/bin/sh "$CUR_DIR/homebrew.sh"

### link dotfiles ###
/bin/sh "$CUR_DIR"/link.sh

### install rust ###
/bin/sh "$PARENT_DIR"/common/rust.sh

### install goenv ###
/bin/sh "$PARENT_DIR"/common/goenv.sh

### install tfenv ###
/bin/sh "$PARENT_DIR"/common/tfenv.sh

### install pyenv ###
/bin/sh "$PARENT_DIR"/common/pyenv.sh

### install poetry ###
/bin/sh "$PARENT_DIR"/common/poetry.sh

### vscode ####
/bin/sh "$CUR_DIR"/vscode.sh

### gh extension ###
/bin/sh "$PARENT_DIR"/common/gh_extension.sh