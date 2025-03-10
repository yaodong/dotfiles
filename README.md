# Personal macOS Development Environment Setup

This repository contains my personal dotfiles configuration for macOS. These configuration files help set up and maintain a consistent development environment across different machines, providing a modern, efficient, and developer-friendly setup.

## Overview

The configuration includes:
- [ghostty](https://github.com/ghostty/ghostty): A terminal emulator.
- [neovim](https://neovim.io/) with [LazyVim](https://github.com/LazyVim/LazyVim): A modern, extensible Vim-based text editor.
- [starship](https://github.com/starship/starship): A shell prompt that shows information about your project.
- [tmux](https://github.com/tmux/tmux): A terminal multiplexer.
- [oh my zsh](https://ohmyz.sh/): A delightful, open source, community-driven framework for managing your Zsh configuration.
- [IdeaVim](https://github.com/JetBrains/ideavim): Vim emulation plugin for JetBrains IDEs.

## Prerequisites

Before installation, ensure you have:
- macOS 12.0 (Monterey) or later
- Git installed (comes pre-installed on recent macOS versions)
- An active internet connection
- Administrator privileges (for installing packages)
- Bash shell

The installation script will automatically install Homebrew if it's not already present on your system.

## Installation

Clone this repository:

```bash
git clone --depth=1 https://github.com/yaodong/setup.git ~/.local/setup
```

You can clone the repository to any location of your choice, not just `~/.local/setup`. The scripts are designed to work from any location.

To run the complete setup process, simply execute:

```bash
bash setup.sh
```

This will run all necessary installation and linking steps automatically.

### Manual Setup

If you prefer to run individual steps manually, you can execute them separately:

1. Run the installation script:
```bash
./bin/install
```

2. Run the linking script:
```bash
./bin/link
```

## Additional Development Environments

The repository includes extra scripts to set up specific development environments in the `extras` directory:

- `node.sh`: Node.js development environment
- `python.sh`: Python development environment
- `ruby.sh`: Ruby development environment
- `terraform.sh`: Terraform development environment
- `java.sh`: Java development environment

These scripts are optional and can be run at any time after the initial setup. Each script is independent and can be run separately based on your needs.

## References

- [Tmux Config: A Guide](https://builtin.com/articles/tmux-config)
- [tao-of-tmux](https://tao-of-tmux.readthedocs.io/)
- [LazyVim](https://github.com/LazyVim/LazyVim/)
- [IdeaVim](https://github.com/JetBrains/ideavim)
- [macOS Defaults](https://macos-defaults.com/)

## License

This project is open source and available under the MIT License.
