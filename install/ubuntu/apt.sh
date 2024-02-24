#!/usr/bin/env bash

set -Eeuxo pipefail

function addPackerRepo() {
	curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
	if [ "$(uname -m)" != "x86_64" ]; then 
		apt-add-repository -y "deb [arch=arm64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
	else
		apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
	fi
}

function addDockerRepo() {
	curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' | apt-key add -
	if [ "$(uname -m)" != "x86_64" ]; then 
		add-apt-repository -y "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	else
		add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	fi
}

function addGhRepo() {
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
	chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list >/dev/null
}

function addEzaRepo() {
	mkdir -p /etc/apt/keyrings
	wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --yes --dearmor -o /etc/apt/keyrings/gierens.gpg
	echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | tee /etc/apt/sources.list.d/gierens.list
	chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
}

function install_apt_package() {
	addDockerRepo
	addPackerRepo
	addGhRepo
	addEzaRepo
	add-apt-repository -y ppa:git-core/ppa
	apt-get update 
	apt-get upgrade -y
	apt-get install -y \
		apt-utils \
		autoconf \
		bat \
		build-essential \
		clang \
		clangd \
		clang-format \
		cmake \
		docker-ce \
		docker-ce-cli \
		eza \
		fd-find \
		gh \
		git \
		git-lfs \
		gpg \
		jq \
		libfuse-dev \
		libsqlite3-dev \
		libssl-dev \
		packer \
		python3 \
		ripgrep \
		shellcheck \
		sqlite3 \
		trash-cli \
		unzip \
		wget \
		zip \
		zsh
	mkdir -p "${HOME}"/.local/bin
	ln -s /usr/bin/batcat "${HOME}"/.local/bin/bat
}

function main() {
	install_apt_package
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi