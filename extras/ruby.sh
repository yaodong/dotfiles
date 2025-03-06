#!/bin/bash

RUBY_VERSION="3.4.2"

brew install rbenv
brew install ruby-build

rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION

echo "Ruby $RUBY_VERSION installed"
