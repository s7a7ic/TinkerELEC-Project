#!/bin/sh
# The on_resume.sh script runs when system is resumed from suspend

. $HOME/.profile
. ${SCRIPTS_PATH:-.}/functions.sh

wait_for_network

# trigger home assistant update_entity
curl ${CURL_OPT} -d 'id=media_player.tinkerelec' ${CURL_URL}/update_entity

# get saved wakeup count to determine if woken up by rtc or gpio button to turn tv on or not
if [ -f /tmp/wakeup_btn_count ]; then
  # the wakeup path for gpio-keys can change, if new devices are attached
  WAKEUP_PATH=$(echo "$(grep -r gpio-keys /sys/class/wakeup/wakeup?/name)" | cut -d "/" -f 5)
  if [ $(cat /sys/class/wakeup/$WAKEUP_PATH/active_count) -gt $(cat /tmp/wakeup_btn_count) ]; then
    power_tv "on"
  fi
fi
