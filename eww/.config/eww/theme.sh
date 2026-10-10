#!/bin/bash
cd ~/.config/eww || exit 1
p="${1:-ember}"
[ -f "palettes/$p.scss" ] || { echo "no palette: $p"; exit 1; }
cat "palettes/$p.scss" base.scss > eww.scss
eww reload 2>/dev/null || { eww kill; eww daemon; eww open desk; }
echo "theme: $p"
