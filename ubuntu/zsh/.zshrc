# starshipの設定
eval "$(starship init zsh)"

# sheldonをロード
eval "$(sheldon source)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# poetry
export PATH="$HOME/.local/bin:$PATH"

# goenv
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"

# tfenv
export PATH="$HOME/.tfenv/bin:$PATH"

## パスを直接入力してもcdする
setopt AUTO_CD
## 環境変数を補完
setopt AUTO_PARAM_KEYS

alias cat='bat'
alias ls='eza  --icons --long --time-style=long-iso'
alias find='fd'
alias ps='procs --tree'
alias grep='rg'
alias du='dust'
alias top='btm'
alias act='gh act'