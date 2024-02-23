#!/usr/bin/env bash

set -Eeuo pipefail

function install_eza() {
	mkdir -p /etc/apt/keyrings
	wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
	echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | tee /etc/apt/sources.list.d/gierens.list
	chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
	apt update &&
	apt install -y eza
}

function install_gh() {
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
	chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
	apt update &&
	apt install gh -y
}

function install_bottom() {
	local tmp_file
    tmp_file="$(mktemp /tmp/bottom-XXXXXXXXXX.deb)"
	api_endpoint="https://api.github.com/repos/ClementTsang/bottom/releases/latest"
	latest_version=$(curl -s $api_endpoint | jq -r '.tag_name')
	if [ "$(uname -m)" != "x86_64" ]; then 
		deb_url=https://github.com/ClementTsang/bottom/releases/download/${latest_version}/bottom_${latest_version}_arm64.deb
	else
		deb_url=https://github.com/ClementTsang/bottom/releases/download/${latest_version}/bottom_${latest_version}_amd64.deb
	fi
	curl -fSL "{$deb_url}" -o "${tmp_file}"
	dpkg -i install "$tmp_file"
}

function install_base() {
	add-apt-repository -y ppa:git-core/ppa
	apt-get update 
	apt-get upgrade -y
	apt-get install -y \
		sudo \
		software-properties-common \
		bat \
		build-essential \
		curl \
		clang \
		clangd \
		clang-format \
		cmake \
		fd-find \
		git \
		git-lfs \
		gpg \
		jq \
		libfuse-dev \
		libsqlite3-dev \
		libssl-dev \
		ripgrep \
		shellcheck \
		sqlite3 \
		trash-cli \
		unzip \
		zip \
		zsh
}

function main() {
	install_base
	install_eza
	install_bottom
	install_gh
}

main