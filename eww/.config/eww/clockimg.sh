#!/bin/bash
D=${1:-$(date +%d)}
DIR="$HOME/.cache/eww-clock"
SRC="$DIR/digits7d"
OUT="$DIR/day-$D.png"
mkdir -p "$DIR"
if [ ! -f "$OUT" ]; then
  T=$(mktemp -d)
  magick "$SRC/d${D:0:1}.png" "$SRC/d${D:1:1}.png" -background none +smush -4 "$T/o.png"
  mv "$T/o.png" "$OUT"
  rm -rf "$T"
fi
echo "$OUT"
