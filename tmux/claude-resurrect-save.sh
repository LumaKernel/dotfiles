#!/usr/bin/env bash
# tmux-resurrect post-save hook: save claude session IDs for each pane
# Called by @resurrect-hook-post-save-layout with state file as $1

set -euo pipefail

MAPPING_FILE="$HOME/.tmux/resurrect/claude-sessions.txt"
: > "$MAPPING_FILE"

# For each tmux pane running claude, extract the session ID
tmux list-panes -a -F '#{pane_id} #{pane_tty} #{pane_current_command} #{pane_current_path}' | while read -r pane_id pane_tty pane_cmd pane_cwd; do
  [ "$pane_cmd" = "claude" ] || continue

  # Find the claude PID on this TTY
  pid=$(ps -o pid= -o tty= -o comm= | awk -v tty="${pane_tty#/dev/}" '$2 == tty && $3 == "claude" {print $1; exit}')
  [ -n "$pid" ] || continue

  session_id=""

  # 1) Check process args for --resume <id> or --session-id <id>
  args=$(ps -o args= -p "$pid" 2>/dev/null || true)
  if [[ "$args" =~ --resume[[:space:]]+([0-9a-f-]{36}) ]]; then
    session_id="${BASH_REMATCH[1]}"
  elif [[ "$args" =~ --session-id[[:space:]]+([0-9a-f-]{36}) ]]; then
    session_id="${BASH_REMATCH[1]}"
  fi

  # 2) Fallback: find the most recently modified jsonl in the project dir
  if [ -z "$session_id" ]; then
    # Convert CWD to claude's project dir name: /Users/luma/foo -> -Users-luma-foo
    project_dir=$(echo "$pane_cwd" | sed 's|[/.]|-|g')
    project_path="$HOME/.claude/projects/${project_dir}"
    if [ -d "$project_path" ]; then
      # Get process start time as epoch
      pid_start=$(ps -o lstart= -p "$pid" 2>/dev/null | xargs -I{} date -jf "%a %b %d %T %Y" "{}" "+%s" 2>/dev/null || echo "")

      if [ -n "$pid_start" ]; then
        # Find jsonl whose first entry timestamp is closest to process start
        best_id=""
        best_diff=999999999
        for jsonl in "$project_path"/*.jsonl; do
          [ -f "$jsonl" ] || continue
          first_ts=$(head -1 "$jsonl" | sed -n 's/.*"timestamp":"\([^"]*\)".*/\1/p')
          [ -n "$first_ts" ] || continue
          # Convert ISO timestamp to epoch
          jsonl_epoch=$(TZ=UTC date -jf "%Y-%m-%dT%H:%M:%S" "${first_ts%%.*}" "+%s" 2>/dev/null || echo "")
          [ -n "$jsonl_epoch" ] || continue
          diff=$(( pid_start - jsonl_epoch ))
          [ $diff -lt 0 ] && diff=$(( -diff ))
          if [ $diff -lt $best_diff ]; then
            best_diff=$diff
            best_id=$(basename "$jsonl" .jsonl)
          fi
        done
        session_id="$best_id"
      fi

      # 3) Last resort: most recently modified jsonl
      if [ -z "$session_id" ]; then
        latest=$(ls -t "$project_path"/*.jsonl 2>/dev/null | head -1)
        [ -n "$latest" ] && session_id=$(basename "$latest" .jsonl)
      fi
    fi
  fi

  if [ -n "$session_id" ]; then
    echo "${pane_id} ${session_id} ${pane_cwd}" >> "$MAPPING_FILE"
  fi
done
