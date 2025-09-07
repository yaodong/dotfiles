#!/usr/bin/env sh

set -e

BASE_DIR="$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" && pwd)"

# Helper function for cask installations
brew_cask() {
  local package="$1"
  local quarantine_flag=""

  if [ "$2" = "--no-quarantine" ]; then
    quarantine_flag="--no-quarantine"
  fi

  brew install --cask $quarantine_flag "$package" || echo "$package already installed"
}

# Get list of installed packages once
INSTALLED_PACKAGES=$(brew list)

# Helper function to check if package is installed and install if not
brew_install() {
  if echo "$INSTALLED_PACKAGES" | grep -q "^$1$"; then
    echo "$1 is already installed"
  else
    echo "Installing $1..."
    brew install "$1"
  fi
}

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

# Install essential packages
echo "Installing essential packages..."
brew_install gcc
brew_install ripgrep
brew_install coreutils
brew_install fd
brew_install cmake
brew_install tree-sitter

# Install utilities
echo "Installing utilities..."
brew_install bat
brew_install btop
brew_install fastfetch
brew_install eza
brew_install fzf
brew_install git
brew_install wget
brew_install zoxide
brew_install lazygit
brew_install lazydocker
brew_install mise

# Install applications
echo "Installing applications..."
brew_cask alacritty --no-quarantine
brew_install tmux
brew_install neovim
brew_install starship
brew_install zsh-autosuggestions
brew_install hashicorp/tap/terraform

# Install docker or orbstack depending on the user
if echo "$(whoami)" | grep -q "\."; then
  echo "Skipping orbstack installation"
else
  brew_cask orbstack
fi

# Install fonts
echo "Installing fonts..."
brew_cask font-jetbrains-mono
brew_cask font-jetbrains-mono-nerd-font
brew_cask font-hack-nerd-font
brew_cask 1password
brew_cask betterdisplay
brew_cask the-archive
brew_cask nikitabobko/tap/aerospace

brew_install FelixKratz/formulae/sketchybar
brew_install FelixKratz/formulae/borders

# Configure
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Setup completed successfully!"
