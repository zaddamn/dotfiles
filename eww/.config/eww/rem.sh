#!/bin/bash
p=$(playerctl position 2>/dev/null); l=$(playerctl metadata mpris:length 2>/dev/null)
awk -v p="${p:-0}" -v l="${l:-0}" 'BEGIN { r = l/1000000 - p; if (l <= 0 || r < 0) { print "0:00"; exit } r = int(r); printf "-%d:%02d\n", r/60, r%60 }'
