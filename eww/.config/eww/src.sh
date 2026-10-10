#!/bin/bash
playerctl metadata --format '{{playerName}}' 2>/dev/null | sed 's/\..*//; s/./\U&/'
