#!/bin/bash
FREE=$(memory_pressure 2>/dev/null | awk '/free percentage/{gsub("%","",$5); print $5}')
[ -n "$FREE" ] && sketchybar --set "$NAME" label="$((100 - FREE))%"
