#!/usr/bin/env bash

set -euo pipefail

case "${1:-}" in
dark)
  flavor="mocha"
  ;;
light)
  flavor="latte"
  ;;
*)
  echo "Usage: $0 dark|light" >&2
  exit 2
  ;;
esac

tmp_conf=$(mktemp)
trap 'rm -f "$tmp_conf"' EXIT

tmux show -g 2>/dev/null | awk '/^@(thm_|catppuccin_|_ctp_)/ { print "set -gu " $1 }' >"$tmp_conf"

{
  printf "set -g @catppuccin_flavor '%s'\n" "$flavor"
  printf "%s\n" 'set -g @catppuccin_status_background "none"'
  printf "%s\n" 'set -g @catppuccin_window_status_style "basic"'
  printf "%s\n" 'set -g @catppuccin_window_current_left_separator " "'
  printf "%s\n" 'set -g @catppuccin_window_current_middle_separator " "'
  printf "%s\n" 'set -g @catppuccin_window_current_right_separator " "'
  printf "%s\n" 'set -g @catppuccin_window_text " #W"'
  printf "%s\n" 'set -g @catppuccin_window_current_text " #W"'
  printf "%s\n" 'set -g @catppuccin_date_time_text " %m/%d %H:%M"'
  printf "%s\n" "run-shell '~/.config/tmux/plugins/tmux/catppuccin.tmux'"
  printf "%s\n" 'set -gF @_status_battery "#{E:@catppuccin_status_battery}"'
  printf "%s\n" "run-shell '~/.config/tmux/plugins/tmux-battery/battery.tmux'"
} >>"$tmp_conf"

tmux source-file "$tmp_conf"
