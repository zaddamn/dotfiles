#!/bin/bash
[ "$(playerctl status 2>/dev/null)" = Playing ] && echo 1 || echo 0
