#!/bin/bash

if [ -z "$@" ]; then
    echo "󰌾 Lock"
    echo "󰍃 Logout"
    echo "󰜉 Reboot"
    echo "󰐥 Shutdown"
else
    case "$@" in
        "󰌾 Lock")
            pkill -0 rofi && killall rofi
            ~/.config/i3/lock.sh &
            ;;
        "󰍃 Logout")  i3-msg exit ;;
        "󰜉 Reboot")   systemctl reboot ;;
        "󰐥 Shutdown") systemctl poweroff ;;
    esac
fi