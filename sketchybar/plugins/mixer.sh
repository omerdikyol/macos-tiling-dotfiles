#!/bin/bash
# Slider script. Dragging/clicking a slider sets that volume.
source "$CONFIG_DIR/colors.sh"
case "$NAME" in
  vol.out) osascript -e "set volume output volume $PERCENTAGE" ;;
  vol.in)  osascript -e "set volume input volume $PERCENTAGE"; echo "$PERCENTAGE" > /tmp/sketchybar-mic.saved ;;
esac
sketchybar --set "$NAME" slider.percentage="$PERCENTAGE"
