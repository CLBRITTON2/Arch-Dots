#!/bin/bash
echo ":: Update started."

# System update and cleanup
sudo pacman -Syu

echo ":: Cleaning package cache..."
sudo pacman -Scc --noconfirm

echo ":: Removing orphaned packages..."
orphans=$(pacman -Qdtq)
if [[ -n "$orphans" ]]; then
  sudo pacman -Rns "$orphans"
else
  echo "No orphaned packages found."
fi

# Run AUR helper
echo ":: Updating AUR packages..."
yay

# Flatpak update
echo ":: Updating Flatpak packages..."
flatpak upgrade

notify-send "System update complete"
echo ":: Update complete"
