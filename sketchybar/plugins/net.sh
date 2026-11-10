#!/bin/bash
# Down/up rate on the default interface, from byte counters kept in /tmp.
IF=$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')
[ -z "$IF" ] && { sketchybar --set "$NAME" label="offline"; exit 0; }
read -r RX TX < <(netstat -ib -I "$IF" | awk 'NR==2{print $7, $10}')
NOW=$(date +%s); ST=/tmp/sketchybar-net.state
if [ -f "$ST" ]; then read -r T0 RX0 TX0 < "$ST"; DT=$((NOW - T0)); fi
echo "$NOW $RX $TX" > "$ST"
[ -z "$DT" ] || [ "$DT" -le 0 ] && exit 0
fmt() { local b=$1; if [ "$b" -ge 1048576 ]; then printf "%.1fM" "$(echo "$b/1048576" | bc -l)"; else printf "%dK" $((b / 1024)); fi; }
D=$(( (RX - RX0) / DT )); U=$(( (TX - TX0) / DT ))
[ "$D" -lt 0 ] && D=0; [ "$U" -lt 0 ] && U=0
sketchybar --set "$NAME" label="$(fmt $D) $(fmt $U)"
