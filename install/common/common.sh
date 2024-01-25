#!/usr/bin/env bash
set -Eeuo pipefail
set -x

export CUR_DIR REPO_DIR
CUR_DIR="$(
	cd "$(dirname "$0")" || exit 1
	pwd
)"

dir=$CUR_DIR
while [[ "$dir" != "/" ]]; do
  if [[ -d "$dir/.git" ]]; then
    REPO_DIR=$dir
    break
  fi
  dir=$(dirname "$dir")
done
