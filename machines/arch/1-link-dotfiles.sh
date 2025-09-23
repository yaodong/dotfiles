#!/usr/bin/env bash

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "Setting up dotfiles using GNU Stow from: $REPO_DIR"

if ! command -v stow &>/dev/null; then
  echo "Error: GNU Stow is not installed."
  echo "Install it with: sudo pacman -S --needed stow"
  exit 1
fi

cd "$REPO_DIR/dotfiles"

packages=(
  "cursor"
  "ghostty"
  "nvim"
  "tmux"
  "zed"
)

for package in "${packages[@]}"; do
  echo "Stowing $package..."
  stow --target="$HOME" --restow "$package"
done

echo "All dotfiles stowed successfully!"
