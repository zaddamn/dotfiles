#!/bin/bash
# per-app volume for Spotify only: reads level and mute state, sets level, toggles mute
read -r id vol mute < <(pactl list sink-inputs | awk '
  function flush() {
    if (name == "spotify" && !found) { print cur, (v == "" ? 0 : v), (m == "" ? "no" : m); found = 1 }
  }
  /^Sink Input #/ { flush(); sub("#", "", $3); cur = $3; v = ""; m = ""; name = "" }
  /^[ \t]*Mute:/ { m = $2 }
  /^[ \t]*Volume:/ && v == "" { match($0, /[0-9]+%/); v = substr($0, RSTART, RLENGTH - 1) }
  tolower($0) ~ /application\.name = "spotify"/ { name = "spotify" }
  END { flush() }')

case "$1" in
  get)   echo "${vol:-0}" ;;
  muted) echo "${mute:-no}" ;;
  set)   [ -n "$id" ] && pactl set-sink-input-volume "$id" "$(printf '%.0f' "$2")%" ;;
  mute)
    [ -n "$id" ] || exit 0
    pactl set-sink-input-mute "$id" toggle
    [ "$mute" = yes ] && n=no || n=yes
    eww update muted="$n"
    ;;
esac
