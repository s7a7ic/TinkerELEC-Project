#!/bin/sh
# The on_suspend.sh script runs before system is going into suspend

. $HOME/.profile # load user defined environment variables
. ${SCRIPTS_PATH:-.}/functions.sh

# BUG: stop kodi playback to prevent playback on resume (does not work, patched out RestorePlayerState() in kodi)
#kodi-send --action=stop

# save wakeup count
#cat /sys/class/wakeup/wakeup1/active_count > /tmp/wakeup_rtc_count # rtc
cat /sys/class/wakeup/wakeup6/active_count > /tmp/wakeup_btn_count # gpio button

WAKE_AT=${WAKE_AT:-"08:00"} # always wake system up at this time

if [ -f /sys/class/rtc/rtc0/wakealarm ]; then
  CURRENT_TIME=$(date +%s) # current epoch time
  WAKE_TIME=$(date +%s -d "$WAKE_AT") # convert to epoch time

  # update wake time to next day when already passed
  if [ $CURRENT_TIME -gt $WAKE_TIME ]; then
    WAKE_TIME=$(($WAKE_TIME + 24 * 60 * 60))
  fi

  # get home-assistant next wake alert time
  curlwithcode ${CURL_URL}/wake_time
  if [ "$body" != "null" ] && [ "$body" != "off" ]; then
    body=$(($body - 60)) # minus one minute to let system fully start up
    # if wake time is before default wake, then use it
    [ "$body" -lt "$WAKE_TIME" ] && WAKE_TIME="$body"
  fi

  # get configured wake time from system
  WAKE_ALARM=$(cat /sys/class/rtc/rtc0/wakealarm)

  # update wakealarm if empty or different (check with `cat /proc/driver/rtc`)
  if [ -z $WAKE_ALARM ] || [ 1$WAKE_ALARM != 1$WAKE_TIME ]; then
    echo 0 > /sys/class/rtc/rtc0/wakealarm
    echo $WAKE_TIME > /sys/class/rtc/rtc0/wakealarm
    logger -t rtcwake.sh "rtc: set wakealarm to $(date -d @$WAKE_TIME)"
  fi
fi

# disconnect bluetooth devices
bt_disconnect

# turn tv off
curl ${CURL_OPT} -d 'state=off' ${CURL_URL}/tv
