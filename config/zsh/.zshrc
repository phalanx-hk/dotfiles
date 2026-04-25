HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"

if [[ "$OSTYPE" == darwin* ]]; then
    fpath+=("$(brew --prefix)/share/zsh/site-functions")
else
    fpath=(~/.zsh/pure $fpath)
fi
autoload -Uz promptinit; promptinit
prompt pure

alias cat='bat'
alias ls='eza  --icons --long --time-style=long-iso --header --git-ignore'
alias grep='rg'
alias top='btm'
alias find='fd'
alias act='act --container-architecture linux/amd64'
export GPG_TTY=$(tty)
export HISTSIZE=100000
export SAVEHIST=100000

setopt APPEND_HISTORY
setopt AUTO_CD
setopt AUTO_PARAM_KEYS
setopt INC_APPEND_HISTORY
setopt AUTO_PUSHD
setopt nonomatch
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
autoload -Uz compinit
compinit

# eval
eval "$(~/.local/bin/mise activate zsh)"
eval "$(mise hook-env)"
eval "$(sheldon source)"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh --cmd cd)"
eval "$(direnv hook zsh)"