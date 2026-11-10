#!/bin/bash
# Turns clipboard changes into bar notices (not logged in the bell history).
"$CONFIG_DIR/bin/clipwatch" | while IFS=$'\t' read -r kind text; do
  case "$kind" in
    text)   B="$text" ;;
    file)   B="File: $text" ;;
    image)  B="Image" ;;
    hidden) B="Hidden item (not shown)" ;;
    *)      B="Something" ;;
  esac
  sketchybar --trigger notification KIND=clip TITLE="Copied" BODY="$B"
done
