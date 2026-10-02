#!/usr/bin/env bash
mode="${1:-text}"
class=$(hyprctl activewindow | awk '$1=="class:" {print $2; exit}')

cache="${XDG_CACHE_HOME:-$HOME/.cache}/cliphist/thumbs"
mkdir -p "$cache"

if [[ "$mode" == "img" ]]; then
  choice=$(
    cliphist list | grep 'binary data' | while IFS=$'\t' read -r id content; do
      thumb="$cache/$id.png"
      [[ -f "$thumb" && $(stat -c %s "$thumb") -gt 1000 ]] || { rm -f "$thumb"; printf '%s\t' "$id" | cliphist decode > "$thumb"; }
      [[ $(stat -c %s "$thumb") -gt 1000 ]] && printf '%s\0icon\x1f%s\n' "$id" "$thumb"
    done | rofi -dmenu -me-select-entry '' -me-accept-entry MousePrimary -show-icons -theme "$HOME/.config/rofi/clip-img.rasi"
  )
  id="$choice"
else
  choice=$(
    cliphist list | grep -v 'binary data' \
      | rofi -dmenu -me-select-entry '' -me-accept-entry MousePrimary -display-column-separator '\t' -display-columns 2 \
             -theme "$HOME/.config/rofi/clip-text.rasi"
  )
  id=$(printf '%s' "$choice" | cut -f1)
fi

[ -z "$id" ] && exit 0

printf '%s\t\n' "$id" | cliphist decode | wl-copy
sleep 0.15
if [[ "$class" == "kitty" ]]; then
  wtype -M ctrl -M shift v -m shift -m ctrl
else
  wtype -M ctrl v -m ctrl
fi
