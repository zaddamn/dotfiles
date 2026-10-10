#!/bin/bash
url=$(playerctl metadata mpris:artUrl 2>/dev/null)
[ -z "$url" ] && exit 0
case "$url" in
  file://*) echo "${url#file://}" ;;
  http*)
    f=/tmp/eww-art-$(echo -n "$url" | md5sum | cut -d' ' -f1)
    [ -f "$f" ] || curl -sL "$url" -o "$f"
    echo "$f" ;;
esac
