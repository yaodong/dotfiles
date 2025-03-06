#!/usr/bin/env sh

set -e

brew update
brew tap homebrew/bundle
brew tap homebrew/services

# Eessentials
brew install gcc
brew install ripgrep
brew install coreutils
brew install fd
brew install cmake
brew install tree-sitter

# Utilities
brew install bat
brew install btop
brew install eza
brew install fzf
brew install git
brew install tldr
brew install wget
brew install zoxide
brew install yazi
brew install lazygit
brew install lazydocker

# Applications
brew install neovim
brew install starship
brew install tmux
brew install zsh-autosuggestions
brew install --cask ghostty

# Fonts
brew install --cask font-jetbrains-mono
brew install --cask font-jetbrains-mono-nerd-font
