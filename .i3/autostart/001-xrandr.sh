#!/bin/sh
screens="$(xrandr -q | awk '/ connected / {print $1}')"
if [ "$(echo "$screens" | wc -l)" -eq 2 ]; then
    xrandr  --output    "$(echo "$screens" | awk 'NR == 1 {print}')" \
            --left-of   "$(echo "$screens" | awk 'NR == 2 {print}')"
fi
