#!/usr/bin/env bash

set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
script="$repo_root/cli/.local/bin/theme-toggle"
workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

fake_bin="$workdir/bin"
home="$workdir/home"
mkdir -p "$fake_bin" "$home"

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

cat >"$fake_bin/osascript" <<'FAKE_OSASCRIPT'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" > "$HOME/osascript-command"
FAKE_OSASCRIPT
chmod +x "$fake_bin/osascript"

cat >"$fake_bin/theme-sync" <<'FAKE_THEME_SYNC'
#!/usr/bin/env bash
set -euo pipefail
printf 'called\n' > "$HOME/theme-sync-called"
FAKE_THEME_SYNC
chmod +x "$fake_bin/theme-sync"

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

export HOME="$home"
export PATH="$fake_bin:$PATH"

FAKE_APPEARANCE=Dark bash "$script" >/dev/null
assert_contains 'dark mode to false' "$home/osascript-command"
assert_contains 'called' "$home/theme-sync-called"

rm -f "$home/osascript-command" "$home/theme-sync-called"

FAKE_APPEARANCE=Light bash "$script" dark >/dev/null
assert_contains 'dark mode to true' "$home/osascript-command"
assert_contains 'called' "$home/theme-sync-called"

if bash "$script" blue >/dev/null 2>"$home/invalid-arg"; then
  printf 'expected invalid target to fail\n' >&2
  exit 1
fi
assert_contains 'Usage: theme-toggle [dark|light]' "$home/invalid-arg"

if bash "$script" dark light >/dev/null 2>"$home/too-many-args"; then
  printf 'expected extra target to fail\n' >&2
  exit 1
fi
assert_contains 'Usage: theme-toggle [dark|light]' "$home/too-many-args"

printf 'theme toggle tests passed\n'
