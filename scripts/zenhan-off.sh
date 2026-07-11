#!/usr/bin/env bash
ZENHAN="/mnt/c/users/bahori1991/bin/zenhan/zenhan.exe"
if [[ -f "$ZENHAN" ]]; then
  "$ZENHAN" 0 >/dev/null 2>&1
fi

# Pass Escape through to the pane (shell, fzf, etc.)
if [[ -n "${1:-}" ]]; then
  tmux send-keys -t "$1" Escape
fi
