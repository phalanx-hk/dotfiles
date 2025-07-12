alias cat='bat'
alias ls='eza  --icons --long --time-style=long-iso --header --git-ignore'
alias grep='rg'
alias top='btm'
alias find='fd'
alias act='act --container-architecture linux/amd64'
alias claude='env CLAUDE_CONFIG_DIR=$HOME/.claude claude'
alias claudevc='env CLAUDE_CONFIG_DIR=$HOME/.claude claude --allowedTools "EDIT,WRITE"'
export GPG_TTY=$(tty)
export HISTSIZE=100000
export SAVEHIST=100000

setopt AUTO_CD
setopt AUTO_PARAM_KEYS
setopt nonomatch
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt auto_pushd
setopt auto_cd
autoload -Uz compinit
compinit

# eval
eval "$(starship init zsh)"
eval "$(~/.local/bin/mise activate zsh)"
eval "$(mise hook-env)"
eval "$(sheldon source)"
