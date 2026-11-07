#!/bin/bash

# Get / toggle macOS "Announce the time" (System Settings > Control Center > Clock Options).
# Usage: announce-time.sh status|on|off
# Used by mac/swiftbar/announce-time.1m.sh.

set -euo pipefail

DOMAIN=com.apple.speech.synthesis.general.prefs
KEY=:TimeAnnouncementPrefs:TimeAnnouncementsEnabled

status() {
  # Prints "true" / "false"
  defaults export "$DOMAIN" - | plutil -extract TimeAnnouncementPrefs.TimeAnnouncementsEnabled raw -o - -
}

set_enabled() {
  local tmp
  tmp="$(mktemp)"
  # Edit an exported copy: `defaults write -dict-add` would replace the whole nested dict (voice settings etc.)
  defaults export "$DOMAIN" "$tmp"
  /usr/libexec/PlistBuddy -c "Set $KEY $1" "$tmp"
  defaults import "$DOMAIN" "$tmp"
  rm -f "$tmp"
  # System Speech reads the prefs on launch, so restart it to apply
  launchctl kickstart -k gui/"$(id -u)"/com.apple.speech.synthesisserver
}

case "${1:-}" in
  status) status ;;
  on) set_enabled true ;;
  off) set_enabled false ;;
  *)
    echo "Usage: $0 status|on|off" >&2
    exit 1
    ;;
esac
