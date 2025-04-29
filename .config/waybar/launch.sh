#!/bin/bash

# Kill it
killall waybar
pkill waybar
sleep 0.5

#Start it
waybar &
