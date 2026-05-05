#!/usr/bin/env bash

set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
script="$repo_root/cli/.local/bin/theme-sync"
workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

fake_bin="$workdir/bin"
home="$workdir/home"
mkdir -p "$fake_bin" "$home/.config/zed" "$home/.config/cursor" "$home/.config/tmux"

cat >"$fake_bin/defaults" <<'FAKE_DEFAULTS'
#!/usr/bin/env bash
set -euo pipefail

if [ "$*" != "read -g AppleInterfaceStyle" ]; then
  printf 'unexpected defaults command: %s\n' "$*" >&2
  exit 1
fi

if [ "${FAKE_APPEARANCE:-Light}" = "Dark" ]; then
  printf 'Dark\n'
else
  exit 1
fi
FAKE_DEFAULTS
chmod +x "$fake_bin/defaults"

cat >"$fake_bin/jq" <<'FAKE_JQ'
#!/usr/bin/env bash
set -euo pipefail

printf 'called\n' >"$HOME/jq-called"
FAKE_JQ
chmod +x "$fake_bin/jq"

cat >"$home/.config/tmux/apply-tmux-theme.sh" <<'FAKE_TMUX_THEME'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$1" > "$HOME/tmux-theme-target"
FAKE_TMUX_THEME
chmod +x "$home/.config/tmux/apply-tmux-theme.sh"

write_configs() {
  cat >"$home/.config/zed/settings.json" <<'ZED'
{"theme": {"mode": "light"}}
ZED

  cat >"$home/.config/cursor/settings.json" <<'CURSOR'
{"workbench.colorTheme": "Alabaster", "workbench.iconTheme": "catppuccin-latte"}
CURSOR

  printf '{"theme":"light"}\n' >"$home/.claude.json"
}

assert_contains() {
  local needle="$1"
  local file="$2"
  if ! grep -Fq -- "$needle" "$file"; then
    printf 'expected to find %s in %s\n' "$needle" "$file" >&2
    printf '%s\n' '--- file contents ---' >&2
    sed -n '1,200p' "$file" >&2
    exit 1
  fi
}

assert_missing() {
  local file="$1"
  if [ -e "$file" ]; then
    printf 'did not expect %s to exist\n' "$file" >&2
    exit 1
  fi
}

export HOME="$home"
export PATH="$fake_bin:$PATH"
export TMPDIR="$workdir/tmp/"
mkdir -p "$TMPDIR"

if [ ! -x "$script" ]; then
  printf 'expected theme-sync to be executable at %s\n' "$script" >&2
  exit 1
fi

write_configs
FAKE_APPEARANCE=Dark bash "$script"

assert_contains '"mode": "light"' "$home/.config/zed/settings.json"
assert_contains '"workbench.colorTheme": "Alabaster"' "$home/.config/cursor/settings.json"
assert_contains '"workbench.iconTheme": "catppuccin-latte"' "$home/.config/cursor/settings.json"
assert_contains '"theme":"light"' "$home/.claude.json"
assert_missing "$home/jq-called"
assert_contains 'dark' "$home/tmux-theme-target"

write_configs
FAKE_APPEARANCE=Light bash "$script"

assert_contains '"mode": "light"' "$home/.config/zed/settings.json"
assert_contains '"workbench.colorTheme": "Alabaster"' "$home/.config/cursor/settings.json"
assert_contains '"workbench.iconTheme": "catppuccin-latte"' "$home/.config/cursor/settings.json"
assert_contains '"theme":"light"' "$home/.claude.json"
assert_missing "$home/jq-called"
assert_contains 'light' "$home/tmux-theme-target"

write_configs
FAKE_APPEARANCE=Dark bash "$script"

assert_contains '"mode": "light"' "$home/.config/zed/settings.json"
assert_contains '"workbench.colorTheme": "Alabaster"' "$home/.config/cursor/settings.json"
assert_contains '"workbench.iconTheme": "catppuccin-latte"' "$home/.config/cursor/settings.json"
assert_contains '"theme":"light"' "$home/.claude.json"
assert_missing "$home/jq-called"
assert_contains 'dark' "$home/tmux-theme-target"

printf 'theme sync tests passed\n'
