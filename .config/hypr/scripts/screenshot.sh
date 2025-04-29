#!/bin/bash
# Based on https://github.com/hyprwm/contrib/blob/main/grimblast/screenshot.sh
# Screenshots will be stored in $HOME by default.
# The screenshot will be moved into the screenshot directory
option_capture_1="Capture Everything"
option_capture_2="Capture Active Display"
option_capture_3="Capture Selection"

# Choose Screenshot Type
type_screenshot_cmd() {
  rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 3 -width 30 -p "Type of screenshot"
}
# Ask for confirmation
type_screenshot_exit() {
  echo -e "$option_capture_1\n$option_capture_2\n$option_capture_3" | type_screenshot_cmd
}

# take shots
takescreenshot() {
  sleep 1
  # Always use copysave as the action
  grimblast --notify copysave "$option_type_screenshot" $NAME
  if [ -f $HOME/$NAME ]; then
    if [ -d $screenshot_folder ]; then
      mv $HOME/$NAME $screenshot_folder/
    fi
  fi
}

# Main execution
selected_type_screenshot="$(type_screenshot_exit)"
if [[ "$selected_type_screenshot" == "$option_capture_1" ]]; then
  option_type_screenshot=screen
  takescreenshot
elif [[ "$selected_type_screenshot" == "$option_capture_2" ]]; then
  option_type_screenshot=output
  takescreenshot
elif [[ "$selected_type_screenshot" == "$option_capture_3" ]]; then
  option_type_screenshot=area
  takescreenshot
fi
