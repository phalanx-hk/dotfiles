#!/usr/bin/env bash
set -Eeuo pipefail
set -x

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
ROOT_DIR=$(dirname "$SCRIPT_DIR")


# shellcheck source=/dev/null
source "$ROOT_DIR"/common/common.sh

### install homebrew ###
/bin/sh "$CUR_DIR/homebrew.sh"

### link dotfiles ###
/bin/sh "$CUR_DIR"/link.sh

### install rust ###
/bin/sh "$ROOT_DIR"/common/rust.sh

### install tfenv ###
/bin/sh "$ROOT_DIR"/common/tfenv.sh

### install pyenv ###
/bin/sh "$ROOT_DIR"/common/pyenv.sh

### install poetry ###
/bin/sh "$ROOT_DIR"/common/poetry.sh

### vscode ####
/bin/sh "$CUR_DIR"/vscode.sh

### gh extension ###
/bin/sh "$ROOT_DIR"/common/gh_extension.sh