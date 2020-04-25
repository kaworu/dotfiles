#!/bin/sh
screens="$(xrandr -q | awk '/ connected / {print $1}')"
if [ "$(echo "$screens" | wc -l)" -eq 2 ]; then
    xrandr --output "$(echo "$screens" | awk 'NR == 2 {print}')" --pos 1920x0 \
           --output "$(echo "$screens" | awk 'NR == 1 {print}')" --pos 0x360
fi
