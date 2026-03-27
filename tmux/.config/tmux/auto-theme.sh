#!/usr/bin/env bash
# Auto-detect macOS appearance and update Catppuccin flavor.
# Called by tmux hooks (client-focus-in, client-session-changed).

appearance=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")

if [ "$appearance" = "Dark" ]; then
  flavor="mocha"
  theme_comment="# Dark: Catppuccin Mocha"
  status_bg="#1e1e2e"
  claude_theme="dark"
else
  flavor="latte"
  theme_comment="# Light: Catppuccin Latte"
  status_bg="#f7f7f7"
  claude_theme="light"
fi

current=$(tmux show -gqv @catppuccin_flavor 2>/dev/null)
[ "$current" = "$flavor" ] && exit 0

# Update the flavor in tmux.conf so it persists when sourced
tmux_config="$HOME/.config/tmux/tmux.conf"
tmp=$(mktemp)
sed \
  -e "s/@catppuccin_flavor '[^']*'/@catppuccin_flavor '$flavor'/" \
  -e "s/@catppuccin_status_background \"#[a-f0-9]*\"/@catppuccin_status_background \"$status_bg\"/" \
  -e '/# Active theme/{n;s/.*/'"$theme_comment"'/;}' \
  "$tmux_config" > "$tmp"
cat "$tmp" > "$tmux_config"
rm "$tmp"

# Build a temp config that unsets all catppuccin/theme options
# and re-sources tmux.conf in a single atomic operation
tmp_conf=$(mktemp)
tmux show -g 2>/dev/null | grep -oE '^@(thm_|catppuccin_|_ctp_)\S+' | while read -r opt; do
  echo "set -gu $opt"
done > "$tmp_conf"
echo "source-file $tmux_config" >> "$tmp_conf"
tmux source-file "$tmp_conf"
rm "$tmp_conf"

# Update Claude Code theme
claude_config="$HOME/.claude.json"
if [ -f "$claude_config" ] && command -v jq >/dev/null 2>&1; then
  tmp=$(mktemp)
  jq --arg theme "$claude_theme" '.theme = $theme' "$claude_config" > "$tmp" && cat "$tmp" > "$claude_config"
  rm "$tmp"
fi
