#!/usr/bin/env bash

parse_json_input() {
  local input
  input=$(cat)

  local model_display current_dir transcript_path
  model_display=$(echo "$input" | jq -r '.model.display_name')
  current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
  transcript_path=$(echo "$input" | jq -r '.transcript_path')

  echo "$model_display"
  echo "$current_dir"
  echo "$transcript_path"
}

format_git_branch_display() {
  local git_branch=""

  if git rev-parse &>/dev/null; then
    local branch
    branch=$(git branch --show-current)

    if [ -n "$branch" ]; then
      git_branch=" |  $branch"
    else
      local commit_hash
      commit_hash=$(git rev-parse --short HEAD 2>/dev/null)
      if [ -n "$commit_hash" ]; then
        git_branch=" |  HEAD ($commit_hash)"
      fi
    fi
  fi

  echo "$git_branch"
}

calculate_and_format_tokens() {
  local transcript_path="$1"

  if [ -z "$transcript_path" ] || [ ! -f "$transcript_path" ]; then
    echo "_ tokens (_%)"
    return
  fi

  local total_tokens
  total_tokens=$(tail -n 100 "$transcript_path" 2>/dev/null | \
    jq -s 'map(select(.type == "assistant" and .message.usage)) |
      last |
      .message.usage |
      (.input_tokens // 0) +
      (.output_tokens // 0) +
      (.cache_creation_input_tokens // 0) +
      (.cache_read_input_tokens // 0)' 2>/dev/null)

  total_tokens=${total_tokens:-0}

  format_token_with_color "$total_tokens"
}

format_token_with_color() {
  local total_tokens="$1"
  local compaction_threshold=160000
  local percentage=$((total_tokens * 100 / compaction_threshold))

  local token_display
  if [ "$total_tokens" -ge 1000 ]; then
    local thousands
    thousands=$(echo "scale=1; $total_tokens/1000" | bc)
    token_display=$(printf "%.1fK" "$thousands")
  else
    token_display="$total_tokens"
  fi

  local color
  if [ "$percentage" -ge 90 ]; then
    color="\033[31m"
  elif [ "$percentage" -ge 70 ]; then
    color="\033[33m"
  else
    color="\033[32m"
  fi

  echo -e "${token_display} tokens (${color}${percentage}%\033[0m)"
}

build_statusline() {
  local model_display="$1"
  local current_dir="$2"
  local git_branch="$3"
  local token_count="$4"

  echo "󰚩 ${model_display} |  ${current_dir##*/}${git_branch} |  ${token_count}"
}

main() {
  local model_display current_dir transcript_path
  {
    read -r model_display
    read -r current_dir
    read -r transcript_path
  } < <(parse_json_input)

  local git_branch
  git_branch=$(format_git_branch_display)

  local token_count
  token_count=$(calculate_and_format_tokens "$transcript_path")

  build_statusline "$model_display" "$current_dir" "$git_branch" "$token_count"
}

main
