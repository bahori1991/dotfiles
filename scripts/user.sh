#!/usr/bin/env bash
# set WSL and Windows Username

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.config/dotfiles}"

# set a specific name if necessary
# ${WIN_USER:=<Your Windows Username>
# ${WSL_User:=<Your WSL Username>

# get Windows Username
if [[ -z "$WIN_USER" || ! -d "/mnt/c/Users/$WIN_USER" ]]; then
  _detected=$(cmd.exe /c 'echo %USERNAME%' 2>/dev/null | tr -d '\r\n')
  if [[ -n "$_detected" && -d "/mnt/c/Users/$_detected" ]]; then
    WIN_USER="$_detected"
  fi
  unset _detected
fi

export WIN_USER="${WIN_USER:-$USER}"
export WSL_USER="${WSL_USER:-$USER}"

