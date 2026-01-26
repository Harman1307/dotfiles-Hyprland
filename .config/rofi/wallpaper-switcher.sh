#!/bin/bash

WALL_DIR="$HOME/wallpapers"
ROFI_PREVIEW="$HOME/wallpapers/.rofi-preview.jpg"
BLURRED="$HOME/wallpapers/.current-blurred.jpg"
CURRENT_WALL="$HOME/wallpapers/current"

if [ -z "$@" ]; then
  find "$WALL_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.png' -o -iname '*.webp' \) ! -name ".*" -print0 | sort -z | while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    current_link=$(readlink -f "$CURRENT_WALL" 2>/dev/null)
    if [ "$file" = "$current_link" ]; then
      echo -e "$filename\0icon\x1f$file\0info\x1fcurrent"
    else
      echo -e "$filename\0icon\x1f$file"
    fi
  done
else
  selected_path="$WALL_DIR/$(echo "$@" | awk '{print $1}')"

  if [ -f "$selected_path" ]; then
    killall rofi 2>/dev/null

    ln -sf "$selected_path" "$CURRENT_WALL"

    swww img "$selected_path" --transition-type any --transition-duration 2 &
    wal -i "$selected_path" -n -q

    cp ~/.cache/wal/colors-swaync.css ~/.config/swaync/style.css
    pkill -SIGUSR1 swaync
    killall waybar && waybar &

    rm -f "$ROFI_PREVIEW" "$BLURRED"
    
    if [[ "$selected_path" == *.gif ]]; then
      convert "$selected_path[0]" -resize 1920x -blur 0x8 -quality 85 "$BLURRED" &
      convert "$selected_path[0]" -resize 1000x -gravity center -crop 1000x1500+0+0 +repage -quality 85 "$ROFI_PREVIEW" &
    else
      convert "$selected_path" -resize 1920x -blur 0x8 -quality 85 "$BLURRED" &
      convert "$selected_path" -resize 1000x -gravity center -crop 1000x1500+0+0 +repage -quality 85 "$ROFI_PREVIEW" &
    fi
    
    wait

  fi
fi