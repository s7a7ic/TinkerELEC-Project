#!/bin/sh

# Unlike the autostart.sh script the network stack will not be up when the script runs
# and the shutdown.sh script should follow the following template to ensure commands are
# executed during the correct event, i.e. you can run different commands for a reboot event
# to halt event, or put commands outside the case ... esac as a catch-all.

case "$1" in
  halt)
    # your commands here
#    echo "HALT!!!" > /dev/console
    ;;
  poweroff)
    # Normal Shutdown, shutdown -h now
#    echo "POWER OFF" > /dev/console
    ;;
  reboot)
    # your commands here
    ;;
esac

# your commands here (always run on shutdown)
