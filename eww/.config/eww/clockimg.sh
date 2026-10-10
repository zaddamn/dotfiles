#!/bin/bash
F="$HOME/.local/share/fonts/ageo/Gobold Bold.otf"
D=${1:-$(date +%d)}
DIR="$HOME/.cache/eww-clock"
OUT="$DIR/day-$D.png"
mkdir -p "$DIR"
if [ ! -f "$OUT" ]; then
  T=$(mktemp -d)
  magick -background none -fill '#ffbb40' -font "$F" -pointsize 170 label:"$D" -trim +repage "$T/t.png"
  S=$(magick identify -format '%wx%h' "$T/t.png")
  magick -size "$S" gradient:white-gray35 "$T/g.png"
  magick "$T/t.png" \( +clone -alpha extract "$T/g.png" -compose multiply -composite \) -compose CopyOpacity -composite "$T/o.png"
  mv "$T/o.png" "$OUT"
  rm -rf "$T"
fi
echo "$OUT"
