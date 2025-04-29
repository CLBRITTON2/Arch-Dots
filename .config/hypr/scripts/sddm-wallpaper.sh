#!/bin/bash
# Use waypaper config for current wallpaper
waypaper_config="$HOME/.config/waypaper/config.ini"
if [ ! -f "$waypaper_config" ]; then
  echo ":: Waypaper config file not found at $waypaper_config"
  exit 1
fi

# Extract the wallpaper path from the config file
wallpaper_path=$(grep "wallpaper =" "$waypaper_config" | cut -d "=" -f2 | xargs)

# Expand the tilde to the HOME directory if present
current_wallpaper=$(echo "$wallpaper_path" | sed "s|^~|$HOME|")
extension="${current_wallpaper##*.}"
sddm_theme_name="sequoia"
sddm_asset_folder="/usr/share/sddm/themes/$sddm_theme_name/backgrounds"

if [ ! -f "$current_wallpaper" ]; then
  echo ":: File $current_wallpaper does not exist"
  sleep 3
  exit 1
fi
echo ":: Setting the current wallpaper $current_wallpaper as SDDM wallpaper."
echo
if [ ! -d /etc/sddm.conf.d/ ]; then
  sudo mkdir /etc/sddm.conf.d
  echo ":: Folder /etc/sddm.conf.d created."
fi

echo ":: File /etc/sddm.conf.d/sddm.conf updated."
sudo cp "$current_wallpaper" "$sddm_asset_folder/current_wallpaper.$extension"
echo ":: Current wallpaper copied into $sddm_asset_folder"

sudo sed -i 's/CURRENTWALLPAPER/'"current_wallpaper.$extension"'/' "/usr/share/sddm/themes/$sddm_theme_name/theme.conf"
echo ":: File theme.conf updated in /usr/share/sddm/themes/$sddm_theme_name/"
echo
echo ":: SDDM wallpaper has been updated."
sleep 3
