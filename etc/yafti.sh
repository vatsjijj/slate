#!/usr/bin/env bash

AUTOSTART_FILE="$HOME/.config/autostart/yafti-first-boot.desktop"

/usr/bin/yafti /etc/yafti/yafti.yml

if [ -f "$AUTOSTART_FILE" ]; then
   rm "$AUTOSTART_FILE"
fi
