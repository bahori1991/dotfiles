
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

# Go to dotfiles directory
alias dot="cd ~/.config/dotfiles"

# Go to apps directory or a project under ~/apps
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
    COMPREPLY=( $(compgen -W "$(command ls -l "${HOME}/apps" 2>/dev/null)" -- "$cur") )
  fi
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

# Wget
alias wget="wget --hsts-file=\"\$XDG_CONFIG_HOME/wget/wget-hsts\""

# Update symlinks of dotfiles
alias updatesymlink="source ~/.config/dotfiles/scripts/symlink.sh"
