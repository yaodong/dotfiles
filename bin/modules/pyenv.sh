#!/bin/bash

PLUGIN_DIR="$(pyenv root)/plugins/pyenv-update"

# Check if pyenv-update plugin directory exists
if [ ! -d "$PLUGIN_DIR" ]; then
  echo "pyenv-update plugin not found. Installing..."
  git clone https://github.com/pyenv/pyenv-update.git "$PLUGIN_DIR"
else
  echo "pyenv-update plugin found. Checking for updates..."
  cd "$PLUGIN_DIR"

  # Check if there are any changes to pull
  git remote update
  LOCAL=$(git rev-parse @)
  REMOTE=$(git rev-parse @{u})

  if [ "$LOCAL" != "$REMOTE" ]; then
    echo "Updates available. Pulling latest changes..."
    git pull
  else
    echo "pyenv-update is up to date"
  fi
fi

# Update pyenv
echo "Updating pyenv..."
pyenv update
