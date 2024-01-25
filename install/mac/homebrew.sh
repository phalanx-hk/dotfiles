#!/usr/bin/env bash
set -Eeuo pipefail
set -x

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PARENT_DIR=$(dirname "$SCRIPT_DIR")
BREWFILE="$REPO_DIR"/config/homebrew/Brewfile


function cleanup_brewfile() {
	tmpfile=$(mktemp)
	grep -v '^cask' "$BREWFILE" > "$tmpfile"
	mv "$BREWFILE" "$BREWFILE".orig
	mv "$tmpfile" "$BREWFILE"
}

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
if [ -n "$GITHUB_ACTIONS" ]; then
	cleanup_brewfile
fi
brew bundle --file="$REPO_DIR"/config/homebrew/Brewfile
echo "--- Install packages from Brewfile is Done!  ---"