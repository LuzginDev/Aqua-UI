#!/bin/bash
hyprctl switchxkblayout all next
FULL_LAYOUT=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' | head -n 1)
if [[ "$FULL_LAYOUT" == *"Russian"* ]]; then CODE="RU"; elif [[ "$FULL_LAYOUT" == *"Ukrainian"* ]]; then CODE="UA"; else CODE="EN"; fi
if [ -S /tmp/aqua.sock ]; then echo "keyboard:$CODE" | socat - UNIX-CONNECT:/tmp/aqua.sock; fi