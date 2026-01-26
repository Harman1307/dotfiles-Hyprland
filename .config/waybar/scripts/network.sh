#!/bin/bash

# WiFi
wifi_status=$(nmcli -t -f TYPE,STATE device 2>/dev/null | grep "^wifi:" | cut -d: -f2)
[ "$wifi_status" = "connected" ] && wifi=" " || wifi="󰖪"

# Bluetooth
bt_connected=$(bluetoothctl devices Connected 2>/dev/null | head -1)
[ -n "$bt_connected" ] && bt="󰂯" || bt="󰂲"

echo "$wifi $bt"
