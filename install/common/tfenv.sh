#!/usr/bin/env bash
set -Eeuo pipefail
set -x

echo "--- install tfenv is start! ---"
git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
echo "--- install tfenv is done! ---"