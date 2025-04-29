#!/bin/bash
aur_helper="yay"
echo
# ------------------------------------------------------
# Start Update
# ------------------------------------------------------
echo ":: Update started."

_isInstalled() {
  package="$1"
  check="$($aur_helper -Qs --color always "${package}" | grep "local" | grep "${package} ")"
  if [ -n "${check}" ]; then
    echo 0 #'0' means 'true' in Bash
    return #true
  fi
  echo 1 #'1' means 'false' in Bash
  return #false
}

# Run AUR helper
$aur_helper

# System update and cleanup
echo ":: Performing system update..."
sudo pacman -Syyu

echo ":: Cleaning package cache..."
sudo pacman -Scc

echo ":: Removing orphaned packages..."
if [[ -n "$(pacman -Qdtq)" ]]; then
  sudo pacman -Rns $(pacman -Qdtq)
else
  echo "No orphaned packages found."
fi
echo ":: System cleanup complete!"

# Flatpak update (if installed)
if [[ $(_isInstalled "flatpak") == "0" ]]; then
  flatpak upgrade
fi

notify-send "Update complete"
echo
echo ":: Update complete"
