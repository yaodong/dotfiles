# My macOS Setup

## Overview

The configuration includes:

### Core Development Tools
- **[Neovim](https://neovim.io/) with [LazyVim](https://github.com/LazyVim/LazyVim)**: A modern, extensible Vim-based text editor with a comprehensive plugin ecosystem
- **[Cursor](https://cursor.sh/)**: AI-powered code editor with custom keybindings and settings
- **[Ghostty](https://github.com/mitchellh/ghostty)**: Fast, cross-platform terminal emulator
- **[Tmux](https://github.com/tmux/tmux)**: Terminal multiplexer for managing multiple terminal sessions
- **[IdeaVim](https://github.com/JetBrains/ideavim)**: Vim emulation plugin for JetBrains IDEs

### Shell & Prompt
- **[Zsh](https://www.zsh.org/) with [Oh My Zsh](https://ohmyz.sh/)**: Enhanced shell with community-driven framework
- **[Starship](https://github.com/starship/starship)**: Fast, customizable shell prompt that shows project information
- **[Zoxide](https://github.com/ajeetdsouza/zoxide)**: Smart directory navigation
- **[FZF](https://github.com/junegunn/fzf)**: Fuzzy finder for command line

### System & Window Management
- **[Aerospace](https://github.com/nikitabobko/aerospace)**: Tiling window manager for macOS
- **[Sketchybar](https://github.com/FelixKratz/SketchyBar)**: Highly customizable status bar replacement
- **[Hammerspoon](https://www.hammerspoon.org/)**: Powerful automation tool for macOS
- **[Borders](https://github.com/0x766F6964/borders)**: Window border management

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

Run the complete setup process:

```bash
./bin/mac-install
./bin/mac-config
```

## Keybindings

### Aerospace (Window Management)
**Application Launching:**
- `Alt + Enter` - Open Ghostty terminal
- `Alt + W` - Close active window
- `Alt + B` - Open Google Chrome

**Window Navigation:**
- `Alt + Arrow Keys` - Focus windows (left, down, up, right)
- `Alt + Shift + Arrow Keys` - Move windows between workspaces
- `Alt + Tab` - Switch between last two workspaces
- `Alt + Shift + Tab` - Move workspace to next monitor

**Layout Management:**
- `Alt + /` - Cycle through horizontal/vertical tiling layouts
- `Alt + ,` - Cycle through horizontal/vertical accordion layouts
- `Alt + -` - Decrease window size
- `Alt + =` - Increase window size

**Workspace Management:**
- `Alt + 1-3` - Switch to general workspaces
- `Alt + C` - Switch to Cursor workspace
- `Alt + E` - Switch to IDE workspace (JetBrains IDEs)
- `Alt + N` - Switch to notes workspace (Notion, Tana)
- `Alt + S` - Switch to Slack workspace
- `Alt + M` - Switch to Google Meet workspace
- `Alt + X` - Switch to external monitor workspace
- `Alt + Shift + [1-3, C, E, S, M, N, X]` - Move window to specific workspace

**Service Mode (`Alt + Shift + ;`):**
- `Esc` - Exit service mode
- `R` - Reset layout (flatten workspace tree)
- `F` - Toggle floating/tiling layout
- `Backspace` - Close all windows except current
- `Arrow Keys` - Volume control (up/down)
- `Shift + Down` - Mute volume

### Tmux (Terminal Multiplexer)
**Prefix:** `Ctrl + J` (instead of default `Ctrl + B`)

**Window Management:**
- `Prefix + |` - Split window horizontally
- `Prefix + -` - Split window vertically
- `Prefix + C` - Create new window
- `Prefix + Space` - Switch to last window
- `Prefix + R` - Reload tmux config

**Pane Navigation:**
- `Alt + Arrow Keys` - Navigate between panes (no prefix needed)
- `Prefix + Arrow Keys` - Navigate between panes

**Mouse Support:** Enabled for clicking, resizing, and scrolling

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

- [Aerospace Documentation](https://github.com/nikitabobko/aerospace)
- [SketchyBar Documentation](https://github.com/FelixKratz/SketchyBar)
- [LazyVim Documentation](https://github.com/LazyVim/LazyVim)
- [Ghostty Documentation](https://github.com/mitchellh/ghostty)
- [macOS Defaults](https://macos-defaults.com/)

## License

This project is open source and available under the MIT License.
