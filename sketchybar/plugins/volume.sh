#!/bin/bash
source "$CONFIG_DIR/colors.sh"
sync_popup() {
  OUT=$(osascript -e 'output volume of (get volume settings)'); IN=$(osascript -e 'input volume of (get volume settings)')
  sketchybar --set vol.out slider.percentage="$OUT" --set vol.in slider.percentage="$IN"
}
case "$SENDER" in
  mouse.clicked) sync_popup; sketchybar --set volume popup.drawing=toggle; exit 0 ;;
  mouse.exited.global) sketchybar --set volume popup.drawing=off; exit 0 ;;
esac
V="${INFO:-$(osascript -e 'output volume of (get volume settings)')}"
MUTED=$(osascript -e 'output muted of (get volume settings)')
if [ "$MUTED" = "true" ] || [ "$V" = "0" ]; then ICON="󰖁"
elif [ "$V" -ge 60 ]; then ICON="󰕾"
elif [ "$V" -ge 25 ]; then ICON="󰖀"
else ICON="󰕿"; fi
sketchybar --set volume icon="$ICON" icon.color=$(getcolor yellow) label="${V}%"
