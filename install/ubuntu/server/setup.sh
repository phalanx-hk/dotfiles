#!/usr/bin/env bash
set -Eeu pipefail
set -x


SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
ROOT_DIR=$(dirname "$(dirname "$SCRIPT_DIR")")

# shellcheck source=/dev/null
. "$ROOT_DIR"/common/common.sh

### install apt packages ###
/bin/sh "$CUR_DIR"/apt.sh
