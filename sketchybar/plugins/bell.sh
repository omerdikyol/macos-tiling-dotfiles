#!/bin/bash
source "$CONFIG_DIR/colors.sh"
LOG=/tmp/sketchybar-notifs.log; UNREAD=/tmp/sketchybar-notif.unread
case "$SENDER" in
  mouse.clicked)
    i=0
    for n in 1 2 3 4 5 6; do sketchybar --set bell.$n drawing=off; done
    if [ -s "$LOG" ]; then
      tail -n 6 "$LOG" | tail -r | while IFS=$'\t' read -r t title body; do
        i=$((i + 1)); sketchybar --set bell.$i drawing=on icon="$t" label="$title${body:+: $body}"
      done
    else sketchybar --set bell.1 drawing=on icon="" label="No notifications"; fi
    echo 0 > "$UNREAD"; sketchybar --set bell label="" drawing=off popup.drawing=toggle ;;
  mouse.exited.global) sketchybar --set bell popup.drawing=off ;;
esac
