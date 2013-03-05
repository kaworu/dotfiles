#!/bin/sh
autostartdir="`dirname "$0"`/autostart"

if [ -d "$autostartdir" ]; then
    for f in "$autostartdir"/*; do
        [ -x "$f" ] && . "$f"
    done
fi
exit 0
