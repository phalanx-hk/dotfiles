#!/usr/bin/env bash

set -Eeuxo pipefail

function install_bottom() {
	tmp_file="$(mktemp /tmp/bottom-XXXXXXXXXX.deb)"
	api_endpoint="https://api.github.com/repos/ClementTsang/bottom/releases/latest"
	latest_version=$(curl -s $api_endpoint | jq -r '.tag_name')
	if [ "$(uname -m)" != "x86_64" ]; then 
		deb_url=https://github.com/ClementTsang/bottom/releases/download/${latest_version}/bottom_${latest_version}_arm64.deb
	else
		deb_url=https://github.com/ClementTsang/bottom/releases/download/${latest_version}/bottom_${latest_version}_amd64.deb
	fi
	curl -fSL "{$deb_url}" -o "${tmp_file}"
	dpkg -i "$tmp_file"
}


function uninstall_bottom() {
    rm "$(which btm)"
}

function main() {
    install_bottom
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi