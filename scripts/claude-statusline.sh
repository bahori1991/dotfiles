#!/usr/bin/env bash

CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/claude-usage"
input=$(cat)
five=$(jq -r '.rate_limits.five_hour.used_percentage // empty' <<<"$input")
week=$(jq -r '.rate_limits.seven_day.used_percentage // empty' <<<"$input")

if [[ -n "$five" ]]; then
  mkdir -p "$(dirname "$CACHE")"
  printf '%.0f %.0f %s\n' "$five" "$week" "$(date +%s)" > "$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"
fi

model=$(jq -r '.model.display_name // empty' <<<"$input")
ctx=$(jq -r '.context_window.used_percentage // 0 | floor' <<<"$input")
dir=$(basename "$(jq -r '.workspace.current_dir // empty' <<<"$input")")

printf '[%s] context %s%% %s' "$model" "$ctx" "$dir"
