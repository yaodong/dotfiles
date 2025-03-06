#!/bin/bash


brew tap oven-sh/bun
brew install oven-sh/bun/bun
brew install nvm

if [ ! -d "$HOME/.nvm" ]; then
  git clone --depth=1 https://github.com/nvm-sh/nvm.git ~/.nvm
fi

source ~/.nvm/nvm.sh
nvm install --lts
nvm use --lts


echo "Node $(node --version) installed"