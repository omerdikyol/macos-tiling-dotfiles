#!/bin/bash
# Copies these configs into place. Existing files are saved next to the new ones as *.pre-dotfiles.
# Read it first: it overwrites ~/.config/{sketchybar,omniwm,karabiner,starship.toml} and the Ghostty config.
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
put() { # put SRC DEST   (backs up DEST once)
  mkdir -p "$(dirname "$2")"
  [ -e "$2" ] && [ ! -e "$2.pre-dotfiles" ] && cp -R "$2" "$2.pre-dotfiles"
  rm -rf "$2"; cp -R "$1" "$2"
}
command -v brew >/dev/null || { echo "Homebrew is required"; exit 1; }
brew install jq starship nowplaying-cli FelixKratz/formulae/sketchybar
brew install --cask omniwm ghostty karabiner-elements font-jetbrains-mono-nerd-font

put "$HERE/sketchybar"          "$HOME/.config/sketchybar"
put "$HERE/omniwm/settings.toml" "$HOME/.config/omniwm/settings.toml"
put "$HERE/starship/starship.toml" "$HOME/.config/starship.toml"
put "$HERE/ghostty/config"      "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
mkdir -p "$HOME/.config/karabiner/bin" "$HOME/.local/bin"
sed "s|__HOME__|$HOME|g" "$HERE/karabiner/karabiner.json" > "$HERE/.karabiner.tmp"
put "$HERE/.karabiner.tmp" "$HOME/.config/karabiner/karabiner.json"; rm -f "$HERE/.karabiner.tmp"

# small helpers
swiftc -O "$HERE/sketchybar/src/clipwatch.swift" -o "$HOME/.config/sketchybar/bin/clipwatch"
swiftc -O "$HERE/karabiner/src/capskey.swift" -o "$HOME/.config/karabiner/bin/capskey"
chmod +x "$HOME"/.config/sketchybar/bin/* "$HOME"/.config/sketchybar/plugins/*
ln -sf "$HOME/.config/sketchybar/bin/bar-timer" "$HOME/.local/bin/bar-timer"
ln -sf "$HOME/.config/sketchybar/bin/ws-swap"   "$HOME/.local/bin/ws-swap"
cp "$HERE/bin/wallpaper" "$HOME/.local/bin/wallpaper"; chmod +x "$HOME/.local/bin/wallpaper"

grep -q 'starship init zsh' "$HOME/.zshrc" 2>/dev/null || printf '\neval "$(starship init zsh)"\n' >> "$HOME/.zshrc"
brew services start sketchybar
cat <<MSG

Done. Still manual (macOS asks for these):
  1. Privacy & Security: allow Accessibility + Input Monitoring for OmniWM, Karabiner-Elements, and sketchybar
     (/opt/homebrew/bin/sketchybar). Karabiner also needs its own driver/extension approval.
  2. System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys: set Caps Lock to "No Action".
  3. Start OmniWM, then reload Ghostty (Cmd+Shift+,).
MSG
