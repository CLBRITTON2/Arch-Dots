#!/bin/bash
# -----------------------------------------------------
# Display keybindings from .config/hypr/conf/keybinding.conf
# -----------------------------------------------------
config_file="$HOME/.config/hypr/conf/keybinding.conf"

echo "Reading from: $config_file"

# Process the keybindings and pipe directly to rofi
awk -F'[=#]' '
    $1 ~ /^bind/ {
        # Replace the string "$mainMod" with "SUPER"
        gsub(/\$mainMod/, "SUPER", $0)
        # Remove "bind" or "bindm" and extra spaces
        gsub(/^bind[[:space:]]*=+[[:space:]]*/,"", $0)
        gsub(/^bindm[[:space:]]*=+[[:space:]]*/,"", $0)
        # Split the keybinding part using a comma
        split($1, kbarr, ",")
        # Ensure the command field ($2) exists and is not empty
        if (length(kbarr) >= 2 && $2 ~ /[[:alnum:]]/) {
            # Clean up extra spaces in the command
            cmd = $2
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", cmd)
            # Format keybinding and command
            print kbarr[1] "  +  " kbarr[2] "\t" cmd
        }
    }
' "$config_file" | rofi -dmenu -i -markup -p "Keybinds" -config ~/.config/rofi/config-compact.rasi
