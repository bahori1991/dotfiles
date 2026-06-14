#!/usr/bin/env bash

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# bash completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
  source /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

# command history
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

# Alias definitions.
if [ -f ~/.dotfiles/bash/.bash_aliases ]; then
    source ~/.dotfiles/bash/.bash_aliases
fi

# load secret key of ssh
if [ ! -f /.dockerenv ]; then
    /usr/bin/keychain -q --nogui $HOME/.ssh/id_rsa 2>/dev/null $HOME/.ssh/id_ed25519 2>/dev/null
    source $HOME/.keychain/$(uname -n)-sh
fi

# Vite+ bin (https://viteplus.dev
. "$HOME/.vite-plus/env"
