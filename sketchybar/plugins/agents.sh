#!/bin/bash
source "$CONFIG_DIR/colors.sh"
ST=/tmp/sketchybar-agents.state; now=$(date +%s); ACTIVE=20
active_of() { # $1 = dirs, prints "mtime path" of files touched in the last minute
  find $1 -name '*.jsonl' -type f -mmin -1 2>/dev/null | while read -r f; do echo "$(stat -f %m "$f") $f"; done
}
CL=$(active_of ~/.claude/projects); CX=$(active_of ~/.codex/sessions)
count() { echo "$1" | awk -v n=$now -v a=$ACTIVE 'NF && n-$1<=a' | wc -l | tr -d ' '; }
NC=$(count "$CL"); NX=$(count "$CX")
PREV_C=0; PREV_X=0; [ -f "$ST" ] && read -r PREV_C PREV_X < "$ST"
echo "$NC $NX" > "$ST"
[ "$PREV_C" -gt 0 ] && [ "$NC" -eq 0 ] && osascript -e 'display notification "Claude Code finished" with title "AI agent"' >/dev/null 2>&1 &
[ "$PREV_X" -gt 0 ] && [ "$NX" -eq 0 ] && osascript -e 'display notification "Codex finished" with title "AI agent"' >/dev/null 2>&1 &
L=""; [ "$NC" -gt 0 ] && L="claude x$NC"; [ "$NX" -gt 0 ] && L="${L:+$L  }codex x$NX"
if [ -n "$L" ]; then sketchybar --set "$NAME" drawing=on label="$L"; else sketchybar --set "$NAME" drawing=off; fi
