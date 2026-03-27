#!/usr/bin/env bash
# Auto-detect macOS appearance and update Catppuccin flavor.
# Called by tmux hooks (client-focus-in, client-session-changed).

appearance=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")

if [ "$appearance" = "Dark" ]; then
  flavor="mocha"
  bg="#1e1e2e"
else
  flavor="latte"
  bg="#eff1f5"
fi

current=$(tmux show -gqv @catppuccin_flavor 2>/dev/null)
[ "$current" = "$flavor" ] && exit 0

tmux set -g @catppuccin_flavor "$flavor"
tmux set -g @catppuccin_status_background "$bg"
tmux source-file ~/.config/tmux/tmux.conf
