#!/bin/bash
brightnessctl set "$1" -q
CURRENT=$(brightnessctl get)
MAX=$(brightnessctl max)
VAL=$(echo "scale=2; $CURRENT / $MAX" | bc)
if [ -S /tmp/aqua.sock ]; then echo "brightness:$VAL" | socat - UNIX-CONNECT:/tmp/aqua.sock; fi