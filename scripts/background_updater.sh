#!/bin/bash

# Cache directory
CACHE_DIR="/tmp/aqua_thumbs"
mkdir -p "$CACHE_DIR"

# Update interval (seconds)
INTERVAL=5

while true; do
    # 1. Get active workspace ID.
    # We only update VISIBLE windows. Taking screenshots of windows on other workspaces
    # is usually not possible with grim (or may produce a black screen/old buffer).
    ACTIVE_WS=$(hyprctl activeworkspace -j | jq -r '.id')

    # 2. Get the active window address.
    # We'll skip it because it's updated by the instant daemon (thumb_daemon.sh)
    ACTIVE_WIN_ADDR=$(hyprctl activewindow -j | jq -r '.address')

    # 3. Get the list of windows and filter it with jq:
    # - Only on the current workspace
    # - Format output into a string: "address x,y WxH"
    hyprctl clients -j | jq -r ".[] | select(.workspace.id == $ACTIVE_WS) | \"\(.address) \(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])\"" | \
    while read -r line; do
        # Read variables from the line
        addr=$(echo "$line" | awk '{print $1}')
        pos=$(echo "$line" | awk '{print $2}')
        size=$(echo "$line" | awk '{print $3}')

        # Skip the active window (to avoid duplicate work)
        if [ "$addr" == "$ACTIVE_WIN_ADDR" ]; then
            continue
        fi

        # Skip windows with zero size (minimized or hidden)
        if [ "$size" == "0x0" ]; then
            continue
        fi

        # 4. Take screenshot in background (& for concurrency)
        # Use grim, cropping the area by window coordinates
        grim -g "${pos} ${size}" "$CACHE_DIR/$addr.png" &
    done

    # Wait 5 seconds until next loop
    sleep $INTERVAL
done