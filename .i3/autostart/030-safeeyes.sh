#!/bin/sh

if command -v snixembed >/dev/null; then
    if command -v safeeyes >/dev/null; then
    snixembed --fork
    safeeyes &
    fi
fi
