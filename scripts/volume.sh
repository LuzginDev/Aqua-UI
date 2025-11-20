#!/bin/bash
# Argument: 5%+, 5%- or toggle
if [ "$1" == "toggle" ]; then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
else
    wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ "$1"
fi
STATUS=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
VOL=$(echo "$STATUS" | awk '{print $2}')
if [[ "$STATUS" == *"[MUTED]"* ]]; then IS_MUTED="true"; else IS_MUTED="false"; fi
if [ -S /tmp/aqua.sock ]; then echo "volume:$VOL:$IS_MUTED" | socat - UNIX-CONNECT:/tmp/aqua.sock; fi