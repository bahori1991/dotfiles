
# Get PATH
alias path="echo $PATH | tr ':' '\n'"

# Confirm before copy, move and remove file
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# Create parent directories
alias mkdir="mkdir -p"

# Clear terminal
alias c="clear"
alias :c="clear"

# profile
alias profile="source ~/.profile"

# Go to parent directory
alias ..="cd .."
alias ~="cd ~"

# Go to dotfiles directory
alias dot="cd ~/.config/dotfiles"

# Go to apps directory or a project under ~/apps
function apps() {
  local base="${HOME}/apps"
  local run_dev=1

  if [ "${1:-}" = "-n" ] || [ "${1:-}" = "--cd-only" ]; then
    run_dev=0
    shift
  fi

  if [ $# -eq 0 ]; then
    command cd "$base" || return
    return
  fi

  local target="$base/$1"
  if [ ! -d "$target" ]; then
    echo "apps: no such project: $1" >&2
    return 1
  fi

  command cd "$target" || return
  if [ "$run_dev" -eq 1 ] && [ -x "./dev.sh" ]; then
    echo "apps: execute ./dev.sh"
    ./dev.sh
  elif [ "$run_dev" -eq 1 ] && [ -f "./dev.sh" ]; then
    echo "apps: cannot execute dev.sh - chmod +x ./dev.sh" >&2
  fi
}

_apps_projects() {
  local d name
  for d in "${HOME}/apps"/*/; do
    [ -d "$d" ] || continue
    name="${d%/}"
    name="${name##*/}"
    printf '%s\n' "$name"
  done
}

_apps_completion() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local projects
  projects=$(_apps_projects)
  case "$COMP_CWORD" in
    1)
      # apps <Tab> -> flag + project
      COMPREPLY=( $(compgen -W "-n --cd-only ${projects}" -- "$cur") )
      ;;
    2)
      case "${COMP_WORDS[1]:-}" in
        -n|--cd-only)
          COMPREPLY=( $(compgen -W "${projects}" -- "$cur") )
          ;;
      esac
      ;;
  esac
}
complete -F _apps_completion apps

# Eza
export EZA_COLORS="di=1;33:fi=37:ln=36:or=31"

alias ls="eza -h --icons --group-directories-first"
alias ll="eza -hl --icons --group-directories-first --git"
alias la="eza -hla --icons --group-directories-first --git"

function lt() {
  lta 1 "$@"
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

# tmux
alias tmux="tmux -f ~/.config/dotfiles/tmux/tmux.conf"

# podman
alias docker="podman"

# Update symlinks of dotfiles
alias updatesymlink="source ~/.config/dotfiles/scripts/symlink.sh"
