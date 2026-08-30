#!/usr/bin/env bash
# Toggle the nvim-dev agent pane (right column) on the default tmux server.

set -euo pipefail

SESSION="nvim-dev"
DEFAULT_PCT=35
HIDDEN_THRESHOLD=2

outer_tmux() {
	env -u TMUX tmux "$@"
}

find_agent_pane() {
	local saved pane
	saved="$(outer_tmux show-environment -g NVIM_DEV_AGENT_PANE 2>/dev/null | sed 's/^NVIM_DEV_AGENT_PANE=//' || true)"
	if [[ -n "$saved" ]] && outer_tmux display -p -t "$saved" '#{pane_id}' &>/dev/null; then
		echo "$saved"
		return 0
	fi
	pane="$(outer_tmux list-panes -s -t "$SESSION" -F '#{pane_id} #{pane_start_command}' 2>/dev/null \
		| grep 'nvim-dev-agent' | awk '{print $1; exit}')"
	[[ -n "$pane" ]] || return 1
	echo "$pane"
}

active_pane_in_session() {
	outer_tmux list-panes -s -t "$SESSION" -F '#{pane_id} #{pane_active}' 2>/dev/null \
		| awk '$2 == 1 { print $1; exit }'
}

agent_is_hidden() {
	local width="$1"
	[[ "$width" -le "$HIDDEN_THRESHOLD" ]]
}

save_agent_pct() {
	local agent="$1"
	local pane_width window_width pct
	pane_width="$(outer_tmux display -p -t "$agent" '#{pane_width}')"
	window_width="$(outer_tmux display -p -t "$agent" '#{window_width}')"
	[[ "$window_width" -gt 0 ]] || return 0
	pct=$(( pane_width * 100 / window_width ))
	if [[ "$pct" -gt 5 ]]; then
		outer_tmux set-environment -g NVIM_DEV_AGENT_PCT "$pct"
	fi
}

if ! outer_tmux has-session -t "$SESSION" 2>/dev/null; then
	exit 0
fi

agent="$(find_agent_pane)" || exit 0
width="$(outer_tmux display -p -t "$agent" '#{pane_width}')"
pct="$(outer_tmux show-environment -g NVIM_DEV_AGENT_PCT 2>/dev/null | sed 's/^NVIM_DEV_AGENT_PCT=//' || true)"
pct="${pct:-$DEFAULT_PCT}"

if agent_is_hidden "$width"; then
	outer_tmux resize-pane -t "$agent" -x "${pct}%"
	outer_tmux set-environment -g NVIM_DEV_AGENT_HIDDEN 0
	outer_tmux display-message "agent pane shown (${pct}%)"
	exit 0
fi

save_agent_pct "$agent"
current_pane="$(active_pane_in_session || true)"
if [[ -n "$current_pane" && "$current_pane" == "$agent" ]]; then
	main_pane="$(outer_tmux list-panes -s -t "$SESSION" -F '#{pane_id} #{pane_start_command}' \
		| grep -v 'nvim-dev-agent' | awk '{print $1; exit}')"
	if [[ -n "$main_pane" ]]; then
		outer_tmux select-pane -t "$main_pane"
	fi
fi
outer_tmux resize-pane -t "$agent" -x 0
outer_tmux set-environment -g NVIM_DEV_AGENT_HIDDEN 1
outer_tmux display-message "agent pane hidden"
