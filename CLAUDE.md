# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal macOS development environment setup containing dotfiles and installation scripts. Uses GNU Stow for symlink management.

## Setup Commands

```bash
# Full installation (Homebrew packages, apps, fonts)
./scripts/install.sh

# Link dotfiles to home directory
./scripts/link-dotfiles.sh

# Apply macOS system defaults
./scripts/macos-defaults.sh
```

## Structure

- `dotfiles/` - Tool configurations, each subdirectory mirrors XDG paths for stow
  - `nvim/` - Neovim with LazyVim framework
  - `zsh/` - Zsh + Oh My Zsh configuration
  - `ghostty/`, `starship/` - Terminal tools
  - `zed/`, `cursor/`, `ideavim/` - Editor configs
- `scripts/` - macOS install scripts

## Dotfile Management

Configs use GNU Stow - each `dotfiles/<tool>/` directory structure maps to `$HOME/`. Running `stow --target=$HOME <tool>` from `dotfiles/` creates symlinks.

Example: `dotfiles/nvim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`

## Neovim Configuration

Uses LazyVim framework with Lua config in `dotfiles/nvim/.config/nvim/`:
- `lua/config/` - Core settings (keymaps, options, autocmds)
- `lua/plugins/` - Plugin specs (appearance, completion, copilot, editor, formatting, lsp)
- Plugin lock file: `lazy-lock.json`
