#!/bin/sh

# set rtc wakealarm to wake from suspend
WAKE_AT="08:00"

if [ -f /sys/class/rtc/rtc0/wakealarm ]; then
  CURRENT_TIME=$(date +%s)
  WAKE_TIME=$(date +%s -d "$WAKE_AT")

  # update wake time to next day when already passed
  if [ $CURRENT_TIME -gt $WAKE_TIME ]; then
    WAKE_TIME=$(($WAKE_TIME + 24 * 60 * 60))
  fi

  # get configured wake time from system
  WAKE_ALARM=$(cat /sys/class/rtc/rtc0/wakealarm)

  # update wakealarm if empty or already passed
  if [ -z $WAKE_ALARM ] || [ 1$WAKE_ALARM -lt 1$WAKE_TIME ]; then
    echo 0 > /sys/class/rtc/rtc0/wakealarm
    echo $WAKE_TIME > /sys/class/rtc/rtc0/wakealarm
    logger -t rtcwake.sh "rtc: set wakealarm to $(date -d @$WAKE_TIME)"
  fi
fi
