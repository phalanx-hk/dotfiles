#!/usr/bin/env bash
set -Eeuxo pipefail

CUR_DIR=$(dirname "$(readlink -f "$0")")
readonly CUR_DIR

dir=$CUR_DIR
while [[ "$dir" != "/" ]]; do
  if [[ -d "$dir/.git" ]]; then
    readonly REPO_DIR=$dir
    break
  fi
  dir=$(dirname "$dir")
done

function link_skill_dirs() {
    local source_dir=$1
    local target_dir=$2

    mkdir -p "$target_dir"
    for skill in "$source_dir"/*; do
        [ -d "$skill" ] || continue

        local target
        target="$target_dir/$(basename "$skill")"
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            echo "Refusing to overwrite non-symlink: $target" >&2
            return 1
        fi

        ln -sfn "$skill" "$target"
    done
}

#### make config dir ####
readonly CONFIG_DIR="$HOME/.config/"
mkdir -p "$CONFIG_DIR"

### bat ###
mkdir -p "$CONFIG_DIR"/bat
ln -sf "$REPO_DIR"/config/bat/config "$CONFIG_DIR"/bat/config

### fd ###
mkdir -p "$CONFIG_DIR"/fd
ln -sf "$REPO_DIR"/config/fd/ignore "$CONFIG_DIR"/fd/ignore

### gh ###
mkdir -p "$CONFIG_DIR"/gh
ln -sf "$REPO_DIR"/config/gh/config.yml "$CONFIG_DIR"/gh/config.yml

### git ###
mkdir -p "$CONFIG_DIR"/git
ln -sf "$REPO_DIR"/config/git/config "$CONFIG_DIR"/git/config

### homebrew ###
if [ "$(uname -s)" == "Darwin" ]; then
    ln -sf "$REPO_DIR"/config/homebrew/Brewfile ~/.Brewfile
fi

### onepassword ###
mkdir -p "$CONFIG_DIR"/op
ln -sf "$REPO_DIR"/config/op/plugins.sh "$CONFIG_DIR"/op/plugins.sh

### sheldon ###
mkdir -p "$CONFIG_DIR"/sheldon
ln -sf "$REPO_DIR"/config/sheldon/plugins.toml ~/.config/sheldon/plugins.toml


### vscode ###
if [ "$(uname -s)" == "Darwin" ]; then
  readonly VSCODE_SETTING_DIR="$HOME/Library/Application\ Support/Code/User"
else
  readonly VSCODE_SETTING_DIR="$HOME/.config/Code/User"
fi
if [ ! -d "$VSCODE_SETTING_DIR" ]; then
    mkdir -p "$VSCODE_SETTING_DIR"
fi
ln -sf "${REPO_DIR}/config/vscode/settings.json" "${VSCODE_SETTING_DIR}/settings.json"

### zsh ###
ln -sf "$REPO_DIR"/config/zsh/.zshrc ~/.zshrc
ln -sf "$REPO_DIR"/config/zsh/.zshenv ~/.zshenv


### mise ###
readonly MISE_CONFIG_DIR="$HOME/.config/mise"
if [ ! -d "$MISE_CONFIG_DIR" ]; then
    mkdir -p "$MISE_CONFIG_DIR"
fi
ln -sf "$REPO_DIR"/config/mise/mise.toml ~/.config/mise/config.toml

### agent skills ###
readonly AGENT_SOURCE_DIR="$REPO_DIR/config/agent"
readonly AGENT_CONFIG_DIR="$HOME/.agents"
if [ ! -d "$AGENT_CONFIG_DIR" ]; then
    mkdir -p "$AGENT_CONFIG_DIR"
fi

readonly AGENT_SKILLS_SOURCE_DIR="$REPO_DIR/config/agent/skills"
readonly AGENTS_SKILLS_DIR="$HOME/.agents/skills"
link_skill_dirs "$AGENT_SKILLS_SOURCE_DIR" "$AGENTS_SKILLS_DIR"


### claude code ###
readonly CLAUDE_CODE_DIR="$HOME/.claude"
if [ ! -d "$CLAUDE_CODE_DIR" ]; then
    mkdir -p "$CLAUDE_CODE_DIR"
fi
ln -sf "$AGENT_SOURCE_DIR"/AGENTS.md "$CLAUDE_CODE_DIR"/CLAUDE.md
ln -sf "$REPO_DIR"/config/claude_code/settings.json "$CLAUDE_CODE_DIR"/settings.json
ln -sf "$REPO_DIR"/config/claude_code/statusline.py "$CLAUDE_CODE_DIR/statusline.py"
ln -sf "$REPO_DIR"/config/claude_code/agents "$CLAUDE_CODE_DIR"
ln -sf "$REPO_DIR"/config/claude_code/commands "$CLAUDE_CODE_DIR"
ln -sf "$REPO_DIR"/config/claude_code/rules "$CLAUDE_CODE_DIR"
ln -sf "$REPO_DIR"/config/claude_code/hooks "$CLAUDE_CODE_DIR"

link_skill_dirs "$AGENT_SKILLS_SOURCE_DIR" "$CLAUDE_CODE_DIR/skills"
chmod +x "$CLAUDE_CODE_DIR"/statusline.py
chmod +x "$CLAUDE_CODE_DIR"/hooks/cmux-notify.sh


### codex ###
readonly CODEX_DIR="$HOME/.codex"
if [ ! -d "$CODEX_DIR" ]; then
    mkdir -p "$CODEX_DIR"
fi
ln -sf "$REPO_DIR"/config/codex/config.toml "$CODEX_DIR"/config.toml
ln -sf "$AGENT_SOURCE_DIR"/AGENTS.md "$CODEX_DIR"/AGENTS.md
mkdir -p "$CODEX_DIR"/rules
ln -sf "$REPO_DIR"/config/codex/rules/default.rules "$CODEX_DIR"/rules/default.rules

### ghostty ###
readonly GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
if [ ! -d "$GHOSTTY_CONFIG_DIR" ]; then
    mkdir -p "$GHOSTTY_CONFIG_DIR"
fi
ln -sf "$REPO_DIR"/config/ghostty/config "$GHOSTTY_CONFIG_DIR"/config

### gwq ###
readonly GWQ_CONFIG_DIR="$HOME/.config/gwq"
if [ ! -d "$GWQ_CONFIG_DIR" ]; then
    mkdir -p "$GWQ_CONFIG_DIR"
fi
ln -sf "$REPO_DIR"/config/gwq/config.toml "$GWQ_CONFIG_DIR"/config.toml

### helix ###
readonly HELIX_CONFIG_DIR="$HOME/.config/helix"
if [ ! -d "$HELIX_CONFIG_DIR" ]; then
    mkdir -p "$HELIX_CONFIG_DIR"
fi
ln -sf "$REPO_DIR"/config/helix/config.toml "$HELIX_CONFIG_DIR"/config.toml
