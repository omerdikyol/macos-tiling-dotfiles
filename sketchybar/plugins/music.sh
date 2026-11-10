#!/bin/bash
source "$CONFIG_DIR/colors.sh"
case "$SENDER" in
  mouse.entered) sketchybar --set "$NAME" scroll_texts=on; exit 0 ;;
  mouse.exited) sketchybar --set "$NAME" scroll_texts=off; exit 0 ;;
esac
{ IFS= read -r T; IFS= read -r A; IFS= read -r RATE; } < <(nowplaying-cli get title artist playbackRate 2>/dev/null)
if [ -z "$T" ] || [ "$T" = "null" ]; then sketchybar --set "$NAME" drawing=off; exit 0; fi
[ "$A" = "null" ] && A=""
LABEL="${A:+$A - }$T"
if [ "${RATE%.*}" != "0" ] && [ -n "$RATE" ] && [ "$RATE" != "null" ]; then
  ICON="󰎆"; COLOR=$(getcolor maroon)
else
  ICON="󰏤"; COLOR=$(getcolor grey)
fi
sketchybar --set "$NAME" drawing=on icon="$ICON" icon.color=$COLOR label="$LABEL"
