#!/usr/bin/env bash
set -Eeuo pipefail
set -x

echo "--- install goenv is start! ---"
git clone https://github.com/go-nv/goenv.git ~/.goenv
echo "--- install goenv is done! ---"