# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal development environment setup containing dotfiles and installation scripts. Uses GNU Stow for symlink management. Supports **macOS** and **Linux**.

## Source of Truth for AI Agents

**`utils/packages.yaml`** is the structured package manifest. It lists every package with `platform` tags (`[macos, linux]` or `[macos]`), install methods, and notes on Linux-specific alternatives. Read this file first when setting up a new machine.

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
./utils/install-macos   # Install Homebrew packages, apps, fonts
./utils/link-macos      # Link all dotfiles (all 7 packages)
./utils/macos-defaults  # Apply macOS system defaults
```

### Linux

```bash
./utils/install-linux   # Install cross-platform packages via apt/dnf
./utils/link-linux      # Link cross-platform dotfiles (nvim, starship, zsh, ideavim)
```

## Structure

- `utils/packages.yaml` - Structured package manifest for AI agents (source of truth)
- Stow packages at repo root (each subdirectory mirrors XDG paths):
  - `nvim/` - Neovim with LazyVim framework (cross-platform)
  - `zsh/` - Zsh + Oh My Zsh configuration (cross-platform)
  - `starship/` - Starship prompt (cross-platform)
  - `ideavim/` - IdeaVim for JetBrains (cross-platform)
  - `ghostty/` - Ghostty terminal (macOS)
  - `cursor/` - Cursor editor (macOS)
  - `zed/` - Zed editor (macOS)
- `utils/` - Platform-specific install and link scripts
  - `gitignore.yaml` - Patterns to ensure in git global ignore (merged, not overwritten)
  - `ensure-gitignore` - Merges missing patterns from gitignore.yaml into ~/.config/git/ignore

## Dotfile Management

Configs use GNU Stow - each `<tool>/` directory structure maps to `$HOME/`. Running `stow --target=$HOME <tool>` from repo root creates symlinks.

Example: `nvim/.config/nvim/init.lua` -> `~/.config/nvim/init.lua`

## Keybind Conventions

- **Avoid conflicts across layers.** When adding or updating keybinds in any config, check that they don't shadow keybinds in tools that run inside it (e.g., terminal keybinds must not conflict with Neovim keybinds, since Neovim runs inside the terminal).

## Neovim Configuration

Uses LazyVim framework with Lua config in `nvim/.config/nvim/`:
- `lua/config/` - Core settings (keymaps, options, autocmds)
- `lua/plugins/` - Plugin specs (appearance, completion, copilot, editor, formatting, lsp)
- Plugin lock file: `lazy-lock.json`
