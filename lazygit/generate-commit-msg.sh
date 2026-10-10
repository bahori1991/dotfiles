#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"
if git diff --cached --quiet; then
  exit 0
fi

recent="$(git log -10 --format=%s 2>/dev/null || true)"
prompt="$(cat <<'PROMPT'
Write a git commit message for the CURRENT repository's staged changes only.
Requirements:
- Follow Conventional Commits: type(scope): subject
- Match the tone of recent commits if examples are given
- Output ONLY the commit message (subject line; optional blank line + body)
- No markdown, no code fences, no quotes around the whole message, no explanation
Recent commit subjects (for style reference):
PROMPT
)"
prompt="${prompt}
${recent}
Run or use equivalent of: git diff --cached
"

agent -p --mode ask --model composer-2.5-fast --output-format text "$prompt" \
  | sed -e '/^```/d' -e 's/^`//;s/`$//' \
  | awk 'NF{p=1} p' \
  | head -n 20
