#!/usr/bin/env bash
# Launch Cursor Agent inside nvim-dev agent tabs.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: agent-tab.sh <new|continue|sessions>

  new       Start a new agent session (uses AGENT_CMD if set)
  continue  Resume the previous agent session
  sessions  Open interactive session picker (agent ls)
EOF
}

run_agent() {
  if [[ -n "${AGENT_CMD:-}" ]]; then
    # shellcheck disable=SC2090
    exec ${AGENT_CMD}
  fi
  exec agent --yolo
}

case "${1:-}" in
  new) run_agent ;;
  continue) exec agent --continue ;;
  sessions) exec agent ls ;;
  *)
    usage >&2
    exit 1
    ;;
esac
