#!/bin/bash
p=$(playerctl position 2>/dev/null)
l=$(playerctl metadata mpris:length 2>/dev/null)
awk -v p="${p:-0}" -v l="${l:-0}" 'BEGIN { if (l > 0) printf "%d", p*100000000/l; else print 0 }'
