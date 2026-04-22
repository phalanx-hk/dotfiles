#!/usr/bin/env bash
set -Eeuo pipefail

CMUX_SOCKET="/tmp/cmux.sock"
if [ ! -S "$CMUX_SOCKET" ]; then
  exit 0
fi

input=$(timeout 5 cat)

event=$(echo "$input" | jq -r '.hook_event_name // empty')
tool_name=$(echo "$input" | jq -r '.tool_name // empty')

case "$event" in
  Stop)
    echo "$input" | cmux notify --socket "$CMUX_SOCKET" --title "Claude Code" --body "Session complete"
    ;;
  PostToolUse)
    if [ "$tool_name" = "Task" ]; then
      echo "$input" | cmux notify --socket "$CMUX_SOCKET" --title "Claude Code" --body "Agent finished"
    fi
    ;;
esac
