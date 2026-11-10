#!/bin/bash
source "$CONFIG_DIR/colors.sh"
RAW=$(pmset -g batt)
P=$(echo "$RAW" | grep -Eo '[0-9]+%' | head -1 | tr -d %)
[ -z "$P" ] && exit 0
COLOR=$(getcolor green)
if   [ "$P" -ge 90 ]; then ICON="󰁹"
elif [ "$P" -ge 60 ]; then ICON="󰂀"
elif [ "$P" -ge 40 ]; then ICON="󰁾"
elif [ "$P" -ge 20 ]; then ICON="󰁼"; COLOR=$(getcolor yellow)
else ICON="󰁺"; COLOR=$(getcolor red); fi
echo "$RAW" | grep -q 'AC Power' && ICON="󰂄"
sketchybar --set battery icon="$ICON" icon.color=$COLOR label="${P}%"

fill_popup() {
  local state time cyc cond cap
  if echo "$RAW" | grep -q 'discharging'; then state="On battery"
  elif echo "$RAW" | grep -q 'not charging'; then state="Plugged in, not charging"
  elif echo "$RAW" | grep -q 'AC Power'; then state="Charging"
  else state="On battery"; fi
  time=$(echo "$RAW" | grep -Eo '[0-9]+:[0-9]+ remaining' | head -1)
  [ -z "$time" ] && time="no estimate"
  local sp; sp=$(system_profiler SPPowerDataType 2>/dev/null)
  cyc=$(echo "$sp" | awk -F': ' '/Cycle Count/{print $2; exit}')
  cond=$(echo "$sp" | awk -F': ' '/Condition/{print $2; exit}')
  cap=$(echo "$sp" | awk -F': ' '/Maximum Capacity/{print $2; exit}' | tr -d '%')
  sketchybar --set battery.state label="$state" \
             --set battery.time label="$time" \
             --set battery.cycles label="${cyc:-n/a} cycles" \
             --set battery.health label="${cond:-n/a}, max capacity ${cap:-n/a}%"
}

case "$SENDER" in
  mouse.clicked) fill_popup; sketchybar --set battery popup.drawing=toggle ;;
  mouse.exited.global) sketchybar --set battery popup.drawing=off ;;
esac
