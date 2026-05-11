# My Dev Setup

Personal development environment managed with [GNU Stow](https://www.gnu.org/software/stow/). Supports **macOS** and **Linux**.

## Setup

```bash
git clone --depth=1 https://github.com/yaodong/dotfiles.git ~/.local/dotfiles
cd ~/.local/dotfiles
```

### macOS

```bash
./bin/install-macos   # Install Homebrew packages, apps, fonts
./bin/link-macos      # Symlink all dotfiles + theme-toggle to ~/.local/bin
./bin/macos-defaults  # Apply macOS system preferences
```

### Linux

```bash
./bin/install-linux   # Install cross-platform packages via apt/dnf
./bin/link-linux      # Symlink cross-platform dotfiles only
```

If any script fails, see `bin/packages.yaml` for per-package install notes and platform alternatives.

## What's Included

### Dotfiles

Each `<tool>/` directory at repo root mirrors `$HOME/` via Stow. Example: `nvim/.config/nvim/init.lua` becomes `~/.config/nvim/init.lua`.

| Dotfile | Platform | Description |
|---------|----------|-------------|
| `nvim` | macOS, Linux | Neovim with [LazyVim](https://github.com/LazyVim/LazyVim) framework |
| `tmux` | macOS, Linux | Tmux; status bar uses terminal-default colors |
| `zsh` | macOS, Linux | Zsh + [Oh My Zsh](https://ohmyz.sh/); supports `~/.zshrc_local` for machine-local overrides |
| `starship` | macOS, Linux | [Starship](https://starship.rs/) prompt config |
| `ideavim` | macOS, Linux | [IdeaVim](https://github.com/JetBrains/ideavim) config for JetBrains IDEs |
| `ghostty` | macOS | [Ghostty](https://ghostty.org/) terminal config |
| `cursor` | macOS | [Cursor](https://cursor.sh/) editor config |
| `zed` | macOS | [Zed](https://zed.dev/) editor config |

### CLI Tools

Installed via Homebrew (macOS) or system package manager (Linux). Full manifest in `bin/packages.yaml`.

[ripgrep](https://github.com/BurntSushi/ripgrep) | [fd](https://github.com/sharkdp/fd) | [bat](https://github.com/sharkdp/bat) | [eza](https://github.com/eza-community/eza) | [fzf](https://github.com/junegunn/fzf) | [zoxide](https://github.com/ajeetdsouza/zoxide) | [btop](https://github.com/aristocratos/btop) | [fastfetch](https://github.com/fastfetch-cli/fastfetch) | [mise](https://github.com/jdx/mise) | [lazydocker](https://github.com/jesseduffield/lazydocker)

## Theme System (macOS)

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

## Cross-Platform Support

Most CLI tools and dotfiles work on both macOS and Linux. macOS-specific items (Ghostty, Cursor, Zed configs, cask apps, theme-toggle) are excluded from the Linux scripts. See `bin/packages.yaml` for the full package manifest with platform tags and Linux install notes.

## License

This project is open source and available under the MIT License.
