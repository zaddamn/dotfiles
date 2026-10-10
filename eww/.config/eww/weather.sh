#!/bin/bash
C="$HOME/.cache/eww-clock/weather.txt"
mkdir -p "$(dirname "$C")"
if [ ! -f "$C" ] || [ -n "$(find "$C" -mmin +15)" ]; then
  R=$(curl -s -m 10 'wttr.in/Dhaka?format=%C|%t|%h|%w')
  if [ -n "$R" ] && [ "${R#*|}" != "$R" ]; then
    IFS='|' read -r cond temp hum wind <<< "$R"
    temp=${temp#+}; temp=${temp/°C/° C}
    wind=${wind#[^0-9]}; wind=${wind/km\/h/ km\/h}
    printf '%s\n' "Actual weather in Dhaka" "is $cond, $temp," "with humidity ${hum/\%/ %} and wind speed $wind." > "$C"
  fi
fi
cat "$C" 2>/dev/null
