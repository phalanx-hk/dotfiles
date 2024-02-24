#!/usr/bin/env bash

set -Eeuxo pipefail

function install_delta() {
	tmp_file="$(mktemp /tmp/delta-XXXXXXXXXX.deb)"
	api_endpoint="https://api.github.com/repos/dandavison/delta/releases/latest"
	latest_version=$(curl -s $api_endpoint | jq -r '.tag_name')
	if [ "$(uname -m)" != "x86_64" ]; then 
    https://github.com/dandavison/delta/releases/download/0.16.5/delta-0.16.5-aarch64-apple-darwin.tar.gz
		deb_url=https://github.com/dandavison/delta/releases/download/${latest_version}/git-delta_${latest_version}_arm64.deb
	else
		deb_url=https://github.com/dandavison/delta/releases/download/${latest_version}/git-delta_${latest_version}_amd64.deb
	fi
	curl -fSL "{$deb_url}" -o "${tmp_file}"
	dpkg -i "$tmp_file"
}


function uninstall_delta() {
    rm "$(which delta)"
}

function main() {
    install_delta
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi