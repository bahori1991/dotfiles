
# mkdir and cd
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Neovim and tmux
NVIM_DEV_SOCK="${XDG_RUNTIME_DIR:-/tmp}/nvim-dev-${UID}.sock"

nvim_tmux() {
  if [ -n "${NVIM_IN_TMUX:-}" ]; then
    env -u NVIM NVIM_IN_TMUX=1 /usr/bin/nvim --server "$NVIM_DEV_SOCK" "$@"
    return
  fi
  if [ -n "${TMUX:-}" ] && [ "$(tmux display-message -p '#S' 2>/dev/null)" = "nvim-dev" ]; then
    if [ "$(tmux display-message -p '#{pane_index}' 2>/dev/null)" = "0" ]; then
      env -u NVIM NVIM_IN_TMUX=1 /usr/bin/nvim --server "$NVIM_DEV_SOCK" "$@"
    else
      env -u NVIM command nvim "$@"
    fi
    return
  fi
  if [ -n "${TMUX:-}" ]; then
    env -u NVIM command nvim "$@"
    return
  fi
  ~/.config/dotfiles/scripts/nvim-dev.sh "$@"
}

alias nvim="nvim_tmux"

# get PATH 
alias path="echo $PATH | tr ':' '\n'"

# Add an "alert" alias for long running commands. Ex: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Modified Commands
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -iv"
alias mkdir="mkdir -p"
alias c="clear"

# Change directory aliases
alias home="cd ~"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# goto dotfiles directory
alias dot="cd ~/.config/dotfiles/"

# goto apps directory or a project under ~/apps
function apps() {
  local base="${HOME}/apps"

  if [ $# -eq 0 ]; then
    command cd "$base" || return
    return
  fi

  local target="$base/$1"
  if [ -d "$target" ]; then
    command cd "$target" || return
  else
    echo "apps: no such project: $1" >&2
    return 1
  fi
}

_apps_completion() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(command ls -1 "${HOME}/apps" 2>/dev/null)" -- "$cur") )
  fi
}
complete -F _apps_completion apps

# reload bash files
alias sb="source ~/.config/dotfiles/bash/.bashrc"
alias sp="source ~/.config/dotfiles/bash/.profile"

# edit bash files
alias eb="nvim ~/.config/dotfiles/bash/.bashrc"
alias ep="nvim ~/.config/dotfiles/bash/.profile"
alias ea="nvim ~/.config/dotfiles/bash/.bash_aliases"

# eza
alias ls="eza -h --icons --group-directories-first"
alias ll="eza -hl --icons --group-directories-first --git"
alias la="eza -hla --icons --group-directories-first --git"

function lt() {
  local depth=1
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    depth="$1"
    shift
  else
    depth=1
  fi
  command eza -hl --tree --level="$depth" --icons --group-directories-first --git "$@"
}

function lta() {
  local depth=1
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    depth="$1"
    shift
  else
    depth=1
  fi
  command eza -hla --tree --level="$depth" --icons --group-directories-first --git "$@"
} 

# alias chmod commands
alias mx="chmod a+x"
alias 000="chmod -R 000"
alias 644="chmod -R 644"
alias 666="chmod -R 666"
alias 755="chmod -R 755"
alias 777="chmod -R 777"

# wget
alias wget="wget --hsts-file=\"\$XDG_CONFIG_HOME/wget/wget-hsts\""

# update symlinks of dotfiles
alias updatesymlink="source ~/.config/dotfiles/scripts/symlink.sh"
