# ~/.profile: executed by the command interpreter for login shells.

source "$HOME/.config/dotfiles/scripts/user.sh"

export EDITOR="nvim"
export VISUAL="nvim"

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.local/cache}"

export LESSHISTFILE="$XDG_STATE_HOME/lesshst"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/dotfiles/git/config"

if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

