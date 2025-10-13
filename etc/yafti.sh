#!/usr/bin/env bash

notify-send -u normal -t 5000 -a "System" "Hello, welcome to Slate!" "Please wait for the first boot installer to launch."

AUTOSTART_FILE="$HOME/.config/autostart/yafti-first-boot.desktop"

/usr/bin/yafti /etc/yafti/yafti.yml

if [ -f "$AUTOSTART_FILE" ]; then
   rm "$AUTOSTART_FILE"
fi
