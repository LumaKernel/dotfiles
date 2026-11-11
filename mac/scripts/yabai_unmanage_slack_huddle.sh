#!/bin/bash
# Slack のハドルウィンドウを yabai の管理対象外にする。
# ハドルのタイトルはチャンネル名で可変なので、常に最前面 (level != 0) かどうかで判定する。
# `--toggle float` はこのウィンドウに効かないため、タイトル完全一致の一時ルールで manage=off する。
# 使い方: yabai_unmanage_slack_huddle.sh <window id>  (.yabairc の window_created signal から呼ばれる)
export PATH=/opt/homebrew/bin:"$PATH"

WIN_ID="$1"
TITLE="$(yabai -m query --windows --window "$WIN_ID" | jq -r 'select(.app == "Slack" and .level != 0) | .title')"
if test -n "$TITLE"; then
  ESCAPED="$(printf '%s' "$TITLE" | sed 's/[][\.*^$+?(){}|/]/\\&/g')"
  yabai -m rule --apply app='^Slack$' title="^${ESCAPED}\$" manage=off
fi
