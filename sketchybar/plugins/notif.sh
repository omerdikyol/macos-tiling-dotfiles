#!/bin/bash
# Inline notification pill in the bar. Shows a new notification for 7s, then hides.
# Also drives the bell badge/popup (item "bell"). Click the bell for history, click the pill to dismiss.
source "$CONFIG_DIR/colors.sh"
SHOW=7; STAMP=/tmp/sketchybar-notif.stamp; UNREAD=/tmp/sketchybar-notif.unread
case "$SENDER" in
  notification)
    LABEL="$TITLE${BODY:+: $BODY}"
    date +%s > "$STAMP"
    if [ "$KIND" = clip ]; then
      sketchybar --set notif drawing=on icon="󰅇" icon.color=$(getcolor cyan) label="$LABEL"
    else
      echo $(( $(cat "$UNREAD" 2>/dev/null || echo 0) + 1 )) > "$UNREAD"
      sketchybar --set notif drawing=on icon="󰂜" icon.color=$(getcolor yellow) label="$LABEL" \
                 --set bell drawing=on label="$(cat "$UNREAD")"
    fi
    ;;
  routine|forced)
    [ -f "$STAMP" ] && [ $(( $(date +%s) - $(cat "$STAMP") )) -ge $SHOW ] && sketchybar --set notif drawing=off
    ;;
esac
