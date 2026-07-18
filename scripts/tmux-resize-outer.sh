#!/usr/bin/env bash
# Resize the outer tmux pane when called from the inner (terminal) tmux.

set -euo pipefail

direction="$1"
amount="${2:-5}"

if [[ -n "${NVIM_DEV_OUTER_PANE:-}" ]]; then
	exec /home/bahori1991/.config/dotfiles/scripts/tmux-resize-pane.sh "$direction" "$amount" "$NVIM_DEV_OUTER_PANE"
fi

exec /home/bahori1991/.config/dotfiles/scripts/tmux-resize-pane.sh "$direction" "$amount"
