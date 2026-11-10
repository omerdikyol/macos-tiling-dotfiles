#!/bin/bash
# Renumber workspaces so occupied ones are 1..n (close 3, then 4 becomes 3).
# Does nothing while the focused workspace is empty, so opening a fresh one still works.
LOCK=/tmp/omniwm-compact.lock
mkdir "$LOCK" 2>/dev/null || exit 0
trap 'rmdir "$LOCK"' EXIT
sleep 0.7
Q() { omniwmctl query "$@" --format json 2>/dev/null; }
CUR_JSON=$(Q workspaces --current)
CUR=$(echo "$CUR_JSON" | jq -r '.result.payload.workspaces[0].number')
CUR_N=$(echo "$CUR_JSON" | jq -r '.result.payload.workspaces[0].counts.total')
# Remember the focused workspace and its window count between runs. If the workspace we were just on
# lost its last window, leave it for the nearest occupied one. Switching to an empty workspace on
# purpose (Caps+N) is left alone.
STATE=/tmp/omniwm-cur.state
PW=""; PN=0; [ -f "$STATE" ] && read -r PW PN < "$STATE"
echo "$CUR $CUR_N" > "$STATE"
if [ "$CUR_N" = "0" ]; then
  [ "$PW" = "$CUR" ] && [ "${PN:-0}" -gt 0 ] || exit 0
  TARGET=$(Q windows | jq -r --argjson c "$CUR" '
    [.result.payload.windows[] | select((.isScratchpad // false) | not) | .workspace.number] | unique
    | ((map(select(. < $c)) | last) // (map(select(. > $c)) | first)) // empty')
  [ -n "$TARGET" ] || exit 0
  omniwmctl command switch-workspace "$TARGET" >/dev/null
  sleep 0.3
  CUR_JSON=$(Q workspaces --current)
  CUR=$(echo "$CUR_JSON" | jq -r '.result.payload.workspaces[0].number')
  CUR_N=$(echo "$CUR_JSON" | jq -r '.result.payload.workspaces[0].counts.total')
  echo "$CUR $CUR_N" > "$STATE"
fi
# "id oldws newws" for every window that has to move, lowest workspace first
MOVES=$(Q windows | jq -r '
  [.result.payload.windows[] | select((.isScratchpad // false) | not) | {id, ws: .workspace.number}] as $w
  | ($w | map(.ws) | unique) as $occ
  | $w | map(select(.ws != null) | . + {new: (.ws as $x | ($occ | index($x)) + 1)})
  | map(select(.new != .ws)) | sort_by(.ws)[] | "\(.id) \(.new)"')
[ -z "$MOVES" ] && exit 0
NEWCUR=$(Q windows | jq -r --argjson cur "$CUR" '
  [.result.payload.windows[] | select((.isScratchpad // false) | not) | .workspace.number] | unique | (index($cur) // empty) + 1')
while read -r ID NEW; do omniwmctl window move-to-workspace "$ID" "$NEW" >/dev/null; done <<< "$MOVES"
[ -n "$NEWCUR" ] && [ "$NEWCUR" != "$CUR" ] && omniwmctl command switch-workspace "$NEWCUR" >/dev/null

exit 0
