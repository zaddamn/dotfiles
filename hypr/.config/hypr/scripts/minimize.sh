#!/usr/bin/env bash
# send the active window to special:magic, then refresh waybar slots
hyprctl dispatch 'hl.dsp.window.move({ workspace = "special:magic", follow = false })'
pkill -RTMIN+9 waybar
