#!/bin/sh

# disable internal LEDs
echo none > /sys/class/leds/led-0/trigger
echo none > /sys/class/leds/led-1/trigger
echo none > /sys/class/leds/led-2/trigger

if [ -f $HOME/.config/scripts/prevent_idle.sh ]; then
  (
  sh $HOME/.config/scripts/prevent_idle.sh
  )&
fi
