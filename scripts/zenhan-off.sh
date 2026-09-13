#!/usr/bin/env bash

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.config/dotfiles}"

source "$DOTFILES_DIR/scripts/user.sh"

# set zenhan.exe path in Window
ZENHAN="/mnt/c/Users/$WIN_USER/bin/zenhan/zenhan.exe"

if [[ -f "$ZENHAN" ]]; then
  "$ZENHAN" 0 >/dev/null 2>&1
fi

# Pass Escape through to the pane (shell, fzf, etc...)
if [[ -n "${1:-}" ]]; then
  tmux send-keys -t "$1" Escape
fi
