#!/usr/bin/env bash

set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
script="$repo_root/tmux/.config/tmux/apply-tmux-theme.sh"
workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

fake_bin="$workdir/bin"
mkdir -p "$fake_bin"

cat > "$fake_bin/tmux" <<'FAKE_TMUX'
#!/usr/bin/env bash
set -euo pipefail

case "$*" in
  "show -g")
    cat <<'OPTIONS'
@catppuccin_flavor mocha
@thm_bg #old
@_ctp_status_module old
@unrelated keep
OPTIONS
    ;;
  source-file*)
    cp "$2" "$CAPTURED_TMUX_CONF"
    ;;
  *)
    printf 'unexpected tmux command: %s\n' "$*" >&2
    exit 1
    ;;
esac
FAKE_TMUX
chmod +x "$fake_bin/tmux"

assert_contains() {
  local needle="$1"
  local file="$2"
  if ! grep -Fq "$needle" "$file"; then
    printf 'expected to find %s in %s\n' "$needle" "$file" >&2
    printf '%s\n' '--- file contents ---' >&2
    sed -n '1,200p' "$file" >&2
    exit 1
  fi
}

assert_not_contains() {
  local needle="$1"
  local file="$2"
  if grep -Fq "$needle" "$file"; then
    printf 'did not expect to find %s in %s\n' "$needle" "$file" >&2
    printf '%s\n' '--- file contents ---' >&2
    sed -n '1,200p' "$file" >&2
    exit 1
  fi
}

export PATH="$fake_bin:$PATH"
export CAPTURED_TMUX_CONF="$workdir/captured.conf"

bash "$script" dark

assert_contains "set -gu @catppuccin_flavor" "$CAPTURED_TMUX_CONF"
assert_contains "set -gu @thm_bg" "$CAPTURED_TMUX_CONF"
assert_contains "set -gu @_ctp_status_module" "$CAPTURED_TMUX_CONF"
assert_not_contains "set -gu @unrelated" "$CAPTURED_TMUX_CONF"
assert_contains "set -g @catppuccin_flavor 'mocha'" "$CAPTURED_TMUX_CONF"
assert_contains 'set -g @catppuccin_status_background "none"' "$CAPTURED_TMUX_CONF"
assert_contains 'set -g @catppuccin_window_status_style "basic"' "$CAPTURED_TMUX_CONF"
assert_contains 'set -g @catppuccin_window_current_left_separator " "' "$CAPTURED_TMUX_CONF"
assert_contains 'set -g @catppuccin_window_current_middle_separator " "' "$CAPTURED_TMUX_CONF"
assert_contains 'set -g @catppuccin_window_current_right_separator " "' "$CAPTURED_TMUX_CONF"
assert_not_contains 'set -g status-right' "$CAPTURED_TMUX_CONF"
assert_not_contains 'set -g pane-border-status off' "$CAPTURED_TMUX_CONF"
assert_contains 'set -g @catppuccin_window_text " #W"' "$CAPTURED_TMUX_CONF"
assert_contains 'set -g @catppuccin_window_current_text " #W"' "$CAPTURED_TMUX_CONF"
assert_contains 'set -g @catppuccin_date_time_text " %m/%d %H:%M"' "$CAPTURED_TMUX_CONF"
assert_contains "run-shell '~/.config/tmux/plugins/tmux/catppuccin.tmux'" "$CAPTURED_TMUX_CONF"
assert_contains 'set -gF @_status_battery "#{E:@catppuccin_status_battery}"' "$CAPTURED_TMUX_CONF"
assert_contains "run-shell '~/.config/tmux/plugins/tmux-battery/battery.tmux'" "$CAPTURED_TMUX_CONF"

bash "$script" light

assert_contains "set -g @catppuccin_flavor 'latte'" "$CAPTURED_TMUX_CONF"
assert_contains 'set -g @catppuccin_status_background "none"' "$CAPTURED_TMUX_CONF"

printf 'tmux apply theme tests passed\n'
