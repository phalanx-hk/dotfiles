#!/usr/bin/env bash
set -x

export CUR_DIR REPO_DIR
CUR_DIR="$(cd "$(dirname "$0")" || exit 1; pwd)"
REPO_DIR="$(cd "$(dirname "$0")/../../" || exit 1; pwd)"
