#!/bin/bash
CPU=$(ps -A -o %cpu= | awk -v c="$(sysctl -n hw.ncpu)" '{s+=$1} END {printf "%d", s/c}')
sketchybar --set "$NAME" label="${CPU}%"
