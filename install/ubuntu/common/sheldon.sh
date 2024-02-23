#!/usr/bin/env bash

# sheldon
echo "--- sheldon install is start! ---"
curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
    | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
echo "--- sheldon install is done! ---"