#!/bin/bash

WIN_ID="$(yabai -m query --windows | jq '[.[] | select(.app == "Slack")][0].id' --raw-output -M)"
if test "$WIN_ID" != null; then
  yabai -m window --focus "$WIN_ID"
fi
