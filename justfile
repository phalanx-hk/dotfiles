set shell := ["zsh", "-cu"]

# install dotfiles on mac environment
mac:
	@/bin/sh install/mac/setup.sh

# install dotfiles on devcontainer
devcontainer:
    @/bin/sh install/ubuntu/server/devcontainer/setup.sh

#install dotfiles on ubuntu client
ubuntu-client:
    @/bin/sh install/ubuntu/client/setup.sh