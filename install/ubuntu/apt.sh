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
	install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	chmod a+r /etc/apt/keyrings/docker.asc
	# shellcheck disable=SC1091
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  		$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  		tee /etc/apt/sources.list.d/docker.list > /dev/null
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
	add-apt-repository -y ppa:git-core/ppa
	apt-get update 
	apt-get upgrade -y
	apt-get install -y \
		apt-transport-https \
		apt-utils \
		autoconf \
		bat \
		build-essential \
		ca-certificates \
		clang \
		clangd \
		clang-format \
		cmake \
		curl \
		fd-find \
		git \
		git-lfs \
		gpg \
		jq \
		libfuse-dev \
		libsqlite3-dev \
		libssl-dev \
		liblzma-dev \
		libbz2-dev \
		libreadline-dev \
		python3 \
		python3-pip \
		ripgrep \
		shellcheck \
		sqlite3 \
		trash-cli \
		unzip \
		wget \
		zip \
		zsh
	mv /usr/bin/batcat /usr/bin/bat
	if ! command -v docker &> /dev/null; then
		addDockerRepo
		apt-get update
		apt-get install -y \
			docker-ce \
			docker-ce-cli \
			containerd.io \
			docker-buildx-plugin \
			docker-compose-plugin
	fi
	addPackerRepo
	addGhRepo
	addEzaRepo
	apt-get update
	apt-get install -y \
		gh \
		eza \
		packer
}

function main() {
	install_apt_package
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi