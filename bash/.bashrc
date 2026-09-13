#!/usr/bin/env bash

# If not running interactivity, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Command History
HISTFILE="$XDG_STATE_HOME/bash_history"
HISTSIZE=10000
HISTFILESIZE=10000
HISTTIMEFORMAT="[%Y/%m/%d %H:%M:%S]"
HISTCONTROL=ignoreboth
HISTIGNORE=$"nvim:c:clear:ls:ls *:ll:la:pwd:history:exit"
PROMPT_COMMAND="history -a; history -c; history -r"
clear

# Check the window size after each command and, if necessary, update the values of lines and columns
shopt -s checkwinsize

# Display customized prompt
if [ -f ~/.config/dotfiles/bash/.bash_prompt ]; then
  . ~/.config/dotfiles/bash/.bash_prompt
fi

# Alias definitions
if [ -f ~/.config/dotfiles/bash/.bash_aliases ]; then
  source ~/.config/dotfiles/bash/.bash_aliases
fi

# Programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# Load secret key of ssh
if [ ! -f /.dockerenv ]; then
  /usr/bin/keychain -q --nogui $HOME/.ssh/id_rsa 2>/dev/null $HOME/.ssh/id_ed25519 2>/dev/null
  source $HOME/.keychain/$(uname -n)-sh
fi

# git config global (for not login shell)
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/dotfiles/git/config"

