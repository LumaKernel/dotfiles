#!/bin/bash

# Get / toggle macOS "Announce the time" (System Settings > Control Center > Clock Options).
# Usage: announce-time.sh status|on|off|off-for <N>m|<N>h|<N>d|resume-at|resume-if-due
# Used by:
#   mac/swiftbar/announce-time.1m.sh                (menu bar UI)
#   mac/launchagents/local.announce-time-on.plist     (on at login)
#   mac/launchagents/local.announce-time-resume.plist (resume-if-due every 60s; catches up after sleep)

set -euo pipefail

DOMAIN=com.apple.speech.synthesis.general.prefs
KEY=:TimeAnnouncementPrefs:TimeAnnouncementsEnabled
# Epoch seconds at which `off-for` should be undone. Absent = no pending resume.
RESUME_FILE="$HOME/.local/state/announce-time/resume-at"

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

clear_resume() {
  rm -f "$RESUME_FILE"
}

duration_seconds() {
  if [[ ! "$1" =~ ^([0-9]+)([mhd])$ ]]; then
    echo "Invalid duration: $1 (expected e.g. 30m, 3h, 2d)" >&2
    exit 1
  fi
  local n="${BASH_REMATCH[1]}"
  case "${BASH_REMATCH[2]}" in
    m) echo $((n * 60)) ;;
    h) echo $((n * 3600)) ;;
    d) echo $((n * 86400)) ;;
  esac
}

case "${1:-}" in
  status) status ;;
  on)
    clear_resume
    set_enabled true
    ;;
  off)
    clear_resume
    set_enabled false
    ;;
  off-for)
    seconds="$(duration_seconds "${2:-}")"
    mkdir -p "$(dirname "$RESUME_FILE")"
    echo $(($(date +%s) + seconds)) >"$RESUME_FILE"
    set_enabled false
    ;;
  resume-at)
    # Prints the pending resume epoch, or nothing
    cat "$RESUME_FILE" 2>/dev/null || true
    ;;
  resume-if-due)
    if [ -f "$RESUME_FILE" ] && [ "$(date +%s)" -ge "$(cat "$RESUME_FILE")" ]; then
      clear_resume
      set_enabled true
    fi
    ;;
  *)
    echo "Usage: $0 status|on|off|off-for <N>m|<N>h|<N>d|resume-at|resume-if-due" >&2
    exit 1
    ;;
esac
