#!/bin/bash
# prints e.g. [12,45,80,30] about 20 times a second
cava -p ~/.config/eww/cava.conf | sed -u 's/;$//; s/;/,/g; s/^/[/; s/$/]/'
