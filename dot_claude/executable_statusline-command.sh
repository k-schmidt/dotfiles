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

reset=$'\033[0m'
bold=$'\033[1m'

# Catppuccin Mocha as 24-bit colour.
#
# The ANSI 16-colour palette cannot be used here: Catppuccin remaps every ANSI
# colour to a light pastel, so the old "bright white on blue" rendered at a
# 1.06:1 contrast ratio, and white-on-magenta and white-on-red were no better
# (1.46:1 and 1.04:1). Pinning the values means the bar no longer depends on
# whatever the terminal palette happens to be.
#
# Every segment now puts crust on its pastel, which lands between 8:1 and 15:1.
fg_dark=$'\033[38;2;17;17;27m'                                        # crust   #11111b

blue_bg=$'\033[48;2;137;180;250m';    blue_fg=$'\033[38;2;137;180;250m'    # #89b4fa
green_bg=$'\033[48;2;166;227;161m';   green_fg=$'\033[38;2;166;227;161m'   # #a6e3a1
yellow_bg=$'\033[48;2;249;226;175m';  yellow_fg=$'\033[38;2;249;226;175m'  # #f9e2af
red_bg=$'\033[48;2;243;139;168m';     red_fg=$'\033[38;2;243;139;168m'     # #f38ba8
mauve_bg=$'\033[48;2;203;166;247m';   mauve_fg=$'\033[38;2;203;166;247m'   # #cba6f7
teal_bg=$'\033[48;2;148;226;213m';    teal_fg=$'\033[38;2;148;226;213m'    # #94e2d5

# Segment colours. sep_fg carries the segment's own colour into the next
# segment's background, which is what draws the powerline arrow.
dir_bg=$blue_bg;         dir_fg=$fg_dark;        dir_sep_fg=$blue_fg
git_bg=$green_bg;        git_fg=$fg_dark;        git_sep_fg=$green_fg
git_dirty_bg=$yellow_bg; git_dirty_fg=$fg_dark;  git_dirty_sep_fg=$yellow_fg
ctx_bg=$teal_bg;         ctx_fg=$fg_dark;        ctx_sep_fg=$teal_fg
ctx_warn_bg=$red_bg;     ctx_warn_fg=$fg_dark;   ctx_warn_sep_fg=$red_fg
session_bg=$mauve_bg;    session_fg=$fg_dark;    session_sep_fg=$mauve_fg

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
