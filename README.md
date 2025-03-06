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

2. Run the installation script:

```bash
cd ~/.local/setup
bash bin/install.sh
```

This will:
- Install Homebrew if not already installed
- Update Homebrew
- Install all required packages from the Brewfile

3. Create symbolic links:

```bash
cd ~/.local/setup
bash bin/link.sh
```

This will:
- Create necessary config directories
- Link all configuration files to their appropriate locations

4. Optionally, run the setup script for additional configuration:

```bash
cd ~/.local/setup
bash bin/setup.sh
```

## Directory Structure

```
~/.local/setup/
├── bin/           # Utility scripts
│   ├── install.sh # Installation script
│   ├── link.sh    # Symbolic link creation
│   └── setup.sh   # Additional setup
├── apps/          # Configuration files
│   ├── ghostty/   # Ghostty terminal configuration
│   ├── ideavim/   # IdeaVim configuration
│   ├── nvim/      # Neovim configuration
│   ├── starship/  # Starship prompt configuration
│   ├── tmux/      # Tmux configuration
│   └── zsh/       # Zsh shell configuration
└── extras/        # Development environment setup scripts
```

## Additional Development Environments

The repository includes extra scripts to set up specific development environments:

```bash
cd ~/.local/setup

# Setup Node.js environment
bash extras/node.sh

# Setup Python environment
bash extras/python.sh

# Setup Ruby environment
bash extras/ruby.sh

# Setup Terraform environment
bash extras/terraform.sh
```

## Customization

Feel free to fork this repository and customize the configurations to your liking. Each tool's configuration is stored in its respective directory under the `apps/` directory and can be modified independently.

## References

- [Tmux Config: A Guide](https://builtin.com/articles/tmux-config)
- [tao-of-tmux](https://tao-of-tmux.readthedocs.io/)
- [LazyVim](https://github.com/LazyVim/LazyVim/)
- [IdeaVim](https://github.com/JetBrains/ideavim)

## License

This project is open source and available under the MIT License.