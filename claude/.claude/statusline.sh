#!/usr/bin/env bash
set -euo pipefail

# Colors
readonly CYAN='\033[36m' GREEN='\033[32m' YELLOW='\033[33m' RED='\033[31m'
readonly MAGENTA='\033[35m' BLUE='\033[34m' GRAY='\033[90m' NC='\033[0m'

# Progress bar
readonly BAR_WIDTH=10 BAR_FILLED="█" BAR_EMPTY="░"

# Cache
readonly CACHE_DIR="/tmp/claude-statusline-cache"
readonly CACHE_MAX_AGE=5

# ── JSON parsing (no jq dependency) ──────────────────────────
parse_input() {
  echo "$1" | awk '
    { doc = (NR == 1) ? $0 : doc "\n" $0 }
    END {
      mb = obj(doc, "model")
      print (str(mb,"display_name") != "" ? str(mb,"display_name") : "Claude")
      wb = obj(doc, "workspace")
      d = str(wb,"current_dir"); if (d == "") d = str(doc,"cwd")
      print (d != "" ? d : ".")
      print num(obj(doc,"context_window"), "used_percentage") + 0
    }
    function obj(s,k,  p,i,d,r,ch,q,e) {
      p="\"" k "\"[[:space:]]*:[[:space:]]*{"
      if (!match(s,p)) return ""
      i=RSTART+RLENGTH-1; d=0; q=0; e=0; r=""
      for (; i<=length(s); i++) {
        ch=substr(s,i,1)
        if (e) { e=0; r=r ch; continue }
        if (ch=="\\" && q) { e=1; r=r ch; continue }
        if (ch=="\"") { q=!q; r=r ch; continue }
        if (!q) { if (ch=="{") d++; else if (ch=="}") { if (--d==0) return r } }
        r=r ch
      }
      return r
    }
    function str(s,k,  p,i,ch,v,e) {
      p="\"" k "\"[[:space:]]*:[[:space:]]*\""
      if (!match(s,p)) return ""
      s=substr(s,RSTART+RLENGTH); v=""; e=0
      for (i=1; i<=length(s); i++) {
        ch=substr(s,i,1)
        if (e) { v=v ch; e=0 }
        else if (ch=="\\") e=1
        else if (ch=="\"") return v
        else v=v ch
      }
      return v
    }
    function num(s,k,  p,r) {
      if (s=="") return ""
      p="\"" k "\"[[:space:]]*:[[:space:]]*"
      if (!match(s,p)) return ""
      r=substr(s,RSTART+RLENGTH)
      match(r,/^-?[0-9][0-9.eE+\-]*/); if (RLENGTH<=0) return ""
      return substr(r,RSTART,RLENGTH)
    }
  ' 2>/dev/null
}

# ── Git info (single call, cached) ───────────────────────────
get_git_info() {
  local dir="$1"

  # Per-directory cache file
  mkdir -p "$CACHE_DIR"
  local dir_hash
  dir_hash=$(echo -n "$dir" | md5 2>/dev/null || echo -n "$dir" | md5sum 2>/dev/null | cut -d' ' -f1)
  local cache_file="${CACHE_DIR}/${dir_hash}"

  # Check cache freshness
  if [[ -f "$cache_file" ]]; then
    local now age mtime
    now=$(date +%s)
    mtime=$(stat -f %m "$cache_file" 2>/dev/null || stat -c %Y "$cache_file" 2>/dev/null || echo 0)
    age=$((now - mtime))
    if [[ $age -le $CACHE_MAX_AGE ]]; then
      cat "$cache_file"
      return
    fi
  fi

  # Not a repo
  if ! git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "|||0|0" > "$cache_file"
    cat "$cache_file"
    return
  fi

  # Single git status call (porcelain v2)
  local output branch="" ahead="0" behind="0" changes=0
  output=$(git -C "$dir" status --porcelain=v2 --branch --untracked-files=all 2>/dev/null) || {
    echo "|||0|0" > "$cache_file"
    cat "$cache_file"
    return
  }

  while IFS= read -r line; do
    case "$line" in
      "# branch.head "*) branch="${line#\# branch.head }" ;;
      "# branch.ab "*)
        local ab="${line#\# branch.ab }"
        ahead="${ab%% *}"; ahead="${ahead#+}"
        behind="${ab##* }"; behind="${behind#-}"
        ;;
      "#"*) ;;
      *) [[ -n "$line" ]] && ((changes++)) ;;
    esac
  done <<< "$output"

  echo "${branch}|${changes}|${ahead}|${behind}" > "$cache_file"
  cat "$cache_file"
}

# ── Progress bar ─────────────────────────────────────────────
build_bar() {
  local pct=$1 filled=$((pct * BAR_WIDTH / 100)) empty color
  empty=$((BAR_WIDTH - filled))

  if   [[ $pct -ge 80 ]]; then color=$RED
  elif [[ $pct -ge 60 ]]; then color=$YELLOW
  elif [[ $pct -ge 40 ]]; then color=$CYAN
  else color=$GREEN; fi

  local bar=""
  for ((i=0; i<filled; i++)); do bar+="$BAR_FILLED"; done
  local pad=""
  for ((i=0; i<empty; i++)); do pad+="$BAR_EMPTY"; done

  echo -n "${color}${bar}${NC}${GRAY}${pad}${NC}"
}

# ── Main ─────────────────────────────────────────────────────
main() {
  local input
  input=$(cat)

  # Parse JSON
  local model dir pct
  {
    read -r model
    read -r dir
    read -r pct
  } <<< "$(parse_input "$input")"

  pct=${pct%.*}  # truncate decimal
  [[ $pct -lt 0 ]] && pct=0
  [[ $pct -gt 100 ]] && pct=100

  local sep=" ${GRAY}|${NC} "

  # Nerd Font icons (standard choices from starship/powerlevel10k/lualine)
  local icon_dir icon_branch icon_model icon_gauge
  icon_dir=$'\xef\x81\xbb'         # nf-fa-folder          U+F07B
  icon_branch=$'\xee\x82\xa0'      # nf-pl-branch          U+E0A0
  icon_model=$'\xf3\xb0\xad\x89'   # nf-md-robot           U+F0B49
  icon_gauge=$'\xf3\xb0\xa1\x94'   # nf-md-gauge           U+F0854

  # Directory
  local output="${icon_dir} ${BLUE}${dir##*/}${NC}"

  # Git
  local git_data branch changes ahead behind
  git_data=$(get_git_info "$dir")
  IFS='|' read -r branch changes ahead behind <<< "$git_data"

  if [[ -n "$branch" ]]; then
    output+="${sep}${icon_branch} ${MAGENTA}${branch}${NC}"
    [[ "${ahead:-0}" -gt 0 ]] && output+=" ${GREEN}↑${ahead}${NC}"
    [[ "${behind:-0}" -gt 0 ]] && output+=" ${RED}↓${behind}${NC}"
    [[ "${changes:-0}" -gt 0 ]] && output+=" ${YELLOW}~${changes}${NC}"
  fi

  # Model
  output+="${sep}${icon_model} ${CYAN}${model}${NC}"

  # Context bar
  local bar
  bar=$(build_bar "$pct")
  output+="${sep}${icon_gauge} ${bar} ${pct}%"

  echo -e "$output"
}

main "$@"
