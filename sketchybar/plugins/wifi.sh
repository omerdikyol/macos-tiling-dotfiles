#!/bin/bash
source "$CONFIG_DIR/colors.sh"
IP=$(ipconfig getifaddr en0 2>/dev/null)
if [ -n "$IP" ]; then
  sketchybar --set wifi icon="󰖩" icon.color=$(getcolor cyan)
else
  sketchybar --set wifi icon="󰖪" icon.color=$(getcolor red)
fi

fill_popup() {
  local info; info=$(system_profiler SPAirPortDataType 2>/dev/null | awk '/Current Network Information/{f=1} f&&/Other Local/{exit} f')
  local ch sig rate
  ch=$(echo "$info" | sed -n 's/.*Channel: \([0-9]*\) (\([0-9]*GHz\).*/\2 ch \1/p' | head -1)
  sig=$(echo "$info" | sed -n 's/.*Signal \/ Noise: \(-[0-9]* dBm\).*/\1/p' | head -1)
  rate=$(echo "$info" | sed -n 's/.*Transmit Rate: *//p' | head -1)
  sketchybar --set wifi.ip label="${IP:-not connected}  (click to copy)" \
             --set wifi.router label="Router $(route -n get default 2>/dev/null | awk '/gateway/{print $2}')" \
             --set wifi.link label="${ch:-n/a}  ${rate:+$rate Mbps}" \
             --set wifi.signal label="${sig:-n/a}"
}

case "$SENDER" in
  mouse.clicked) fill_popup; sketchybar --set wifi popup.drawing=toggle ;;
  mouse.exited.global) sketchybar --set wifi popup.drawing=off ;;
esac
