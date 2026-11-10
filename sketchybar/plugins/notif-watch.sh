#!/bin/bash
# Feeds Notification Center banners to SketchyBar and keeps a small history.
LOG=/tmp/sketchybar-notifs.log
osascript -l JavaScript "$CONFIG_DIR/plugins/notif-watch.js" 2>/dev/null | while IFS=$'\t' read -r _ kind title body; do
  printf '%s\t%s\t%s\n' "$(date +%H:%M)" "$title" "$body" >> "$LOG"
  tail -n 20 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
  sketchybar --trigger notification KIND="$kind" TITLE="$title" BODY="$body"
done
