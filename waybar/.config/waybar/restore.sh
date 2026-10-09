#!/usr/bin/env bash
# restore the Nth minimized window (slot N) to the current workspace
a=$(hyprctl clients -j | jq -r --argjson n "${1:-1}" '[.[] | select(.workspace.name=="special:magic")] | sort_by(.address) | .[$n-1].address // empty')
[ -z "$a" ] && exit 0
hyprctl dispatch "hl.dsp.window.move({ workspace = \"+0\", window = \"address:$a\" })"
