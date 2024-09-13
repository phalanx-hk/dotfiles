#!/usr/bin/env bash

set -Eeuxo pipefail

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

function install_apt_package() {
	add-apt-repository -y ppa:git-core/ppa
	apt-get update 
	apt-get upgrade -y
	apt-get install -y \
		apt-utils \
		autoconf \
		build-essential \
		ca-certificates \
		clang \
		clangd \
		clang-format \
		cmake \
		curl \
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
		shellcheck \
		sqlite3 \
		trash-cli \
		unzip \
		wget \
		zip \
		zsh
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
}

function main() {
	install_apt_package
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi