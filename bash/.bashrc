#!/usr/bin/env bash

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# command history
HISTFILE="$XDG_STATE_HOME/bash_history"
HISTSIZE=10000
HISTFILESIZE=10000
HISTTIMEFORMAT="[%Y/%m/%d %H:%M:%S] "
HISTCONTROL=ignoreboth
HISTIGNORE=$"&:ls:ls*:ll:lt:lt*:la:ps:top:df:du:clear:c:cd*:history:pwd"
PROMPT_COMMAND="history -a; history -c; history -r"
shopt -u histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# # make less more friendly for non-text input files, see lesspipe(1)
# [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# EDITOR
export EDITOR="nvim"
export VISUAL="nvim"

# PS1 (Pureline)
# source ~/.dotfiles/bash/pureline/pureline ~/.dotfiles/bash/.pureline.conf

# PS1 (Starship)
eval "$(starship init bash)"

# Alias definitions.
if [ -f ~/.dotfiles/bash/.bash_aliases ]; then
    source ~/.dotfiles/bash/.bash_aliases
fi

# Programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# load secret key of ssh
if [ ! -f /.dockerenv ]; then
    /usr/bin/keychain -q --nogui $HOME/.ssh/id_rsa 2>/dev/null $HOME/.ssh/id_ed25519 2>/dev/null
    source $HOME/.keychain/$(uname -n)-sh
fi

# add PATH for use of cursor-cli agents
export PATH="$HOME/.local/bin:$PATH"

# Vite+ installation directory (https://viteplus.dev/guide/env)
export VP_HOME="$HOME/.local/share/.vite-plus"

# Vite+ bin (https://viteplus.dev)
source "$VP_HOME/env"

# Rust
source "$HOME/.cargo/env"
