#!/bin/bash
source "$CONFIG_DIR/colors.sh"
DIR=~/Downloads; ST=/tmp/sketchybar-dl.state
CUR=$(find "$DIR" -maxdepth 1 \( -name '*.crdownload' -o -name '*.download' -o -name '*.part' -o -name '*.partial' \) 2>/dev/null)
PREV=$(cat "$ST" 2>/dev/null)
if [ -z "$CUR" ]; then
  # finished? announce each name that was running last time
  [ -n "$PREV" ] && while IFS=$'\t' read -r _ name; do
    osascript -e "display notification \"$name\" with title \"Download finished\"" >/dev/null 2>&1 &
  done <<< "$PREV"
  rm -f "$ST"; sketchybar --set "$NAME" drawing=off; exit 0
fi
OUT=""; N=0; TOTAL=0; NEWST=""
while IFS= read -r f; do
  b=$(basename "$f"); b=${b%.crdownload}; b=${b%.download}; b=${b%.part}; b=${b%.partial}
  sz=$(du -sk "$f" 2>/dev/null | cut -f1); TOTAL=$((TOTAL + sz)); N=$((N + 1)); NEWST+="$sz"$'\t'"$b"$'\n'; LAST=$b
done <<< "$CUR"
PS=$(echo "$PREV" | awk -F'\t' '{s+=$1} END {print s+0}'); RATE=$(( (TOTAL - PS) / 2 )); [ "$RATE" -lt 0 ] && RATE=0
printf '%s' "$NEWST" > "$ST"
LABEL="$LAST  $(awk -v k=$TOTAL 'BEGIN{printf "%.1fM", k/1024}')"
[ "$RATE" -gt 0 ] && LABEL="$LABEL  $(awk -v k=$RATE 'BEGIN{printf "%.1fM/s", k/1024}')"
[ "$N" -gt 1 ] && LABEL="$N downloads  $(awk -v k=$TOTAL 'BEGIN{printf "%.1fM", k/1024}')"
sketchybar --set "$NAME" drawing=on label="$LABEL"
