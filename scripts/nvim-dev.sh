#!/usr/bin/env bash

set -euo pipefail
SESSION="nvim-dev"
START_DIR="$PWD"
TMUX_TERM_SOCK="nvim-dev-term"
TMUX_TERM_CONF="${TMUX_TERM_CONF:-$HOME/.tmux.term.conf}"
AGENT_CMD="${AGENT_CMD:-agent --yolo --mode ask}"
NVIM_SOCK="${XDG_RUNTIME_DIR:-/tmp}/nvim-dev-${UID}.sock"
NVIM_EDITOR_CMD="env -u NVIM NVIM_IN_TMUX=1 /usr/bin/nvim --server ${NVIM_SOCK}"

editor_pane_has_nvim() {
  local pane="$1" tty
  tty=$(tmux list-panes -t "$pane" -F '#{pane_tty}' 2>/dev/null) || return 1
  ps -o comm= -t "$tty" 2>/dev/null | grep -qiE 'nvim'
}

nvim_dev_server_alive() {
  [[ -S "$NVIM_SOCK" ]] || return 1
  /usr/bin/nvim --server "$NVIM_SOCK" --remote-expr '1' &>/dev/null
}

ensure_editor_nvim() {
  local pane
  pane=$(tmux list-panes -t "${SESSION}:editor" -F '#{pane_id}' | head -1)

  if editor_pane_has_nvim "$pane" && nvim_dev_server_alive; then
    return 0
  fi

  echo "[INFO] restarting editor nvim"
  rm -f "$NVIM_SOCK"
  tmux respawn-pane -t "$pane" -k "$NVIM_EDITOR_CMD"
}

# attach if session has been already exist
if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "[INFO] tmux session exists"
  ensure_editor_nvim
  tmux send-keys -t "${SESSION}:editor.2" "cd $(printf '%q' "$START_DIR")" C-m
  tmux attach -t "$SESSION"
  exit 0
fi

# create new session
rm -f "$NVIM_SOCK"
tmux new-session -d -s "$SESSION" -n editor -x- -y- \
  "${NVIM_EDITOR_CMD} $(printf '%q ' "$@")"
MAIN_PANE=$(tmux list-panes -t "$SESSION" -F '#{pane_id}' | head -1)

# pane 1 - Agent (right)
tmux split-window -h -t "$MAIN_PANE" -p 35 "$AGENT_CMD"

# pane 2 - Terminal (tabbed inner tmux)
# tmux split-window -v -t "$MAIN_PANE" -p 25 -c "$START_DIR" \
#   "tmux -L ${TMUX_TERM_SOCK} -f ${TMUX_TERM_CONF} new-session -A -s term -c $(printf '%q' "$START_DIR")"
tmux -L "$TMUX_TERM_SOCK" kill-session -t term 2>/dev/null || true
tmux split-window -v -t "$MAIN_PANE" -p 25 -c "$START_DIR" \
  "tmux -L ${TMUX_TERM_SOCK} -f ${TMUX_TERM_CONF} new-session -s term -c $(printf '%q' "$START_DIR")"


# focus to Neovim
tmux select-pane -t "$MAIN_PANE"
tmux attach -t "$SESSION"
