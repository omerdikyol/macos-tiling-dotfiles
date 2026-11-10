#!/bin/bash
# Shown only while the microphone is muted (macOS has no real mute, so input volume 0 counts as muted).
source "$CONFIG_DIR/colors.sh"
SAVED=/tmp/sketchybar-mic.saved
if [ "$SENDER" = "mouse.clicked" ]; then
  osascript -e "set volume input volume $(cat "$SAVED" 2>/dev/null || echo 75)"
fi
V=$(osascript -e 'input volume of (get volume settings)' 2>/dev/null)
if [ "$V" = "0" ]; then
  sketchybar --set "$NAME" drawing=on
else
  [ -n "$V" ] && echo "$V" > "$SAVED"
  sketchybar --set "$NAME" drawing=off
fi
