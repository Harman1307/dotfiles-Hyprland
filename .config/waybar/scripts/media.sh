#!/bin/bash

status=$(playerctl --player=%any status 2>/dev/null)

if [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
    artist=$(playerctl --player=%any metadata artist 2>/dev/null)
    title=$(playerctl --player=%any metadata title 2>/dev/null)
    
    if [ -n "$artist" ] && [ -n "$title" ]; then
        text="$artist - $title"
        if [ ${#text} -gt 45 ]; then
            text="${text:0:42}..."
        fi
        
        if [ "$status" = "Playing" ]; then
            echo "{\"text\":\"󰎆 $text\", \"class\":\"playing\"}"
        else
            echo "{\"text\":\"󰏤 $text\", \"class\":\"paused\"}"
        fi
    else
        echo "{\"text\":\"\", \"class\":\"stopped\"}"
    fi
else
    echo "{\"text\":\"\", \"class\":\"stopped\"}"
fi