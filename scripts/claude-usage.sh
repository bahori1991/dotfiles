#!/usr/bin/env bash

CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/claude-usage"
[[ -f "$CACHE" ]] || exit 0

read -r five week ts < "$CACHE"
(( $(date +%s) - ts > 21600 )) && exit 0

color() {
  if   (( $1 >= 95 )); then echo "#f44747"
  elif (( $1 >= 80 )); then echo "#ffd600"
  else echo "#66ff00"; fi
}

bar() {
  local filled=$(( ($1 + 5) / 10 )) out="" i
  (( filled > 10 )) && filled=10
  for (( i = 0; i < 10; i++ )); do
    if (( i < filled )); then out+="▓"; else out+="░"; fi
  done
  printf '%s' "$out"
}

printf 'usage: #[fg=%s]5h %s %s%% #[fg=%s]7d %s %s%%#[default] ' \
  "$(color "$five")" "$(bar "$five")" "$five" \
  "$(color "$week")" "$(bar "$week")" "$week"
