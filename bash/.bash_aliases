
# mkdir and cd
mkcd() {
  mkdir -p "$1" && cd "$1"
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

# ls
alias ls="eza --icons --group-directories-first"
alias ll="eza -l --icons --group-directories-first --git"
alias la="eza -la --icons --group-directories-first --git"
alias lt="eza --tree --level=2 --icons"

# alias chmod commands
alias mx="chmod a+x"
alias 000="chmod -R 000"
alias 644="chmod -R 644"
alias 666="chmod -R 666"
alias 755="chmod -R 755"
alias 777="chmod -R 777"


