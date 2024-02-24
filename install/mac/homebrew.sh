#!/usr/bin/env bash
set -Eeuxo pipefail

CUR_DIR=$(dirname "$(readlink -f "$0")")
dir=$CUR_DIR
while [[ "$dir" != "/" ]]; do
  if [[ -d "$dir/.git" ]]; then
    REPO_DIR=$dir
    break
  fi
  dir=$(dirname "$dir")
done
BREWFILE="$REPO_DIR"/config/homebrew/Brewfile
readonly CUR_DIR REPO_DIR BREWFILE


function cleanup_brewfile() {
	tmpfile=$(mktemp)
	grep -v '^cask' "$BREWFILE" > "$tmpfile"
	mv "$BREWFILE" "$BREWFILE".orig
	mv "$tmpfile" "$BREWFILE"
}

function install_homebrew() {
	if [ -z "$(command -v brew)" ]; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		echo eval "$(/opt/homebrew/bin/brew shellenv)" >>/Users/"${USER}"/.zprofile
		eval "$(/opt/homebrew/bin/brew shellenv)"
	else
		echo "Hoembrew has been already installed, skip."
	fi
}

function install_brew_packages() {
	if [ -n "${GITHUB_ACTIONS+x}" ]; then
		echo "Running on GitHub Actions, cleaning up Brewfile"
		cleanup_brewfile
	fi
	brew bundle --file="$REPO_DIR"/config/homebrew/Brewfile
}

function main() {
	install_homebrew
	install_brew_packages
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	main
fi