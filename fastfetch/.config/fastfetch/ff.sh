#!/usr/bin/env bash
cols=$(tput cols)
if [ "$cols" -ge 72 ]; then cfg=config.jsonc
elif [ "$cols" -ge 44 ]; then cfg=compact.jsonc
else cfg=minimal.jsonc
fi
fastfetch -c "$HOME/.config/fastfetch/$cfg"
