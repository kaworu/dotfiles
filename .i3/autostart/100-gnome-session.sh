#!/bin/sh

# used under lolbuntu

gnome-settings-daemon &      # handles themes, starts gnome-screensaver. You may have to use gconf to disable it setting the background.
nm-applet &                  # assuming you're using Network Manager
gnome-sound-applet &         # manage the speaker volume.
eval `gnome-keyring-daemon`  # SSH/GPG agent
