#!/bin/bash
C="$HOME/.cache/eww-clock/weather.txt"
G="<span foreground='#f7c46a'>"; E="</span>"
mkdir -p "$(dirname "$C")"
if [ ! -f "$C" ] || [ -n "$(find "$C" -mmin +15)" ]; then
  R=$(curl -s -m 10 'wttr.in/Dhaka?format=%C|%t|%h|%w')
  if [ -n "$R" ] && [ "${R#*|}" != "$R" ]; then
    IFS='|' read -r cond temp hum wind <<< "$R"
    cond=$(printf '%s' "$cond" | sed 's/&/\&amp;/g;s/</\&lt;/g;s/>/\&gt;/g')
    temp=${temp#+}; temp=${temp/°C/° C}
    wind=${wind#[^0-9]}; wind=${wind/km\/h/ km\/h}
    hum=${hum/\%/ %}
    printf '%s\n' "Actual weather in ${G}Dhaka${E}" "is ${G}${cond}${E}, ${G}${temp}${E}," "with humidity ${G}${hum}${E} and wind speed ${G}${wind}${E}." > "$C"
  fi
fi
cat "$C" 2>/dev/null
