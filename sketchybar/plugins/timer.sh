#!/bin/bash
source "$CONFIG_DIR/colors.sh"
ST=/tmp/sketchybar-timer.state; BT="$CONFIG_DIR/bin/bar-timer"
fmt() { local s=$1; if [ "$s" -ge 3600 ]; then printf "%d:%02d:%02d" $((s/3600)) $((s%3600/60)) $((s%60)); else printf "%02d:%02d" $((s/60)) $((s%60)); fi; }
if [ "$SENDER" = "mouse.clicked" ]; then
  if [ ! -f "$ST" ]; then sketchybar --set timer popup.drawing=toggle; exit 0; fi
  if [ "$BUTTON" = "right" ]; then "$BT" stop; exit 0; fi
  read -r M S D P < "$ST"; if [ "$P" = 0 ]; then "$BT" pause; else "$BT" resume; fi; exit 0
fi
[ "$SENDER" = "mouse.exited.global" ] && { sketchybar --set timer popup.drawing=off; exit 0; }
IDLE="󱎫"
if [ ! -f "$ST" ]; then sketchybar --set timer icon="$IDLE" icon.color=$(getcolor grey) label.drawing=off; exit 0; fi
read -r M S D P < "$ST"; now=$(date +%s); [ "$P" != 0 ] && now=$P
el=$((now - S))
if [ "$M" = sw ]; then
  sketchybar --set timer icon="󰔟" icon.color=$(getcolor green) label.drawing=on label="$(fmt $el)"
else
  rem=$((D - el))
  if [ "$rem" -le 0 ]; then
    rm -f "$ST"; afplay /System/Library/Sounds/Glass.aiff >/dev/null 2>&1 &
    osascript -e 'display notification "Timer finished" with title "Timer"' >/dev/null 2>&1 &
    sketchybar --set timer icon="$IDLE" icon.color=$(getcolor grey) label.drawing=off; exit 0
  fi
  C=$(getcolor orange); [ "$P" != 0 ] && C=$(getcolor grey)
  sketchybar --set timer icon="󱎫" icon.color=$C label.drawing=on label="$(fmt $rem)"
fi
