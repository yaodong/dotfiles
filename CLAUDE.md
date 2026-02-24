# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal development environment setup containing dotfiles and installation scripts. Uses GNU Stow for symlink management. Supports **macOS** and **Linux**.

## Source of Truth for AI Agents

**`packages.yaml`** is the structured package manifest. It lists every package with `platform` tags (`[macos, linux]` or `[macos]`), install methods, and notes on Linux-specific alternatives. Read this file first when setting up a new machine.

## Platform Support

| Component | macOS | Linux |
|-----------|-------|-------|
| CLI tools (ripgrep, fd, bat, fzf, etc.) | Yes | Yes |
| Neovim + LazyVim | Yes | Yes |
| Starship prompt | Yes | Yes |
| Zsh + Oh My Zsh | Yes | Yes |
| Mise (runtime manager) | Yes | Yes |
| Ghostty, Cursor, Zed configs | Yes | No |
| macOS casks (1Password, OrbStack, etc.) | Yes | No |
| macOS system defaults | Yes | No |

## Dotfiles Platform Map

| Dotfile | Platform | Description |
|---------|----------|-------------|
| `nvim` | macOS, Linux | Neovim with LazyVim framework |
| `starship` | macOS, Linux | Starship prompt config |
| `zsh` | macOS, Linux | Zsh + Oh My Zsh configuration |
| `ideavim` | macOS, Linux | IdeaVim (JetBrains) config |
| `ghostty` | macOS | Ghostty terminal config |
| `cursor` | macOS | Cursor editor config |
| `zed` | macOS | Zed editor config |

## Setup Commands

### macOS

```bash
./scripts/install-macos.sh   # Install Homebrew packages, apps, fonts
./scripts/link-macos.sh      # Link all dotfiles (all 7 packages)
./scripts/macos-defaults.sh  # Apply macOS system defaults
```

### Linux

```bash
./scripts/install-linux.sh   # Install cross-platform packages via apt/dnf
./scripts/link-linux.sh      # Link cross-platform dotfiles (nvim, starship, zsh, ideavim)
```

## Structure

- `packages.yaml` - Structured package manifest for AI agents (source of truth)
- `dotfiles/` - Tool configurations, each subdirectory mirrors XDG paths for stow
  - `nvim/` - Neovim with LazyVim framework (cross-platform)
  - `zsh/` - Zsh + Oh My Zsh configuration (cross-platform)
  - `starship/` - Starship prompt (cross-platform)
  - `ideavim/` - IdeaVim for JetBrains (cross-platform)
  - `ghostty/` - Ghostty terminal (macOS)
  - `cursor/` - Cursor editor (macOS)
  - `zed/` - Zed editor (macOS)
- `scripts/` - Platform-specific install and link scripts

## Dotfile Management

Configs use GNU Stow - each `dotfiles/<tool>/` directory structure maps to `$HOME/`. Running `stow --target=$HOME <tool>` from `dotfiles/` creates symlinks.

Example: `dotfiles/nvim/.config/nvim/init.lua` -> `~/.config/nvim/init.lua`

## Neovim Configuration

Uses LazyVim framework with Lua config in `dotfiles/nvim/.config/nvim/`:
- `lua/config/` - Core settings (keymaps, options, autocmds)
- `lua/plugins/` - Plugin specs (appearance, completion, copilot, editor, formatting, lsp)
- Plugin lock file: `lazy-lock.json`
