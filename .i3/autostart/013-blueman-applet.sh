#!/bin/sh

if command -v blueman-applet >/dev/null; then
    blueman-applet &
fi
