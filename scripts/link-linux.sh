#!/usr/bin/env bash

set -e

# Link cross-platform dotfiles on Linux.
# See packages.yaml `dotfiles` section for platform tags.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Setting up dotfiles using GNU Stow from: $REPO_DIR"

# Check if stow is installed
if ! command -v stow &>/dev/null; then
  echo "Error: GNU Stow is not installed."
  echo "Install it with: sudo apt-get install stow"
  exit 1
fi

cd "$REPO_DIR/dotfiles"

# Cross-platform dotfiles only (see packages.yaml)
packages=(
  "ideavim"
  "nvim"
  "starship"
  "zsh"
)

for package in "${packages[@]}"; do
  echo "Stowing $package..."
  stow --target="$HOME" --restow "$package"
done

echo "All cross-platform dotfiles stowed successfully!"
