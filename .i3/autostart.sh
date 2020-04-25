#!/bin/sh
dir="`dirname "$0"`/autostart"

if [ -d "$dir" ]; then
    for f in "$dir"/*; do
        [ -x "$f" ] && "$f"
    done
fi
exit 0
