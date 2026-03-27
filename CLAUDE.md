# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal development environment setup containing dotfiles and installation scripts. Uses GNU Stow for symlink management. Supports **macOS** and **Linux**.

## Source of Truth for AI Agents

**`utils/packages.yaml`** is the structured package manifest. It lists every package with `platform` tags (`[macos, linux]` or `[macos]`), install methods, and notes on Linux-specific alternatives. Read this file first when setting up a new machine.

## Setup Commands

### macOS

```bash
./utils/install-macos   # Install Homebrew packages, apps, fonts
./utils/link-macos      # Link all dotfiles (all 8 packages) + theme-toggle to ~/.local/bin
./utils/macos-defaults  # Apply macOS system defaults
```

### Linux

```bash
./utils/install-linux   # Install cross-platform packages via apt/dnf
./utils/link-linux      # Link cross-platform dotfiles (nvim, starship, zsh, ideavim, lazygit)
```

Link scripts use `stow --target=$HOME --restow <package>` and also run `utils/ensure-gitignore` to merge patterns from `utils/gitignore.yaml` into `~/.config/git/ignore`.

## Dotfile Management

Each `<tool>/` directory at repo root mirrors `$HOME/` via GNU Stow.
Example: `nvim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`

| Dotfile | Platform | Notes |
|---------|----------|-------|
| `nvim` | macOS, Linux | Neovim with LazyVim framework |
| `starship` | macOS, Linux | Starship prompt config |
| `zsh` | macOS, Linux | Zsh + Oh My Zsh; supports `~/.zshrc_local` for machine-local overrides |
| `ideavim` | macOS, Linux | IdeaVim (JetBrains) config |
| `lazygit` | macOS, Linux | Lazygit Git UI config |
| `tmux` | macOS, Linux | Tmux terminal multiplexer config |
| `ghostty` | macOS | Ghostty terminal config |
| `cursor` | macOS | Cursor editor config |
| `zed` | macOS | Zed editor config |

## Theme System (macOS)

A unified dark/light theme toggle spans multiple configs. Understanding this requires reading several files together:

- **`utils/theme-toggle`** — orchestrator script (aliased as `tt` in zsh). Toggles macOS system appearance and updates Zed, Cursor, Lazygit, and Tmux configs via sed. Linked to `~/.local/bin/theme-toggle` by `link-macos`.
- **Ghostty** — uses native `theme = light:Alabaster,dark:Catppuccin Mocha` syntax; follows macOS appearance automatically.
- **Neovim** — `appearance.lua` reads `AppleInterfaceStyle` at startup to pick colorscheme (Alabaster light / Catppuccin Mocha dark). The `dark-notify` plugin auto-switches at runtime when macOS appearance changes.
- **Cursor** — Alabaster (light) / Catppuccin Mocha (dark), updated by `theme-toggle`.
- **Zed** — mode field toggled by `theme-toggle`.
- **Lazygit** — Catppuccin Latte (light) / Catppuccin Mocha (dark) color values, updated by `theme-toggle`.
- **Tmux** — Catppuccin Latte (light) / Catppuccin Mocha (dark) via catppuccin/tmux plugin, updated by `theme-toggle`. Auto-reloads config on toggle.

When modifying theme colors: update `theme-toggle` for Cursor/Zed/Lazygit/Tmux, `appearance.lua` for Neovim, and Ghostty's `config` for the terminal.

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
