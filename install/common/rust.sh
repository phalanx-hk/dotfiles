#!/usr/bin/env bash
set -x

# rust
echo "--- install rust is start! ---"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path	
echo "--- install rust is done! ---"