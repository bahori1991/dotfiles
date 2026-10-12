#!/usr/bin/env bash
set -euo pipefail

SESSION="${1:-}"
ROOT="${2:-}"

if [[ -z "$SESSION" ]] && command -v tmux >/dev/null 2>&1; then
  SESSION="$(tmux display-message -p '#{session_name}' 2>/dev/null || true)"
fi

if [[ -z "$ROOT" ]] && command -v tmux >/dev/null 2>&1; then
  ROOT="$(tmux show-environment -g DEV_COMPOSE_ROOT 2>/dev/null | cut -d= -f2- || true)"
fi

if [[ -z "$SESSION" ]]; then
  echo "usage: $0 <tmux-session> [compose-root]" >&2
  exit 1
fi

if [[ -z "$ROOT" || ! -f "$ROOT/compose.yaml" ]]; then
  echo "nvim-dev-session-kill: DEV_COMPOSE_ROOT / compose.yaml missing" >&2 
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "nvim-dev-session-kill: docker not found" >&2
  exit 1
fi

COMPOSE=(docker compose --project-directory "$ROOT" -f "$ROOT/compose.yaml")
STATE_ROOT="${XDG_STATE_HOME:-$HOME/.local/state}/nvim/swap"

compose_pgrep() {
  local svc=$1
  "${COMPOSE[@]}" exec -T "$svc" pgrep -x nvim 2>/dev/null || true
}

pid_alive_in_container() {
  local svc=$1 pid=$2
  [[ -n "$pid" ]] || return 1
  "${COMPOSE[@]}" exec -T "$svc" kill -0 "$pid" 2>/dev/null
}

read_swap_pid() {
  local file=$1
  python3 - "$file" <<'PY'
import struct, sys
path = sys.argv[1]
with open(path, "rb") as f:
    d = f.read(256)
if len(d) < 28 or d[:6] not in (b"b0VIM ", b"b0NVIM"):
    raise SystemExit(1)
print(struct.unpack_from("<I", d, 24)[0])
PY
}

remove_swaps_matching_pids() {
  local segment=$1
  shift
  local -a target_pids=("$@")
  local dir="${STATE_ROOT}/${segment}"
  local swp spid pid match
  [[ -d "$dir" ]] || return 0
  ((${#target_pids[@]})) || return 0
  shopt -s nullglob
  for swp in "$dir"/*.swp "$dir"/*.swo "$dir"/*.swn; do
    [[ -f "$swp" ]] || continue
    spid="$(read_swap_pid "$swp" 2>/dev/null)" || continue
    match=0
    for pid in "${target_pids[@]}"; do
      if [[ "$spid" == "$pid" ]]; then
        match=1
        break
      fi
    done
    ((${match})) && rm -f -- "$swp"
  done
}

collect_dead_pids() {
  local svc=$1
  shift
  local -a before=("$@")
  local pid
  for pid in "${before[@]}"; do
    [[ -n "$pid" ]] || continue
    if ! pid_alive_in_container "$svc" "$pid"; then
      echo "$pid"
    fi
  done
}

# --- 1) :wqa on nvim panes (dev.sh: frontend/backend window, pane 1) ---
for win in frontend backend; do
  if tmux list-windows -t "$SESSION" -F '#{window_name}' 2>/dev/null | grep -qx "$win"; then
    tmux send-keys -t "${SESSION}:${win}.1" Escape ':wqa' Enter 2>/dev/null || true
  fi
done
sleep 0.5

# --- 2) Snapshot nvim PIDs in containers (includes embed if running) ---
mapfile -t BEFORE_F < <(compose_pgrep frontend | grep -E '^[0-9]+$' || true)
mapfile -t BEFORE_B < <(compose_pgrep backend | grep -E '^[0-9]+$' || true)

# --- 3) KIll tmux session 
tmux kill-session -t "$SESSION"
sleep 0.5

# --- 4) PIDs that were running before and are dead now ---
mapfile -t DEAD_F < <(collect_dead_pids frontend "${BEFORE_F[@]}")
mapfile -t DEAD_B < <(collect_dead_pids backend "${BEFORE_B[@]}")

# --- 5) Remove swap files owned by those PIDs only ---
remove_swaps_matching_pids frontend "${DEAD_F[@]}"
remove_swaps_matching_pids backend "${DEAD_B[@]}"
