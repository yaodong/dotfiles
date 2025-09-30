#!/usr/bin/env bash

set -e

# Get the absolute path to the repository root directory
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "Setting up dotfiles using GNU Stow from: $REPO_DIR"

# Check if stow is installed
if ! command -v stow &>/dev/null; then
  echo "Error: GNU Stow is not installed."
  echo "Install it with: brew install stow"
  exit 1
fi

# Change to config directory
cd "$REPO_DIR/dotfiles"

# Stow all packages (hardcoded list)
packages=(
  "aerospace"
  "cursor"
  "ghostty"
  "ideavim"
  "nvim"
  "sketchybar"
  "starship"
  "tmux"
  "zed"
  "zsh"
)

for package in "${packages[@]}"; do
  echo "Stowing $package..."
  stow --target="$HOME" --restow "$package"
done

echo "All dotfiles stowed successfully!"
