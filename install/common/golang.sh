#!/bin/bash

set -Eeuxo pipefail

INSTALL_DIR=/usr/local
system=$(uname -s)
machine=$(uname -m)
temp_file=$(mktemp /tmp/go-install-XXXXXXXXX.tar.gz)
LATEST_VERSION=$(curl "https://go.dev/VERSION?m=text" | head -n 1)
readonly INSTALL_DIR system machine temp_file LATEST_VERSION
    
function install() {
    if [ "${system}" == "Darwin" ]; then
        curl -L https://go.dev/dl/"$LATEST_VERSION".darwin-arm64.tar.gz -o "${temp_file}"
    else
        if [ "${machine}" != "x86_64" ]; then 
            curl -L https://go.dev/dl/"$LATEST_VERSION".linux-arm64.tar.gz -o "${temp_file}"
        else
            curl -L https://go.dev/dl/"$LATEST_VERSION".linux-amd64.tar.gz -o "${temp_file}"
        fi
    fi
    sudo tar -C "${INSTALL_DIR}" -xzf "${temp_file}"
    sudo rm "${temp_file}"
}

function install_go() {
    if [ -d "${INSTALL_DIR}"/go ]; then
        OLD_VERSION=$("${INSTALL_DIR}"/go/bin/go version | grep -oP 'go\K\d+\.\d+(\.\d+)?')
        read -rp "go(version ${OLD_VERSION}) already exists. install latest version? [y/N] > " ans
        if [[ $ans =~ ^[Yy]$ ]]; then
            echo "Remove ${INSTALL_DIR}/go"
            sudo rm -rf "${INSTALL_DIR}"/go
            install
        else
            echo "Skipped golang install"
            exit 0
        fi
    else
        install
    fi
}

function uninstall_go() {
 sudo rm -rf "${INSTALL_DIR}"/go
}

function main() {
    install_go
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi