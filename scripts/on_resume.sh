#!/bin/sh
# /storage/.config/scripts/on_resume.sh script runs when system is resumed from suspend

. $HOME/.profile
. ${SCRIPTS_PATH:-.}/functions.sh

wait_for_network

# trigger home assistant update_entity
curl ${CURL_OPT} -d 'id=media_player.tinkerelec' ${CURL_URL}/update_entity

# get saved wakeup count to determine if woken up by gpio button to turn tv on
if [ -f /tmp/wakeup_btn_count ]; then
  if [ $(cat /sys/devices/platform/gpio-keys/wakeup/wakeup*/active_count) -gt $(cat /tmp/wakeup_btn_count) ]; then
    power_tv "on"
  fi
fi
