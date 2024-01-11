# CodeWhisperer pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/hirotoshi-kitamura/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/hirotoshi-kitamura/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/hirotoshi-kitamura/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/hirotoshi-kitamura/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/hirotoshi-kitamura/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/hirotoshi-kitamura/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/hirotoshi-kitamura/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/hirotoshi-kitamura/google-cloud-sdk/completion.zsh.inc'; fi

# starshipの設定
eval "$(starship init zsh)"

# sheldonをロード
eval "$(sheldon source)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# poetry
export PATH="$PATH:$HOME/Library/Application\ Support/pypoetry/venv/bin"

## パスを直接入力してもcdする
setopt AUTO_CD
## 環境変数を補完
setopt AUTO_PARAM_KEYS

alias cat='bat'
alias ls='eza  --icons'
alias find='fd'
alias ps='procs -tree'
alias grep='rg'
alias du='dust'
alias top='btm'

# CodeWhisperer post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh"
