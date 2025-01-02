# macOS dotfiles

This repository contains my personal dotfiles configuration for macOS. These configuration files help set up and maintain a consistent development environment across different machines.

## Installation

The configuration includes:
- [ghostty](https://github.com/ghostty/ghostty): A terminal emulator.
- [neovim](https://neovim.io/) with [LazyVim](https://github.com/LazyVim/LazyVim): A modern, extensible Vim-based text editor.
- [startship](https://github.com/starship/starship): A shell prompt that shows information about your project.
- [tmux](https://github.com/tmux/tmux): A terminal multiplexer.
- [oh my zsh](https://ohmyz.sh/): A delightful, open source, community-driven framework for managing your Zsh configuration.

## Prerequisites

Before installation, ensure you have macOS and an internet connection. The installation script will automatically install Homebrew if it's not already present on your system.

## Installation Steps

1. Clone this repository:

```bash
git clone --depth=1 https://github.com/yaodong/dots.git ~/.local/dots
```

2. Run the installation script:

```bash
~/.local/dots/bin/install
```

This will:
- Install Homebrew if not already installed
- Update Homebrew
- Install all required packages from the Brewfile

3. Create symbolic links:

```bash
~/.local/dots/bin/link
```

This will:
- Create necessary config directories
- Link all configuration files to their appropriate locations

## Directory Structure

```
~/.local/dots/
├── bin/           # Utility scripts
├── ghostty/       # Ghostty terminal configuration
├── nvim/          # Neovim configuration
├── starship/      # Starship prompt configuration
├── tmux/          # Tmux configuration
└── zsh/           # Zsh shell configuration
```

## Customization

Feel free to fork this repository and customize the configurations to your liking. Each tool's configuration is stored in its respective directory and can be modified independently.

## License

This project is open source and available under the MIT License.
