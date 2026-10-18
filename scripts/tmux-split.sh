#!/usr/bin/env bash
# Split the pane. If the source pane was opened inside a container
# (marked by the @container_exec pane option), open the new pane inside it too.
#
# usage: tmux-split.sh <-h|-v> <pane_id> <pane_current_path> [container_exec]
set -euo pipefail

FLAG="$1"
PANE="$2"
CWD="$3"
CONTAINER_EXEC="${4:-}"

if [[ -z "$CONTAINER_EXEC" ]]; then
  tmux split-window "$FLAG" -t "$PANE" -c "$CWD"
  exit 0
fi

NEW_PANE="$(tmux split-window "$FLAG" -t "$PANE" -c "$CWD" -P -F '#{pane_id}' "$CONTAINER_EXEC bash")"
tmux set-option -p -t "$NEW_PANE" @container_exec "$CONTAINER_EXEC"
