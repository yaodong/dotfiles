#!/usr/bin/env bash

set -e

# Get the absolute path to the repository root directory
REPO_DIR="$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" && pwd)"

echo "Setting up symbolic links from repository at: $REPO_DIR"

ln -sf "$REPO_DIR/apps/zsh/.zshrc" ~/.zshrc
ln -sf "$REPO_DIR/apps/nvim" ~/.config/
ln -sf "$REPO_DIR/apps/starship/starship.toml" ~/.config/starship.toml
ln -sf "$REPO_DIR/apps/tmux/.tmux.conf" ~/.tmux.conf
ln -sf "$REPO_DIR/apps/ghostty" ~/.config/
ln -sf "$REPO_DIR/apps/ideavim/ideavimrc" ~/.ideavimrc

echo "Symbolic links created successfully!"
