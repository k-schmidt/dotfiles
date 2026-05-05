#!/usr/bin/env bash
# StatusLine for Claude Code
# Inspired by Powerlevel10k configuration

set -euo pipefail

# Read JSON input from stdin
input=$(cat)

# Extract data using jq
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
session_name=$(echo "$input" | jq -r '.session_name // empty')
context_remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Build left side (directory + git)
left=""

# Current directory (basename, mimicking Powerlevel10k's compact style)
dir_name=$(basename "$cwd")
left+=" $dir_name"

# Git branch (if in git repo, skip locks for speed)
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null || echo "")
  if [ -n "$branch" ]; then
    # Check for dirty status
    if ! git -C "$cwd" --no-optional-locks diff-index --quiet HEAD -- 2>/dev/null; then
      left+=" ✗"
    else
      left+=" ✓"
    fi
    left+=" $branch"
  fi
fi

# Build right side
right=""

# Session name (if set)
if [ -n "$session_name" ]; then
  right+="$session_name  "
fi

# Model name
right+="$model"

# Context remaining (if available)
if [ -n "$context_remaining" ]; then
  pct=$(printf "%.0f" "$context_remaining")
  right+="  ctx:${pct}%"
fi

# Combine with separator
separator="  "
echo "${left}${separator}${right}"
