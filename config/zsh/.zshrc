# starship
eval "$(starship init zsh)"

# sheldon
eval "$(sheldon source)"

# pyenv
eval "$(pyenv init -)"

# rye
source "$HOME/.rye/env"

setopt AUTO_CD
setopt AUTO_PARAM_KEYS
setopt nonomatch

alias cat='bat'
alias ls='eza  --icons --long --time-style=long-iso --header'
alias find='fd'
alias grep='rg'
alias top='btm'
alias act='act --container-architecture linux/amd64'

export GPG_TTY=$(tty)
export HISTSIZE=10000
export SAVEHIST=10000

. "$HOME/.cargo/env"
eval "$(gh copilot alias -- zsh)"
