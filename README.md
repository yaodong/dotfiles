# My Dev Setup

Personal macOS development environment managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

```bash
git clone --depth=1 https://github.com/yaodong/dotfiles.git ~/.local/dotfiles
cd ~/.local/dotfiles
```

```bash
./bin/install         # Install Homebrew packages, apps, fonts
./bin/link            # Symlink dotfiles into $HOME
./bin/macos-defaults  # Apply macOS system preferences
```

Homebrew packages are declared in `Brewfile`.

## What's Included

### Dotfiles

Each `<tool>/` directory at repo root mirrors `$HOME/` via Stow. Example: `nvim/.config/nvim/init.lua` becomes `~/.config/nvim/init.lua`.

| Dotfile | Description |
|---------|-------------|
| `nvim` | Neovim with [LazyVim](https://github.com/LazyVim/LazyVim) framework |
| `tmux` | Tmux; status bar uses terminal-default colors |
| `zsh` | Zsh + [Oh My Zsh](https://ohmyz.sh/); supports `~/.zshrc_local` for machine-local overrides |
| `starship` | [Starship](https://starship.rs/) prompt config |
| `ideavim` | [IdeaVim](https://github.com/JetBrains/ideavim) config for JetBrains IDEs |
| `ghostty` | [Ghostty](https://ghostty.org/) terminal config |
| `cursor` | [Cursor](https://cursor.sh/) editor config |
| `zed` | [Zed](https://zed.dev/) editor config; privacy-locked (AI, telemetry, auto-update, sign-in all disabled) |

### CLI Tools

Installed via Homebrew. Full manifest in `Brewfile`.

[ripgrep](https://github.com/BurntSushi/ripgrep) | [fd](https://github.com/sharkdp/fd) | [bat](https://github.com/sharkdp/bat) | [eza](https://github.com/eza-community/eza) | [fzf](https://github.com/junegunn/fzf) | [zoxide](https://github.com/ajeetdsouza/zoxide) | [btop](https://github.com/aristocratos/btop) | [fastfetch](https://github.com/fastfetch-cli/fastfetch) | [mise](https://github.com/jdx/mise) | [lazydocker](https://github.com/jesseduffield/lazydocker)

## Theme System

macOS appearance is the source of truth for dark/light mode. The `theme-toggle` command, aliased as `tt`, only changes macOS appearance and then runs `theme-sync` to update tools that do not follow macOS automatically.

| Tool | Dark | Light | Mechanism |
|------|------|-------|-----------|
| macOS | System dark mode | System light mode | Changed by `theme-toggle` |
| Ghostty | Rose Pine Moon | Rose Pine Dawn | Follows macOS automatically |
| Neovim | Rose Pine Moon | Rose Pine Dawn | Reads macOS at startup; running instances nudged by `theme-sync` |
| Tmux | terminal/default colors | terminal/default colors | Inherits Ghostty palette via ANSI colors |
| Cursor | Catppuccin Mocha | Catppuccin Latte | Uses built-in auto sync |
| Lazygit | terminal/default colors | terminal/default colors | Uses Lazygit defaults |
| Claude Code | dark | light | Uses built-in auto sync |

## License

This project is open source and available under the MIT License.
