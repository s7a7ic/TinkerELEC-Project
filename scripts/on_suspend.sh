#!/bin/sh

# The on_suspend.sh script runs before system is going into suspend

if [ -f $HOME/.config/scripts/rtcwake.sh ]; then
  sh $HOME/.config/scripts/rtcwake.sh
fi

if [ -f $HOME/.config/scripts/bt-disconnect.sh ]; then
  # disconnect bluetooth devices
  sh $HOME/.config/scripts/bt-disconnect.sh
fi
