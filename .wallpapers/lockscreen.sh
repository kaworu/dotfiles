#!/bin/sh
# Simple i3lock image generator using ImageMagick.

set -e

# left and right screens resolutions
LEFTRES=1920x1080
RIGHTRES=2560x1440
# ImageMagick transformation before duplicating and adding the padlock image.
TRANSFORM='-colorspace Gray -blur 0x5'
# Image added at the center of the images.
PADLOCK="$(dirname "$0")/padlock.png"

if [ $# -ne 2 ]; then
    echo "usage $0 src.png dest.png" > /dev/stderr
    exit 1
fi

convert "$1" $TRANSFORM \
    '(' -clone 0 -resize "${LEFTRES}!"  '(' "$PADLOCK" -resize x190 -gravity center ')' -composite ')' \
    '(' -clone 0 -resize "${RIGHTRES}!" '(' "$PADLOCK" -resize x190 -gravity center ')' -composite ')' \
    -delete 0 \
    -background black -gravity South +append "$2"
