#!/usr/bin/env bash

HOME_DIR="$HOME"
DOTFILES_DIR="$HOME_DIR/.config/dotfiles"
source "$DOTFILES_DIR/bash/.profile"

# bash
ln -snf "$DOTFILES_DIR/bash/.bashrc" "$HOME_DIR/.bashrc"
ln -snf "$DOTFILES_DIR/bash/.bash_logout" "$HOME_DIR/.bash_logout"
ln -snf "$DOTFILES_DIR/bash/.profile" "$HOME_DIR/.profile"

# Neovim
ln -snf "$DOTFILES_DIR/nvim" "$HOME_DIR/.config/nvim"

# tmux
mkdir -p ~/.config/tmux
ln -snf "$DOTFILES_DIR/tmux/tmux.conf" ~/.config/tmux/tmux.conf
ln -snf "$DOTFILES_DIR/tmux/plugins" ~/.config/tmux/plugins

# lazygit
mkdir -p ~/.config/lazygit
ln -snf "$DOTFILES_DIR/lazygit/config.yml" ~/.config/lazygit/config.yml

# copy windows terminal settings.json (WSL only)
WT_SETTINGS="/mnt/c/Users/$WIN_USER/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
WT_TEMPLATE="$DOTFILES_DIR/terminal/settings.json.template"
if [[ -f "$WT_TEMPLATE" && -d "/mnt/c/Users/$WIN_USER" ]]; then
  sed "s/__WSL_USER__/$WSL_USER/g" "$WT_TEMPLATE" > "$WT_SETTINGS"
fi

