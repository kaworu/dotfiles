#!/bin/sh

if command -v swaync >/dev/null; then
    swaync --style ~/.config/swaync/style.css &
fi
