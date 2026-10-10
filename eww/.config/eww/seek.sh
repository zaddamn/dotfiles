#!/bin/bash
# turns a 0-100 slider value into a playback position, ignoring tiny differences
l=$(playerctl metadata mpris:length 2>/dev/null); p=$(playerctl position 2>/dev/null)
[ -z "$l" ] && exit 0
t=$(awk -v v="$1" -v l="$l" 'BEGIN { printf "%.1f", v*l/100000000 }')
far=$(awk -v t="$t" -v p="${p:-0}" 'BEGIN { d = t - p; if (d < 0) d = -d; print (d > 4) ? 1 : 0 }')
[ "$far" = 1 ] && playerctl position "$t"
