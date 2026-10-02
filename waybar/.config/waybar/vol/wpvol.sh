#!/usr/bin/env bash
# Wallpaper (mpvpaper) volume control for waybar.
#   wpvol.sh          -> print icon path + tooltip (for waybar "image" module)
#   wpvol.sh up       -> volume +5 (max 200)
#   wpvol.sh down     -> volume -5 (min 0)
#   wpvol.sh mute     -> toggle mute
# Needs: socat, and mpvpaper started with input-ipc-server=/tmp/mpvsocket
SOCK=/tmp/mpvsocket
DIR="$HOME/.config/waybar/vol/icons"
STEP=5
SIG=8   # waybar module uses "signal": 8

mpvcmd() { printf '{ "command": %s }\n' "$1" | socat - "$SOCK" 2>/dev/null; }
getvol() { mpvcmd '["get_property","volume"]' | sed -n 's/.*"data":\([0-9.]*\).*/\1/p'; }
ismuted() { mpvcmd '["get_property","mute"]' | grep -q '"data":true'; }
refresh() { pkill -RTMIN+$SIG waybar; }

case "$1" in
  up|down)
    v=$(getvol)
    [ -z "$v" ] && exit 0
    v=$(awk -v v="$v" -v s="$STEP" -v d="$1" 'BEGIN{
      v=int(v/s+0.5)*s; v=(d=="up")?v+s:v-s
      if(v>200)v=200; if(v<0)v=0; print v}')
    mpvcmd "[\"set_property\",\"volume\",$v]" >/dev/null
    refresh
    ;;
  mute)
    mpvcmd '["cycle","mute"]' >/dev/null
    refresh
    ;;
  *)
    v=$(getvol)
    if [ -z "$v" ]; then
      echo "$DIR/vol-muted.svg"
      echo "Wallpaper not running"
    elif ismuted; then
      echo "$DIR/vol-muted.svg"
      echo "Wallpaper muted"
    else
      r=$(awk -v v="$v" -v s="$STEP" 'BEGIN{printf "%d", int(v/s+0.5)*s}')
      echo "$DIR/vol-$r.svg"
      echo "Wallpaper volume: $r"
    fi
    ;;
esac
