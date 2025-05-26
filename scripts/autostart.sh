#!/bin/sh

# disable internal LEDs
echo none > /sys/class/leds/led-0/trigger
echo none > /sys/class/leds/led-1/trigger
echo none > /sys/class/leds/led-2/trigger

(
/usr/bin/bash $HOME/.config/prevent_idle.sh
)&
