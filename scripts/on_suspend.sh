#!/bin/sh

# The on_suspend.sh script runs before system is going into suspend

. ${SCRIPTS_PATH:-.}/functions.sh

if [ -f ${SCRIPTS_PATH:-.}/rtcwake.sh ]; then
  sh ${SCRIPTS_PATH:-.}/rtcwake.sh
fi

# disconnect bluetooth devices
bt_disconnect
