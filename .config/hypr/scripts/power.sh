#!/bin/bash

if [[ "$1" == "exit" ]]; then
  echo ":: Exit"
  sleep 1
  hyprctl dispatch exit
fi

if [[ "$1" == "lock" ]]; then
  echo ":: Lock"
  sleep 0.5
  hyprlock
fi

if [[ "$1" == "reboot" ]]; then
  echo ":: Reboot"
  sleep 0.5
  systemctl reboot
fi

if [[ "$1" == "shutdown" ]]; then
  echo ":: Shutdown"
  sleep 0.5
  systemctl poweroff
fi

if [[ "$1" == "suspend" ]]; then
  echo ":: Suspend"
  sleep 0.5
  systemctl suspend
fi
