#!/bin/sh

if command -v redshift-gtk >/dev/null; then
    redshift-gtk &
elif command -v redshift >/dev/null; then
    redshift &
fi
