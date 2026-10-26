#!/usr/bin/env bash
# yabai space --focus next/prev but constrained to the current display.
# Usage: yabai_space_focus.sh next|prev
set -euo pipefail

export PATH=/opt/homebrew/bin:"$PATH"

direction="${1:?Usage: yabai_space_focus.sh next|prev}"

current=$(yabai -m query --spaces --space)
display=$(echo "$current" | jq -r '.display')
index=$(echo "$current" | jq -r '.index')

case "$direction" in
  next)
    target=$(yabai -m query --spaces --display "$display" \
      | jq --argjson idx "$index" '[.[] | select(.index > $idx)] | sort_by(.index) | .[0].index // empty')
    ;;
  prev)
    target=$(yabai -m query --spaces --display "$display" \
      | jq --argjson idx "$index" '[.[] | select(.index < $idx)] | sort_by(.index) | .[-1].index // empty')
    ;;
  *)
    echo "Unknown direction: $direction" >&2
    exit 1
    ;;
esac

if [[ -n "$target" ]]; then
  yabai -m space --focus "$target"
fi
