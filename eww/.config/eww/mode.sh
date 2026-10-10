#!/bin/bash
case "$1" in
  shuffle) playerctl shuffle Toggle ;;
  repeat)  [ "$(playerctl loop)" = "Playlist" ] && playerctl loop None || playerctl loop Playlist ;;
  one)     [ "$(playerctl loop)" = "Track" ]    && playerctl loop None || playerctl loop Track ;;
esac
sleep 0.2
eww update shuf="$(playerctl shuffle)" loop="$(playerctl loop)"
