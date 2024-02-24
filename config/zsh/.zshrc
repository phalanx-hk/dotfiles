# starship
eval "$(starship init zsh)"

# sheldon
eval "$(sheldon source)"

# pyenv
eval "$(pyenv init -)"

setopt AUTO_CD
setopt AUTO_PARAM_KEYS

alias cat='bat'
alias ls='eza  --icons --long --time-style=long-iso --header'
alias find='fd'
alias grep='rg'
alias top='btm'
alias act='act --container-architecture linux/amd64'

export GPG_TTY=$(tty)