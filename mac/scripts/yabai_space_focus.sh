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
    edge=right
    ;;
  prev)
    target=$(yabai -m query --spaces --display "$display" \
      | jq --argjson idx "$index" '[.[] | select(.index < $idx)] | sort_by(.index) | .[-1].index // empty')
    edge=left
    ;;
  *)
    echo "Unknown direction: $direction" >&2
    exit 1
    ;;
esac

if [[ -n "$target" ]]; then
  yabai -m space --focus "$target"
else
  # Already at the edge of this display: show an overscroll effect instead.
  /Applications/OverscrollEmit.app/Contents/Helpers/overscroll-emit "$edge" --size=huge --density=light --flair=flashy --color=rainbow
fi
