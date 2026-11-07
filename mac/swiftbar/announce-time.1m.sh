#!/bin/bash
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>

HELPER="$HOME/dotfiles/mac/scripts/announce-time.sh"

if [ "$("$HELPER" status)" = "true" ]; then
  echo "| sfimage=clock.badge.checkmark"
  echo "---"
  echo "Announce the time: On"
  echo "Turn Off | bash=$HELPER param1=off terminal=false refresh=true"
else
  echo "| sfimage=clock.badge.xmark"
  echo "---"
  echo "Announce the time: Off"
  echo "Turn On | bash=$HELPER param1=on terminal=false refresh=true"
fi
