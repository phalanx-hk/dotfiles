#!/usr/bin/env bash
set -Eeuxo pipefail


SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
ROOT_DIR=$(dirname "$(dirname "$SCRIPT_DIR")")

# shellcheck source=/dev/null
. "$ROOT_DIR"/common/common.sh

### install apt packages ###
sudo /bin/bash "$CUR_DIR"/apt.bash
