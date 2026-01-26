#!/bin/bash

get_volume() {
    vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
    if echo "$vol" | grep -q "MUTED"; then
        echo "󰝟 mute"
    else
        pct=$(echo "$vol" | awk '{printf "%.0f", $2 * 100}')
        echo "󰕾 $pct%"
    fi
}

while true; do
    get_volume
    sleep 0.2
done