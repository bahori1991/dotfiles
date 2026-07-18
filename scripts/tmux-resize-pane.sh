#!/usr/bin/env bash
# Debounced tmux resize to avoid repeated SIGWINCH (Cursor Agent CLI redraws on each).

set -euo pipefail

DIR="$1"
AMOUNT="${2:-5}"
TARGET="${3:-}"

safe_id="${TMUX:-default}-${TMUX_PANE:-none}-${TARGET:-active}-${DIR}"
safe_id="${safe_id//\//_}"
safe_id="${safe_id//:/_}"

BASE="${XDG_RUNTIME_DIR:-/tmp}/tmux-resize"
PENDING="$BASE/${safe_id}.pending"
TIMER="$BASE/${safe_id}.timer"

mkdir -p "$BASE"

total=$AMOUNT
if [[ -f "$PENDING" ]]; then
	total=$(( $(cat "$PENDING") + AMOUNT ))
fi
printf '%s' "$total" > "$PENDING"

if [[ -f "$TIMER" ]]; then
	kill "$(cat "$TIMER")" 2>/dev/null || true
fi

apply_resize() {
	local delta="$1"
	local args=()
	if [[ -n "$TARGET" ]]; then
		args+=(-t "$TARGET")
	fi
	tmux resize-pane "${args[@]}" "-$DIR" "$delta"
}

(
	sleep 0.08
	if [[ ! -f "$PENDING" ]]; then
		exit 0
	fi
	delta=$(cat "$PENDING")
	rm -f "$PENDING" "$TIMER"
	apply_resize "$delta"
) &
printf '%s' "$!" > "$TIMER"
