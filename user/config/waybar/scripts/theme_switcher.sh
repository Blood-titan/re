#!/usr/bin/env bash
# Theme switcher for Waybar (and optionally global theme)
# Usage:
#   theme_switcher.sh status  -> show current theme
#   theme_switcher.sh next    -> switch to next theme
#   theme_switcher.sh apply <name> -> apply specific theme

THEMES_DIR="$HOME/.config/waybar/themes"
STATE_FILE="$HOME/.config/waybar/theme_state"
CURRENT_THEME="mica"

mkdir -p "$THEMES_DIR"

# Ensure at least two theme files exist for demo
# You can add: mica.css, catppuccin.css, nord.css, etc.
if [ ! -f "$THEMES_DIR/mica.css" ]; then
  echo "/* default Mica theme */" > "$THEMES_DIR/mica.css"
fi
if [ ! -f "$THEMES_DIR/dark.css" ]; then
  echo "/* dark fallback theme */" > "$THEMES_DIR/dark.css"
fi

# Load current theme name
if [ -f "$STATE_FILE" ]; then
  CURRENT_THEME=$(cat "$STATE_FILE")
fi

apply_theme() {
  theme="$1"
  css_file="$THEMES_DIR/$theme.css"
  if [ -f "$css_file" ]; then
    ln -sf "$css_file" "$HOME/.config/waybar/style.css"
    echo "$theme" > "$STATE_FILE"
    pkill -SIGUSR2 waybar 2>/dev/null  # reload style
    notify-send "Waybar Theme" "Applied theme: $theme"
  else
    notify-send "Waybar Theme" "Theme $theme not found!"
  fi
}

case "$1" in
  status)
    echo "{\"text\":\"\",\"tooltip\":\"Theme: $CURRENT_THEME\"}"
    ;;
  next)
    themes=($(ls "$THEMES_DIR" | sed 's/\.css$//'))
    count=${#themes[@]}
    if [ $count -eq 0 ]; then exit 0; fi
    for i in "${!themes[@]}"; do
      if [ "${themes[$i]}" == "$CURRENT_THEME" ]; then
        next=$(( (i + 1) % count ))
        break
      fi
    done
    next_theme="${themes[$next]}"
    apply_theme "$next_theme"
    ;;
  apply)
    apply_theme "$2"
    ;;
  *)
    echo "{\"text\":\"\"}"
    ;;
esac
