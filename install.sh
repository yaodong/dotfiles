# Exit immediately if a command exits with a non-zero status
set -e

# Install the required packages using Brew
brew update
brew bundle install

ln -s "$HOME/.local/bento/zellij" "$HOME/.config/zellij"
ln -s "$HOME/.local/bento/doom" "$HOME/.config/doom"
ln -s "$HOME/.local/zsh/.zshrc" "$HOME/.zshrc"
