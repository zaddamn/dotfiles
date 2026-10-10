#!/usr/bin/env bash
# icon file path for the Nth window on special:magic (empty if none)
n="${1:-1}"
c="${2:-$(hyprctl clients -j | jq -r --argjson n "$n" '[.[] | select(.workspace.name=="special:magic")] | sort_by(.address) | .[$n-1].class // empty')}"
[ -z "$c" ] && exit 0
d=$(find /usr/share/applications "$HOME/.local/share/applications" -iname "${c}.desktop" 2>/dev/null | head -1)
[ -z "$d" ] && d=$(grep -il "^StartupWMClass=${c}$" /usr/share/applications/*.desktop 2>/dev/null | head -1)
i=$(grep -m1 '^Icon=' "$d" 2>/dev/null | cut -d= -f2)
[ -z "$i" ] && i="$c"
case "$i" in /*) [ -f "$i" ] && { echo "$i"; exit 0; } ;; esac
src=$(find /usr/share/icons/hicolor /usr/share/pixmaps \( -name "$i.png" -o -name "$i.svg" \) 2>/dev/null | sort -V | tail -1)
[ -z "$src" ] && exit 0
out="$HOME/.cache/waybar-min/$i.png"
mkdir -p "$HOME/.cache/waybar-min"
[ -f "$out" ] || magick -background none "$src" -resize 20x20 -filter point -resize 22x22 -colorspace Gray -fill '#cfe3ee' -tint 100 "$out"
echo "$out"
