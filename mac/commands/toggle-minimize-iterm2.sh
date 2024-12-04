#!/bin/bash

iterm2_window_json=$(yabai -m query --windows | jq '[.[] | select(.["app"] == "iTerm2")][0]')
iterm2_window_id=$(echo "$iterm2_window_json" | jq '.id')
iterm2_window_is_minimized=$(echo "$iterm2_window_json" | jq '.["is-minimized"]')
if [[ $iterm2_window_id != null ]]; then
  if [[ $iterm2_window_is_minimized == true ]]; then
    yabai -m window --deminimize "$iterm2_window_id"
    yabai -m window --focus "$iterm2_window_id"
  else
    yabai -m window --minimize "$iterm2_window_id"
  fi
fi
