#!/usr/bin/env bash

set -e

# Get the absolute path to the repository root directory
WORK_DIR="$(dirname "$(dirname "${BASH_SOURCE[0]}")")"

brew install tmux

# Install tmux plugin manager
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Link tmux configuration
ln -sf "$WORK_DIR/.tmux.conf" ~/.tmux.conf

# Install plugins automatically without using tmux key bindings
~/.tmux/plugins/tpm/bin/install_plugins
