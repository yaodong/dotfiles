#!/usr/bin/env sh

set -e

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
