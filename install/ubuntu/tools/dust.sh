#!/usr/bin/env bash

set -Eeuxo pipefail

function install_dust() {
	tmp_file="$(mktemp /tmp/dust-XXXXXXXXXX.tar.gz)"
    tmp_dir="$(mktemp -d /tmp/dust-XXXXXXXXXX)"
	api_endpoint="https://api.github.com/repos/bootandy/dust/releases/latest"
	latest_version=$(curl -s $api_endpoint | jq -r '.tag_name')
	readonly tmp_file tmp_dir api_endpoint latest_version

	if [ "$(uname -m)" != "x86_64" ]; then 
		tar_url=https://github.com/bootandy/dust/releases/download/${latest_version}/dust-${latest_version}-aarch64-unknown-linux-gnu.tar.gz
	else
		tar_url=https://github.com/bootandy/dust/releases/download/${latest_version}/dust-${latest_version}-x86_64-unknown-linux-gnu.tar.gz
	fi
	curl -Lo "${tmp_file}" "{$tar_url}"
    tar xf "${tmp_file}" --strip-components=1 -C "${tmp_dir}"
    mv "${tmp_dir}"/dust /usr/local/bin
    rm "${tmp_file}"
    rm -rf "${tmp_dir}"
}


function uninstall_dust() {
    rm "$(which dust)"
}

function main() {
    install_dust
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi