#!/bin/bash
CACHE_DIR="/tmp/aqua_thumbs"
mkdir -p "$CACHE_DIR"
handle_active() {
    active_win=$(hyprctl activewindow -j)
    if [ "$active_win" == "{}" ]; then return; fi
    addr=$(echo "$active_win" | jq -r '.address')
    at=$(echo "$active_win" | jq -r '.at[0],[1]' | tr '\n' ',' | sed 's/,$//')
    size=$(echo "$active_win" | jq -r '.size[0]x.size[1]')
    grim -g "${at} ${size}" "$CACHE_DIR/$addr.png"
}
SOC="/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
socat -U - UNIX-CONNECT:"$SOC" | while read -r line; do
    case "$line" in
        activewindowv2*) handle_active ;;
    esac
done