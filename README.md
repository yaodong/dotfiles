# Personal macOS Development Environment Setup

This repository contains my personal dotfiles configuration for macOS. These configuration files help set up and maintain a consistent development environment across different machines, providing a modern, efficient, and developer-friendly setup.

## Overview

This setup provides a comprehensive development environment with:
- Modern terminal experience with Ghostty and Tmux
- Powerful text editing with Neovim and LazyVim
- Informative shell prompt with Starship
- Enhanced shell experience with Oh My Zsh
- Vim emulation for JetBrains IDEs
- Support for multiple programming languages and development tools

## Installation

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

The installation script will automatically install Homebrew if it's not already present on your system.

## Installation Steps

1. Clone this repository:

```bash
git clone --depth=1 https://github.com/yaodong/setup.git ~/.local/setup
```

You can clone the repository to any location of your choice, not just `~/.local/setup`. The scripts are designed to work from any location.

2. Run the installation script to set up core dependencies:

```bash
cd ~/.local/setup
bash bin/install.sh
```

This will:
- Install Homebrew if not already installed
- Update Homebrew to the latest version
- Install all required packages directly through brew install commands
- Set up basic system configurations

3. Create symbolic links to set up your configuration files:

```bash
cd ~/.local/setup
bash bin/link.sh
```

This will:
- Create necessary config directories
- Link all configuration files to their appropriate locations
- Set up your shell environment

The `link.sh` script automatically detects the repository location, so you can place this repository anywhere on your system, not just at `~/.local/setup`. It will correctly create symbolic links from the actual repository location to the appropriate configuration files in your home directory.

4. Run the setup script for additional system configurations:

```bash
cd ~/.local/setup
bash bin/setup.sh
```

This script performs additional system configurations and optimizations.

## Additional Development Environments

The repository includes extra scripts to set up specific development environments. These scripts install and configure the necessary tools and dependencies for each environment:

```bash
cd ~/.local/setup

# Setup Node.js environment (includes npm, yarn, and common global packages)
bash extras/node.sh

# Setup Python environment (includes pip, virtualenv, and common packages)
bash extras/python.sh

# Setup Ruby environment (includes rbenv, bundler, and common gems)
bash extras/ruby.sh

# Setup Terraform environment (includes terraform, tflint, and other terraform tools)
bash extras/terraform.sh

# Setup Java environment (includes JDK 21 and common Java development tools)
bash extras/java.sh
```

These scripts are optional and can be run at any time after the initial setup. Each script is independent and can be run separately based on your needs.

## References

- [Tmux Config: A Guide](https://builtin.com/articles/tmux-config)
- [tao-of-tmux](https://tao-of-tmux.readthedocs.io/)
- [LazyVim](https://github.com/LazyVim/LazyVim/)
- [IdeaVim](https://github.com/JetBrains/ideavim)

## License

This project is open source and available under the MIT License.
