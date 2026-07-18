#!/usr/bin/env bash

set -euo pipefail
SESSION="nvim-dev"
START_DIR="$PWD"
TMUX_TERM_SOCK="nvim-dev-term"
TMUX_TERM_CONF="${TMUX_TERM_CONF:-$HOME/.tmux.term.conf}"
TMUX_AGENT_SOCK="nvim-dev-agent"
TMUX_AGENT_CONF="${TMUX_AGENT_CONF:-$HOME/.tmux.agent.conf}"
AGENT_TAB="${AGENT_TAB:-$HOME/.config/dotfiles/scripts/agent-tab.sh}"
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

find_term_pane() {
  local saved pane
  saved=$(tmux show-environment -g NVIM_DEV_TERM_PANE 2>/dev/null | sed 's/^NVIM_DEV_TERM_PANE=//' || true)
  if [[ -n "$saved" ]] && tmux display -p -t "$saved" '#{pane_id}' &>/dev/null; then
    echo "$saved"
    return 0
  fi
  pane=$(tmux list-panes -t "${SESSION}:editor" -F '#{pane_id} #{pane_start_command}' 2>/dev/null \
    | grep 'nvim-dev-term' | awk '{print $1}' | head -1)
  if [[ -n "$pane" ]]; then
    echo "$pane"
    return 0
  fi
  # fallback for legacy layouts (direct bash pane, wrong pane index, etc.)
  tmux list-panes -t "${SESSION}:editor" \
    -F '#{pane_id} #{pane_current_command} #{pane_start_command}' 2>/dev/null \
    | awk '$2 != "nvim" && $0 !~ /nvim-dev-agent/ { print $1; exit }'
}

cd_term_pane() {
  local pane=$1
  [[ -n "$pane" ]] || return 0
  tmux send-keys -t "$pane" "cd $(printf '%q' "$START_DIR")" C-m
}

# attach if session has been already exist
if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "[INFO] tmux session exists"
  ensure_editor_nvim
  cd_term_pane "$(find_term_pane)"
  tmux attach -t "$SESSION"
  exit 0
fi

# create new session
rm -f "$NVIM_SOCK"
tmux new-session -d -s "$SESSION" -n editor -x- -y- \
  "${NVIM_EDITOR_CMD} $(printf '%q ' "$@")"
MAIN_PANE=$(tmux list-panes -t "$SESSION" -F '#{pane_id}' | head -1)

# pane 1 - Agent tabs (right, inner tmux)
tmux -L "$TMUX_AGENT_SOCK" kill-session -t agent 2>/dev/null || true
tmux split-window -h -t "$MAIN_PANE" -p 35 \
  "tmux -L ${TMUX_AGENT_SOCK} -f ${TMUX_AGENT_CONF} \
    new-session -e NVIM_DEV_OUTER_PANE='#{pane_id}' -e AGENT_CMD=$(printf '%q' "$AGENT_CMD") \
    -s agent -c $(printf '%q' "$START_DIR") $(printf '%q' "$AGENT_TAB") new"

# pane 2 - Terminal (tabbed inner tmux)
tmux -L "$TMUX_TERM_SOCK" kill-session -t term 2>/dev/null || true
TERM_PANE=$(
  tmux split-window -v -t "$MAIN_PANE" -p 25 -c "$START_DIR" -P -F '#{pane_id}' \
    "tmux -L ${TMUX_TERM_SOCK} -f ${TMUX_TERM_CONF} new-session -e NVIM_DEV_OUTER_PANE='#{pane_id}' -s term -c $(printf '%q' "$START_DIR")"
)
tmux set-environment -g NVIM_DEV_TERM_PANE "$TERM_PANE"

# focus to Neovim
tmux select-pane -t "$MAIN_PANE"
tmux attach -t "$SESSION"
