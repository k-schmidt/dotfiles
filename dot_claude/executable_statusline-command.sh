#!/usr/bin/env bash
set -euo pipefail

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir')
session_name=$(echo "$input" | jq -r '.session_name // empty')
context_remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

dir_name=$(basename "$cwd")

# Powerline separator
sep=$''
thin=$''

# ANSI colors
reset=$'\033[0m'
bold=$'\033[1m'

# Segment colors (bg;fg pairs)
dir_bg=$'\033[44m'       # blue bg
dir_fg=$'\033[97m'       # white fg
dir_sep_fg=$'\033[34m'   # blue fg (for separator after blue bg)

git_bg=$'\033[42m'       # green bg
git_fg=$'\033[30m'       # black fg
git_sep_fg=$'\033[32m'   # green fg
git_dirty_bg=$'\033[43m' # yellow bg
git_dirty_fg=$'\033[30m' # black fg
git_dirty_sep_fg=$'\033[33m' # yellow fg

ctx_bg=$'\033[46m'       # cyan bg
ctx_fg=$'\033[30m'       # black fg
ctx_sep_fg=$'\033[36m'   # cyan fg
ctx_warn_bg=$'\033[41m'  # red bg
ctx_warn_fg=$'\033[97m'  # white fg
ctx_warn_sep_fg=$'\033[31m' # red fg

session_bg=$'\033[45m'   # magenta bg
session_fg=$'\033[97m'   # white fg
session_sep_fg=$'\033[35m' # magenta fg

out=""

# Directory segment
out+="${dir_bg}${dir_fg}${bold}  ${dir_name} ${reset}"

# Git segment
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null || echo "")
  if [ -n "$branch" ]; then
    dirty=false
    if ! git -C "$cwd" --no-optional-locks diff-index --quiet HEAD -- 2>/dev/null; then
      dirty=true
    fi

    if [ "$dirty" = true ]; then
      out+="${git_dirty_bg}${dir_sep_fg}${sep}${git_dirty_fg}${bold}  ${branch} ✗ ${reset}"
      last_sep_fg=$git_dirty_sep_fg
    else
      out+="${git_bg}${dir_sep_fg}${sep}${git_fg}${bold}  ${branch} ✓ ${reset}"
      last_sep_fg=$git_sep_fg
    fi
  else
    last_sep_fg=$dir_sep_fg
  fi
else
  last_sep_fg=$dir_sep_fg
fi

# Session segment
if [ -n "$session_name" ]; then
  out+="${session_bg}${last_sep_fg}${sep}${session_fg}${bold}  ${session_name} ${reset}"
  last_sep_fg=$session_sep_fg
fi

# Context segment
if [ -n "$context_remaining" ]; then
  pct=$(printf "%.0f" "$context_remaining")
  if [ "$pct" -lt 20 ]; then
    out+="${ctx_warn_bg}${last_sep_fg}${sep}${ctx_warn_fg}${bold} ctx:${pct}%  ${reset}"
    last_sep_fg=$ctx_warn_sep_fg
  else
    out+="${ctx_bg}${last_sep_fg}${sep}${ctx_fg}${bold} ctx:${pct}% ${reset}"
    last_sep_fg=$ctx_sep_fg
  fi
fi

# Final separator into default background
out+="${last_sep_fg}${sep}${reset}"

echo -e "$out"
