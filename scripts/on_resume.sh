#!/bin/sh

# Turn On NesPi Case+ Power LED
if [ -f /sys/class/leds/led-case ]; then
  echo "default-on" > /sys/class/leds/led-case/trigger
fi
