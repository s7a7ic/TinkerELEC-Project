#!/bin/sh

# Turn Off NesPi Case+ Power LED
if [ -f /sys/class/leds/led-case ]; then
  echo "none" > /sys/class/leds/led-case/trigger
fi
