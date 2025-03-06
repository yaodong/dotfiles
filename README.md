# macOS Setup

This repository contains my personal dotfiles configuration for macOS. These configuration files help set up and maintain a consistent development environment across different machines.

## Installation

The configuration includes:
- [ghostty](https://github.com/ghostty/ghostty): A terminal emulator.
- [neovim](https://neovim.io/) with [LazyVim](https://github.com/LazyVim/LazyVim): A modern, extensible Vim-based text editor.
- [starship](https://github.com/starship/starship): A shell prompt that shows information about your project.
- [tmux](https://github.com/tmux/tmux): A terminal multiplexer.
- [oh my zsh](https://ohmyz.sh/): A delightful, open source, community-driven framework for managing your Zsh configuration.
- [IdeaVim](https://github.com/JetBrains/ideavim): Vim emulation plugin for JetBrains IDEs.

## Prerequisites

Before installation, ensure you have macOS and an internet connection. The installation script will automatically install Homebrew if it's not already present on your system.

## Installation Steps

1. Clone this repository:

```bash
git clone --depth=1 https://github.com/yaodong/setup.git ~/.local/setup
```

You can clone the repository to any location of your choice, not just `~/.local/setup`. The scripts are designed to work from any location.

2. Run the installation script:

```bash
cd ~/.local/setup
bash bin/install.sh
```

This will:
- Install Homebrew if not already installed
- Update Homebrew
- Install all required packages directly through brew install commands

3. Create symbolic links:

```bash
cd ~/.local/setup
bash bin/link.sh
```

This will:
- Create necessary config directories
- Link all configuration files to their appropriate locations

The `link.sh` script automatically detects the repository location, so you can place this repository anywhere on your system, not just at `~/.local/setup`. It will correctly create symbolic links from the actual repository location to the appropriate configuration files in your home directory.

4. Optionally, run the setup script for additional configuration:

```bash
cd ~/.local/setup
bash bin/setup.sh
```

// ... existing code ...