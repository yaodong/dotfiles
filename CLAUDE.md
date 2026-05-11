# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal development environment setup containing dotfiles and installation scripts. Uses GNU Stow for symlink management. Supports **macOS** and **Linux**.

## Source of Truth for AI Agents

**`bin/packages.yaml`** is the structured package manifest. It lists every package with `platform` tags (`[macos, linux]` or `[macos]`), install methods, and notes on Linux-specific alternatives. Read this file first when setting up a new machine.

## Setup Commands

### macOS

```bash
./bin/install-macos   # Install Homebrew packages, apps, fonts
./bin/link-macos      # Link all dotfiles + theme-toggle to ~/.local/bin
./bin/macos-defaults  # Apply macOS system defaults
```

### Linux

```bash
./bin/install-linux   # Install cross-platform packages via apt/dnf
./bin/link-linux      # Link cross-platform dotfiles only
```

Link scripts use `stow --target=$HOME --restow <package>` and also run `bin/ensure-gitignore` to merge patterns from `bin/gitignore.yaml` into `~/.config/git/ignore`.

## Dotfile Management

Each `<tool>/` directory at repo root mirrors `$HOME/` via GNU Stow.
Example: `nvim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`

| Dotfile | Platform | Notes |
|---------|----------|-------|
| `nvim` | macOS, Linux | LazyVim framework |
| `starship` | macOS, Linux | |
| `zsh` | macOS, Linux | Supports `~/.zshrc_local` for machine-local overrides |
| `ideavim` | macOS, Linux | |
| `tmux` | macOS, Linux | |
| `ghostty` | macOS | |
| `cursor` | macOS | |
| `zed` | macOS | |

## Theme System (macOS)

A unified dark/light toggle spans multiple configs. Themes: **Rose Pine Moon** (dark), **Rose Pine Dawn** (light).

- **macOS appearance** — source of truth for dark/light mode.
- **`theme-toggle`** — user-facing toggle (aliased `tt`). Changes macOS appearance, then runs `theme-sync`.
- **`theme-sync`** — reads macOS appearance and nudges running Neovim instances. Tmux, Lazygit, Cursor, Claude Code, and Ghostty each sync themselves (see below) and are not touched by this script.
- **Tmux** — status bar uses terminal-default colors, so it inherits Ghostty's light/dark palette with no theme coupling.
- **Lazygit** — uses default terminal-aware colors; do not update Lazygit config from theme scripts.
- **Cursor** — uses built-in auto sync; do not update Cursor settings from theme scripts.
- **Claude Code** — uses built-in auto sync; do not update `~/.claude.json` from theme scripts.
- **Ghostty** and **Neovim** — follow macOS appearance from their configs; `theme-sync` nudges running Neovim instances.

When modifying themes: preserve the flow `macOS appearance -> theme-sync -> app configs`. `appearance.lua` handles Neovim startup; Ghostty's `config` handles the terminal.

## Keybind Conventions

- **Avoid conflicts across layers.** When adding or updating keybinds in any config, check that they don't shadow keybinds in tools that run inside it (e.g., terminal keybinds must not conflict with Neovim keybinds, since Neovim runs inside the terminal).

## Neovim Configuration

Uses LazyVim framework with Lua config in `nvim/.config/nvim/`:
- `lua/config/` — Core settings (keymaps, options, autocmds)
- `lua/plugins/` — Plugin specs organized by concern: appearance, completion, copilot, editor, formatting, lsp, navigation
- Plugin lock file: `lazy-lock.json`

Key customizations on top of LazyVim defaults:
- Neotest with minitest (Rails) and Python adapters (`editor.lua`)
- Harpoon 2 for file bookmarks (`navigation.lua`)
- vim-rails for Rails-aware navigation (`navigation.lua`)
- Custom `<leader>tR`/`<leader>tL` for Rails test runner fallback (`keymaps.lua`)
- Custom snippets: `bp` → `binding.irb` (Ruby), `bp` → `breakpoint()` (Python)
