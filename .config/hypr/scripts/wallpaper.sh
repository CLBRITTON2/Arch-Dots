#!/bin/bash
# -----------------------------------------------------
# Set defaults
# -----------------------------------------------------
waypaperrunning="$HOME/.config/wallpapercache/waypaper-running"
blurredwallpaper="$HOME/.config/wallpapercache/blurred_wallpaper.png"
squarewallpaper="$HOME/.config/wallpapercache/square_wallpaper.png"
rasifile="$HOME/.config/wallpapercache/current_wallpaper.rasi"
waypaper_config="$HOME/.config/waypaper/config.ini"
blur="50x30"

# Ensure the script only runs once
if [ -f "$waypaperrunning" ]; then
  echo ":: Another instance is running, exiting"
  exit 1
fi
touch "$waypaperrunning"
echo ":: Lock file created at $waypaperrunning"

# -----------------------------------------------------
# Get selected wallpaper
# -----------------------------------------------------
if [ "$1" = "init" ]; then
  if [ -f "$waypaper_config" ]; then
    wallpaper=$(grep '^wallpaper =' "$waypaper_config" | cut -d '=' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    wallpaper=$(echo "$wallpaper" | sed "s|~|$HOME|")
    echo ":: Init mode, setting wallpaper from config: $wallpaper" | tee -a /tmp/wallpaper_script.log
    waypaper --wallpaper "$wallpaper" # Set wallpaper without GUI
    rm -f "$waypaperrunning"
    echo ":: Lock file removed (init)" | tee -a /tmp/wallpaper_script.log
    exit 0
  else
    echo ":: Error: Waypaper config $waypaper_config not found" | tee -a /tmp/wallpaper_script.log
    rm -f "$waypaperrunning"
    exit 1
  fi
fi

# Use provided argument if given, otherwise read from config.ini
if [ -n "$1" ]; then
  wallpaper="$1"
else
  if [ -f "$waypaper_config" ]; then
    wallpaper=$(grep '^wallpaper =' "$waypaper_config" | cut -d '=' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    wallpaper=$(echo "$wallpaper" | sed "s|~|$HOME|")
  else
    echo ":: Error: Waypaper config $waypaper_config not found" | tee -a /tmp/wallpaper_script.log
    rm -f "$waypaperrunning"
    exit 1
  fi
fi

used_wallpaper="$wallpaper"
echo ":: Processing wallpaper $used_wallpaper" | tee -a /tmp/wallpaper_script.log

# Verify the file exists
if [ ! -f "$used_wallpaper" ]; then
  echo ":: Error: Wallpaper file $used_wallpaper does not exist" | tee -a /tmp/wallpaper_script.log
  rm -f "$waypaperrunning"
  exit 1
fi
# -----------------------------------------------------
# Get wallpaper filename then kill GUI
# -----------------------------------------------------
wallpaperfilename=$(basename "$used_wallpaper")
echo ":: Wallpaper Filename: $wallpaperfilename"
pkill -f "waypaper" 2>/dev/null && echo ":: Closing Waypaper GUI"

# -----------------------------------------------------
# Execute pywal
# -----------------------------------------------------
echo ":: Execute pywal with $used_wallpaper"
wal -q -i "$used_wallpaper"
source "$HOME/.cache/wal/colors.sh"

# -----------------------------------------------------
# Reload Waybar
# -----------------------------------------------------
rm -f "$waypaperrunning"
echo ":: Reloading Waybar"
~/.config/waybar/launch.sh

# -----------------------------------------------------
# Update Pywalfox
# -----------------------------------------------------
if type pywalfox >/dev/null 2>&1; then
  echo ":: Updating Pywalfox"
  pywalfox update
fi

# -----------------------------------------------------
# Update SwayNC
# -----------------------------------------------------
echo ":: Updating SwayNC"
sleep 0.1
swaync-client -rs

# -----------------------------------------------------
# Generate blurred wallpaper
# -----------------------------------------------------
echo ":: Generating blurred wallpaper with blur $blur"
magick "$used_wallpaper" -resize 75% "$blurredwallpaper"
if [ "$blur" != "0x0" ]; then
  magick "$blurredwallpaper" -blur "$blur" "$blurredwallpaper"
  echo ":: Blurred"
fi

# -----------------------------------------------------
# Create rasi file
# -----------------------------------------------------
if [ ! -f "$rasifile" ]; then
  touch "$rasifile"
fi
echo "* { current-image: url(\"$blurredwallpaper\", height); }" >"$rasifile"

# -----------------------------------------------------
# Generate square wallpaper
# -----------------------------------------------------
echo ":: Generating square wallpaper"
magick "$used_wallpaper" -gravity Center -extent 1:1 "$squarewallpaper"

# -----------------------------------------------------
# Cleanup
# -----------------------------------------------------
rm -f "$waypaperrunning"
echo ":: Lock file removed"
echo ":: Wallpaper update complete"
