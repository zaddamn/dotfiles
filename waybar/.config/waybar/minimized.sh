#!/usr/bin/env bash
# glyph for the Nth window on special:magic (slot N), empty when none
n="${1:-1}"
c=$(hyprctl clients -j | jq -r --argjson n "$n" '[.[] | select(.workspace.name=="special:magic")] | sort_by(.address) | .[$n-1].class // empty')
case "${c,,}" in
  "")       echo '{"text":""}'; exit 0 ;;
  firefox*) g=$'\uf269' ;;
  kitty*)   g=$'\uf120' ;;
  *)        g=$'\uf2d0' ;;
esac
printf '{"text":"%s","tooltip":false}\n' "$g"
