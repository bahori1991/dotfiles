
# mkdir and cd
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# touch and nvim
tvim() {
  touch "$1" && nvim "$1"
}

# get PATH 
alias path="echo $PATH | tr ':' '\n'"

# neovim
alias vim="nvim"

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

# reload bash files
alias sb="source ~/.dotfiles/bash/.bashrc"
alias sp="source ~/.dotfiles/bash/.profile"

# edit bash files
alias eb="nvim ~/.dotfiles/bash/.bashrc"
alias ep="nvim ~/.dotfiles/bash/.profile"
alias ea="nvim ~/.dotfiles/bash/.bash_aliases"

# ls
alias ls="eza -h --icons --group-directories-first"
alias ll="eza -hl --icons --group-directories-first --git"
alias la="eza -hla --icons --group-directories-first --git"

function lt() {
  local depth=1
  if [[ -n "$1" ]]; then
    depth="$1"
    shift
  fi
  command eza -hl --tree --level="$depth" --icons --group-directories-first --git "$@"
}

function lta() {
  local depth=1
  if [[ -n "$1" ]]; then
    depth="$1"
    shift
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


