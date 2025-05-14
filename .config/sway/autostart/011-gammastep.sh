#!/bin/sh

if command -v gammastep >/dev/null; then
    gammastep -l 46.2:6.1 -t 5700:3500 &
fi
