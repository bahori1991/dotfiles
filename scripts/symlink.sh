#!/usr/bin/env bash

HOME_DIR="$HOME"
DOTFILES_DIR="$HOME_DIR/.config/dotfiles"

# bash
ln -snf "$DOTFILES_DIR/bash/.bashrc" "$HOME_DIR/.bashrc"
ln -snf "$DOTFILES_DIR/bash/.bash_logout" "$HOME_DIR/.bash_logout"
ln -snf "$DOTFILES_DIR/bash/.profile" "$HOME_DIR/.profile"

# utils
ln -snf "$DOTFILES_DIR/utils/.hushlogin" "$HOME_DIR/.hushlogin"
ln -snf "$DOTFILES_DIR/utils/.sudo_as_admin_successful" "$HOME_DIR/.sudo_as_admin_successful"

# Neovim
ln -snf "$DOTFILES_DIR/nvim" "$HOME_DIR/.config/nvim"

# StarShip
ln -snf "$DOTFILES_DIR/starship/starship.toml" "$HOME_DIR/.config/starship.toml"

# gitconfig
ln -snf "$DOTFILES_DIR/git/config" "$HOME_DIR/.config/git/config"

# copy windows terminal settings.json
cp -u "$DOTFILES_DIR/terminal/settings.json" "/mnt/c/users/bahori1991/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
