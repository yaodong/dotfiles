#!/bin/bash

# Check for uv installation
if ! command -v uv &> /dev/null; then
  echo "uv could not be found. Installing..."
  brew install uv
  echo "uv has been installed successfully!"
else
  echo "uv is already installed"
fi

PYTHON_VERSION=3.12

# Install Python if needed
if ! uv python list | grep -q "${PYTHON_VERSION}"; then
  echo "Installing Python ${PYTHON_VERSION}..."
  uv python install ${PYTHON_VERSION}
  echo "Python ${PYTHON_VERSION} has been installed successfully!"
else
  echo "Python ${PYTHON_VERSION} is already installed"
fi

echo "Setup complete! Python ${PYTHON_VERSION} is ready to use with uv"
