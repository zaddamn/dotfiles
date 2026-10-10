#!/bin/bash
pos=$(playerctl position 2>/dev/null)
len=$(playerctl metadata mpris:length 2>/dev/null)
awk -v p="${pos:-0}" -v l="${len:-0}" 'BEGIN {
  if (l <= 0) { print 0; exit }
  v = p * 1000000 / l * 100
  if (v < 0) v = 0; if (v > 100) v = 100
  printf "%.2f\n", v
}'
