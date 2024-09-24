# Exit immediately if a command exits with a non-zero status
set -e

# Install the required packages using Brew
brew update
brew bundle install

ln -sf "$HOME/.local/bento/zellij" "$HOME/.config/zellij"
ln -sf "$HOME/.local/bento/doom" "$HOME/.config/doom"
ln -sf "$HOME/.local/bento/zsh/.zshrc" "$HOME/.zshrc"
