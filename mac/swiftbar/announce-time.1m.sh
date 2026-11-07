#!/bin/bash
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>

HELPER="$HOME/dotfiles/mac/scripts/announce-time.sh"
resume_at="$("$HELPER" resume-at)"

if [ "$("$HELPER" status)" = "true" ]; then
  echo "| sfimage=clock.badge.checkmark"
  echo "---"
  echo "Announce the time: On"
  echo "Turn Off | bash=$HELPER param1=off terminal=false refresh=true"
else
  echo "| sfimage=clock.badge.xmark"
  echo "---"
  if [ -n "$resume_at" ]; then
    echo "Announce the time: Off until $(date -r "$resume_at" '+%m/%d %H:%M')"
  else
    echo "Announce the time: Off"
  fi
  echo "Turn On | bash=$HELPER param1=on terminal=false refresh=true"
fi

echo "---"
for d in 3h 8h 24h 2d; do
  echo "Turn Off for $d | bash=$HELPER param1=off-for param2=$d terminal=false refresh=true"
done
