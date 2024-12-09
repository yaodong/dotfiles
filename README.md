# macOS Dotfiles

> Personal dotfiles configuration for macOS
> Last updated: December 8, 2024

## Overview

This repository contains my personal dotfiles configuration for macOS. These configuration files help set up and maintain a consistent development environment across different machines.

## Installation

The configuration includes:
- [alacritty](https://github.com/alacritty/alacritty): A cross-platform, OpenGL terminal emulator.
- [JankyBorders](https://github.com/FelixKratz/JankyBorders): A lightweight window border system for macOS.
- [doom emacs](https://github.com/hlissner/doom-emacs): An Emacs framework for the stubborn martian hacker.
- [sketchybar](https://github.com/FelixKratz/SketchyBar): A highly customizable macOS status bar replacement.
- [yabai](https://github.com/koekeishiya/yabai): A tiling window manager for macOS.
- [skhd](https://github.com/koekeishiya/skhd): A hotkey daemon for macOS.
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
- Create an Emacs.app alias in the Applications folder (if not already present)

## Directory Structure

```
~/.local/dots/
├── alacritty/     # Alacritty terminal configuration
├── bin/           # Utility scripts
├── borders/       # JankyBorders window border configuration
├── doom/          # Doom Emacs configuration
├── sketchybar/    # Sketchybar configuration
├── skhd/          # Simple hotkey daemon configuration
├── starship/      # Starship prompt configuration
├── tmux/          # Tmux configuration
├── yabai/         # Yabai window manager configuration
└── zsh/           # Zsh shell configuration
```

## Post-Installation

After installation, you'll need to:

1. Restart your terminal to apply the new Zsh configuration
2. Start the required services:

```bash
~/.local/dots/bin/start
```

This will start:
- yabai (window manager)
- skhd (hotkey daemon)
- sketchybar (status bar)
- borders (window borders)

3. Grant Accessibility permissions to the newly installed services. You'll be asked to do so on macOS.

## Customization

Feel free to fork this repository and customize the configurations to your liking. Each tool's configuration is stored in its respective directory and can be modified independently.

## License

This project is open source and available under the MIT License.
