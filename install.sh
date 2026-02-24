#!/bin/bash

cd "$(dirname "$0")"

[[ ! -f /etc/arch-release ]] && echo "this is for arch btw" && exit 1
[[ ! -d .config ]] && echo "cant find .config" && exit 1

install_deps() {
  sudo pacman -S --needed hyprland hyprlock hypridle kitty thunar swww swaync cava fastfetch starship python-pywal kdeconnect grim slurp mpd mpc ttf-jetbrains-mono-nerd alsa-utils networkmanager bluez bluez-utils wireplumber brightnessctl playerctl imagemagick || exit 1

  if command -v yay &>/dev/null; then
    yay -S --needed gpu-screen-recorder rmpc mpd-mpris quickshell-git
  elif command -v paru &>/dev/null; then
    paru -S --needed gpu-screen-recorder rmpc mpd-mpris quickshell-git
  else
    echo "no aur helper, skipping aur packages"
    echo "run: yay -S gpu-screen-recorder rmpc mpd-mpris quickshell-git pokemon-colorscripts-go"
  fi

  sudo systemctl enable --now NetworkManager 2>/dev/null
  sudo systemctl enable --now bluetooth 2>/dev/null
}

install_configs() {
  mkdir -p ~/.config ~/.local/bin ~/wallpapers

  backup=~/.dotfiles-backup-$(date +%s)
  mkdir -p "$backup"

  for dir in hypr kitty waybar quickshell swaync scripts wal templates fastfetch cava; do
    [[ -e ~/.config/"$dir" ]] && mv ~/.config/"$dir" "$backup"/
    [[ -d .config/"$dir" ]] && cp -r .config/"$dir" ~/.config/
  done

  [[ -e ~/.config/starship.toml ]] && mv ~/.config/starship.toml "$backup"/
  cp .config/starship.toml ~/.config/

  [[ -d wallpapers ]] && cp -n wallpapers/* ~/wallpapers/ 2>/dev/null

  echo '#!/bin/bash
pkill quickshell; nohup quickshell &>/dev/null &' > ~/.local/bin/start-quickshell.sh
  chmod +x ~/.local/bin/start-quickshell.sh

  chmod +x ~/.config/scripts/* 2>/dev/null
}

case "$1" in
  deps)
    install_deps
    echo "deps installed"
    ;;
  configs)
    install_configs
    echo "configs installed, log out and back in"
    ;;
  *)
    echo "first time? [y/n]"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      install_deps
      install_configs
      echo ""
      echo "done, log out and back in"
      echo "then run: ~/.config/scripts/random-wallpaper.sh"
      echo "THANK YOU FOR INSTALLING :)"
    else
      install_configs
      echo ""
      echo "configs updated, log out and back in"
    fi
    ;;
esac