# starship
eval "$(starship init zsh)"

setopt AUTO_CD
setopt AUTO_PARAM_KEYS
setopt nonomatch

alias cat='bat'
alias ls='eza  --icons --long --time-style=long-iso --header --git-ignore'
alias grep='rg'
alias top='btm'
alias act='act --container-architecture linux/amd64'

export GPG_TTY=$(tty)
export HISTSIZE=10000
export SAVEHIST=10000


# mise
eval "$(~/.local/bin/mise activate zsh)"
eval "$(mise hook-env)"
