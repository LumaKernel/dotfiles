#!/usr/bin/env bash
# Wrapper for tmux-resurrect: restore claude with the saved session ID
# resurrect runs this in the pane's saved CWD

set -euo pipefail

MAPPING_FILE="$HOME/.tmux/resurrect/claude-sessions.txt"
LOCK_FILE="${MAPPING_FILE}.lock"
cwd=$(pwd)

session_id=""
if [ -f "$MAPPING_FILE" ]; then
  # Use a lock to avoid race conditions between panes restoring simultaneously
  while ! mkdir "$LOCK_FILE" 2>/dev/null; do sleep 0.1; done
  trap 'rmdir "$LOCK_FILE" 2>/dev/null' EXIT

  # Take the first matching CWD entry, then remove it so the next pane gets the next one
  session_id=$(awk -v cwd="$cwd" '$3 == cwd {print $2; exit}' "$MAPPING_FILE")
  if [ -n "$session_id" ]; then
    # Remove only the first matching line
    sed -i '' "/ ${session_id} /d" "$MAPPING_FILE"
  fi

  rmdir "$LOCK_FILE" 2>/dev/null
  trap - EXIT
fi

if [ -n "$session_id" ]; then
  exec claude --resume "$session_id"
else
  exec claude --continue
fi
