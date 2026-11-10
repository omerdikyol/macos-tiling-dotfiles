#!/bin/bash
G=$(ioreg -r -d 1 -c IOAccelerator | grep -o '"Device Utilization %"=[0-9]*' | head -1 | cut -d= -f2)
[ -n "$G" ] && sketchybar --set "$NAME" label="${G}%"
