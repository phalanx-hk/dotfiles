#!/usr/bin/env bash
set -Eeuo pipefail
set -x

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PARENT_DIR=$(dirname "$SCRIPT_DIR")
# shellcheck source=/dev/null
source "$PARENT_DIR"/common/common.sh

if [ -z "$(command -v brew)" ]; then
	echo "--- Install Homebrew is Start! ---"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo eval "$(/opt/homebrew/bin/brew shellenv)" >>/Users/"${USER}"/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
	echo "--- Install Homebrew is Done!  ---"
else
	echo "Hoembrew has been already installed!"
fi

echo "--- Install packages from Brewfile is Start! ---"
brew bundle --file="$REPO_DIR"/config/homebrew/Brewfile
echo "--- Install packages from Brewfile is Done!  ---"