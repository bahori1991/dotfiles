# ls
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first --git"
alias lt="eza --tree --level=2 --icons"

# clear
alias c="clear"

# mkdir and cd
mkcd() {
  mkdir -p "$1" && cd "$1"
}


