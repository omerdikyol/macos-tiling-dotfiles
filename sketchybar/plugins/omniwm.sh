#!/bin/bash
# $1 workspace, $2 highlight colour. Focused: filled pill with app name. Others: icon only, hidden if empty.
source "$CONFIG_DIR/colors.sh"
read -r CUR CNT < <(omniwmctl query workspaces --workspace "$1" --format json 2>/dev/null \
  | jq -r '.result.payload.workspaces[0] | "\(.isCurrent) \(.counts.total)"')
if [ "$CUR" = "true" ]; then
  APP=$(omniwmctl query focused-window --format json 2>/dev/null | jq -r '.result.payload.window.app.name // empty')
  sketchybar --set "$NAME" drawing=on background.drawing=on background.color=$2 \
    icon.color=$DARK label.drawing=$([ -n "$APP" ] && echo on || echo off) label="$APP" label.color=$DARK
elif [ "${CNT:-0}" -gt 0 ]; then
  sketchybar --set "$NAME" drawing=on background.drawing=off icon.color=$2 label.drawing=off
else
  sketchybar --set "$NAME" drawing=off
fi
