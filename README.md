# My macOS Setup

## Overview

The configuration includes:

### Core Development Tools
- **[Neovim](https://neovim.io/) with [LazyVim](https://github.com/LazyVim/LazyVim)**: A modern, extensible Vim-based text editor with a comprehensive plugin ecosystem
- **[Cursor](https://cursor.sh/)**: AI-powered code editor with custom keybindings and settings
- **[Ghostty](https://github.com/mitchellh/ghostty)**: Fast, cross-platform terminal emulator
- **[IdeaVim](https://github.com/JetBrains/ideavim)**: Vim emulation plugin for JetBrains IDEs

### Shell & Prompt
- **[Zsh](https://www.zsh.org/) with [Oh My Zsh](https://ohmyz.sh/)**: Enhanced shell with community-driven framework
- **[Starship](https://github.com/starship/starship)**: Fast, customizable shell prompt that shows project information
- **[Zoxide](https://github.com/ajeetdsouza/zoxide)**: Smart directory navigation
- **[FZF](https://github.com/junegunn/fzf)**: Fuzzy finder for command line

### Development Utilities
- **[Lazygit](https://github.com/jesseduffield/lazygit)**: Simple terminal UI for git commands
- **[Lazydocker](https://github.com/jesseduffield/lazydocker)**: Simple terminal UI for docker
- **[Mise](https://github.com/jdx/mise)**: Polyglot runtime manager
- **[Ripgrep](https://github.com/BurntSushi/ripgrep)**: Fast line-oriented search tool
- **[FD](https://github.com/sharkdp/fd)**: Fast, user-friendly alternative to find
- **[Bat](https://github.com/sharkdp/bat)**: Cat clone with syntax highlighting
- **[Eza](https://github.com/eza-community/eza)**: Modern replacement for ls

### Quick Setup

Clone this repository:

```bash
git clone --depth=1 https://github.com/yaodong/setup.git ~/.local/setup
cd ~/.local/setup
```

Run the setup scripts:

```bash
./scripts/install.sh        # Install Homebrew packages, apps, fonts
./scripts/link-dotfiles.sh  # Link dotfiles to home directory
./scripts/macos-defaults.sh # Apply macOS system defaults
```

## Keybindings

### IdeaVim (JetBrains IDEs)
**Leader Key:** `Space`

**File Navigation:**
- `<leader>ff` - Go to file
- `<leader>fr` - Recent files
- `<leader>fc` - Find in path
- `<leader>fl` - Recent locations
- `<leader><leader>` - Recent files

**Window Management:**
- `<leader>wv` - Split vertically
- `<leader>ws` - Split horizontally
- `<leader>wu` - Unsplit
- `<leader>wm` - Move editor to opposite tab group
- `<leader>wh/wj/wk/wl` - Navigate between windows

**Code Navigation:**
- `<leader>gd` - Go to declaration
- `<leader>gy` - Go to type declaration
- `<leader>gi` - Go to implementation
- `<leader>gu` - Show usages
- `<leader>gt` - Go to test
- `<leader>gf/gb` - Go forward/back

**Refactoring:**
- `<leader>rn` - Rename element
- `<leader>rm` - Extract method
- `<leader>rv` - Introduce variable
- `<leader>rf` - Introduce field
- `<leader>rs` - Change signature
- `<leader>rr` - Open refactorings list

**Git Operations:**
- `<leader>gc` - Git commit
- `<leader>gs` - Git status
- `<leader>gb` - Git branches

**Display Options:**
- `<leader>dd` - Toggle distraction-free mode
- `<leader>dz` - Toggle zen mode
- `<leader>df` - Toggle full screen

### Cursor Editor
- `Ctrl + W` - Close active editor
- `Ctrl + I` - Toggle AI agent mode

### Neovim (LazyVim)
**Rails Testing (Custom):**
- `<leader>tR` - Run Rails test for current file
- `<leader>tL` - Run Rails test at current line

**Note:** LazyVim provides extensive default keybindings. See [LazyVim documentation](https://github.com/LazyVim/LazyVim) for complete reference.

## References

- [LazyVim Documentation](https://github.com/LazyVim/LazyVim)
- [Ghostty Documentation](https://github.com/mitchellh/ghostty)
- [macOS Defaults](https://macos-defaults.com/)

## License

This project is open source and available under the MIT License.
