#!/usr/bin/env bash

echo "--- hadolint install is start! ---"

api_url="https://api.github.com/repos/hadolint/hadolint/releases/latest"
tag_name=$(curl -s $api_url | jq -r '.tag_name')
if [ "$(uname -m)" != "x86_64" ]; then 
    curl -fSL "https://github.com/hadolint/hadolint/releases/download/${tag_name}/hadolint-Linux-arm64" -o /usr/local/bin/hadolint
else; then
    curl -fSL "https://github.com/hadolint/hadolint/releases/download/${tag_name}/hadolint-Linux-x86_64" -o /usr/local/bin/hadolint
fi
chmod 755 /usr/local/bin/hadolint

echo "--- hadolint install is done! ---"