#!/usr/bin/env sh

set -e

BASE_DIR="$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" && pwd)"

# Disable press and hold for key repeat
defaults write -g ApplePressAndHoldEnabled -bool false

# Disable auto-correct
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# Disable smart quotes
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

# Install Homebrew if it's not installed
if command -v brew &>/dev/null; then
  echo "Homebrew is installed"
else
  echo "Homebrew is not installed"
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
fi

# Install oh-my-zsh if it's not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "oh-my-zsh is not installed"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Update Homebrew and add required taps
echo "Updating Homebrew and adding required taps..."
brew update
brew tap homebrew/services

# Install essential packages
echo "Installing essential packages..."
brew install gcc
brew install ripgrep
brew install coreutils
brew install fd
brew install cmake
brew install tree-sitter

# Install utilities
echo "Installing utilities..."
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

# Install applications
echo "Installing applications..."
brew install neovim
brew install starship
brew install zsh-autosuggestions
brew install --cask ghostty


bash "$BASE_DIR/apps/tmux/install.sh"

# Install fonts
echo "Installing fonts..."
brew install --cask font-jetbrains-mono
brew install --cask font-jetbrains-mono-nerd-font

# Configure
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Setup completed successfully!"
