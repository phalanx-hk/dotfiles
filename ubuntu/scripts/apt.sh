#!/bin/sh -e

add-apt-repository -y ppa:git-core/ppa
apt-get update && apt-get upgrade -y
apt-get install -y \
	autoconf \
	build-essential \
	curl \
	clang \
	clangd \
	clang-format \
	cmake \
	git \
	git-lfs \
	golang-go \
	gpg \
	jq \
	libfuse-dev \
	libsqlite3-dev \
	libssl-dev \
	python3 \
	python3-pip \
	python3-pynvim \
	shellcheck \
	sqlite3 \
	tmux \
	trash-cli \
	unzip \
	wget \
	zip \
	zsh

# gh
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
	sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
	sudo apt update &&
	sudo apt install gh -y

# Docker
arch=$(uname -m)
curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' | apt-key add -
if [ "$arch" = "aarch64" ]; then
	add-apt-repository -y "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
elif [ "$arch" = "x86_64" ]; then
	add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
fi
apt-get update
apt-get install -y docker-ce docker-ce-cli