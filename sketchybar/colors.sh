#!/bin/bash
# Tokyo Night palette and tokens. Structure adapted from Pe8er/dotfiles (MIT).
TOKYONIGHT=(
  blue "#7aa2f7"  teal "#1abc9c"   cyan "#7dcfff"   grey "#414868"
  green "#9fe044" yellow "#faba4a" orange "#ff9e64" red "#f7768e"
  purple "#9d7cd8" maroon "#914c54" black "#24283b" trueblack "#000000"
  white "#c0caf5"
)
COLORS=("${TOKYONIGHT[@]}")

PERCENT2HEX() { printf "0x%02X\n" $(( ($1 * 255) / 100 )); }

# getcolor NAME [OPACITY%] -> 0xAARRGGBB
getcolor() {
  local c="" i
  for ((i = 0; i < ${#COLORS[@]}; i += 2)); do
    [[ "${COLORS[i]}" == "$1" ]] && c="${COLORS[i + 1]}" && break
  done
  [[ -z $c ]] && { echo "Invalid color name: $1" >&2; return 1; }
  echo "$(PERCENT2HEX "${2:-100}")${c:1}"
}

BAR_COLOR=$(getcolor black 92)
HIGHLIGHT=$(getcolor blue)
ICON_COLOR=$(getcolor white)
LABEL_COLOR=$(getcolor white 85)
DARK=$(getcolor black)
TRANSPARENT=$(getcolor black 0)
