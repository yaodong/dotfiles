# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal macOS development environment setup containing dotfiles and installation scripts. Uses GNU Stow for symlink management.

## Setup Commands

```bash
# Full installation (Homebrew packages, apps, fonts)
./machines/mac/0-install.sh

# Link dotfiles to home directory
./machines/mac/1-link-dotfiles.sh

# Apply macOS system defaults
./machines/mac/2-better-defaults.sh
```

## Structure

- `dotfiles/` - Tool configurations, each subdirectory mirrors XDG paths for stow
  - `nvim/` - Neovim with LazyVim framework
  - `zsh/` - Zsh + Oh My Zsh configuration
  - `aerospace/` - Tiling window manager
  - `sketchybar/` - Status bar with shell plugins
  - `ghostty/`, `tmux/`, `starship/` - Terminal tools
  - `zed/`, `cursor/`, `ideavim/` - Editor configs
- `machines/` - Platform-specific install scripts (mac/, arch/)

## Dotfile Management

Configs use GNU Stow - each `dotfiles/<tool>/` directory structure maps to `$HOME/`. Running `stow --target=$HOME <tool>` from `dotfiles/` creates symlinks.

Example: `dotfiles/nvim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`

## Neovim Configuration

Uses LazyVim framework with Lua config in `dotfiles/nvim/.config/nvim/`:
- `lua/config/` - Core settings (keymaps, options, autocmds)
- `lua/plugins/` - Plugin specs (appearance, completion, copilot, editor, formatting, lsp)
- Plugin lock file: `lazy-lock.json`
