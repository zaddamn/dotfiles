#!/bin/bash
cava -p ~/.config/eww/cava.conf | awk -F';' '{
  printf "[";
  for (i = 1; i < NF; i++) printf "%s%d", (i > 1 ? "," : ""), $i + 2;
  print "]";
  fflush();
}'
