HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"

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
eval "$(starship init zsh)"
eval "$(~/.local/bin/mise activate zsh)"
eval "$(mise hook-env)"
eval "$(sheldon source)"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh --cmd cd)"
eval "$(direnv hook zsh)"

gclaude() {
    local target_dir="${1:-$(pwd)}"

    if [[ ! "$target_dir" = /* ]]; then
        target_dir="$(cd "$target_dir" 2>/dev/null && pwd)"
    fi

    if [[ ! -d "$target_dir" ]]; then
        echo "Error: Directory does not exist: $target_dir"
        return 1
    fi

    osascript <<EOF
        tell application "Ghostty" to activate
        delay 0.1

        tell application "System Events"
            tell process "Ghostty"
                -- Type cd command and enter to change directory
                keystroke "cd ${target_dir}"
                keystroke return
                delay 0.1

                -- Split right (Cmd+D) for right pane
                keystroke "d" using command down
                delay 0.1

                -- In right pane: cd to target directory
                keystroke "cd ${target_dir}"
                keystroke return
                delay 0.1

                -- Split down (Cmd+Shift+D) for bottom-right pane
                keystroke "D" using {command down, shift down}
                delay 0.1

                -- In bottom-right pane: cd and run keifu
                keystroke "cd ${target_dir} && keifu"
                keystroke return
                delay 0.1

                -- Resize: make bottom pane smaller (30%)
                -- Shrink bottom pane using Cmd+Ctrl+Arrow Down
                repeat 5 times
                    key code 125 using {command down, control down}
                    delay 0.1
                end repeat

                -- Go to top-right pane (Cmd+Arrow Up)
                key code 126 using command down
                delay 0.2

                -- Top-right pane is zsh (already there, just ensure directory)
                keystroke "cd ${target_dir}"
                keystroke return
                delay 0.2

                -- Go to left pane (Cmd+Arrow Left)
                key code 123 using command down
                delay 0.2

                -- Left pane: run claude code
                keystroke "claude"
                keystroke return
            end tell
        end tell
EOF
    echo "Workspace created in: $target_dir"
}
