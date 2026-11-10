#!/bin/bash
source "$CONFIG_DIR/colors.sh"
PADDINGS=6
FONT="JetBrainsMono Nerd Font"

bar=(
  color=$TRANSPARENT position=top height=32 padding_left=6 padding_right=6
  corner_radius=0 blur_radius=0 notch_width=200 sticky=on topmost=off
)
item_defaults=(
  background.corner_radius=6 background.height=22
  icon.color=$ICON_COLOR icon.font="$FONT:Regular:14"
  icon.padding_left=6 icon.padding_right=4
  label.color=$LABEL_COLOR label.font="$FONT:Bold:12"
  label.padding_left=0 label.padding_right=6
  padding_left=2 padding_right=2
  updates=when_shown
)
bracket_defaults=(background.corner_radius=8 background.color=$BAR_COLOR background.height=26)

menu_defaults=(
  popup.align=right popup.y_offset=4 popup.blur_radius=0
  popup.background.color=$BAR_COLOR popup.background.corner_radius=8
  popup.background.border_width=1 popup.background.border_color=$(getcolor grey)
)
menu_item_defaults=(
  label.font="$FONT:Regular:12" icon.font="$FONT:Regular:13"
  icon.color=$HIGHLIGHT icon.width=22 icon.padding_left=6 icon.padding_right=0
  label.padding_left=4 label.padding_right=10 background.drawing=off
  updates=on drawing=on
)
