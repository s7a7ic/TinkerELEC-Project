#!/bin/sh
# The on_resume.sh script runs when system is resumed from suspend

. $HOME/.profile # load user defined environment variables
. ${SCRIPTS_PATH:-.}/functions.sh

switch_tv_on="false" # default state

# get saved wakeup count to determine if woken up by rtc or gpio button to turn tv on or not
if [ -e /tmp/wakeup_btn_count ]; then
  if [ $(cat /sys/class/wakeup/wakeup6/active_count) -gt $(cat /tmp/wakeup_btn_count) ]; then
    switch_tv_on="true"
  fi
fi

wait_for_network

# trigger home assistant update_entity
curl ${CURL_OPT} -d 'id=media_player.tinkerelec' ${CURL_URL}/update_entity

# turn tv on
[ $switch_tv_on = "true" ] && curl ${CURL_OPT} -d state=on ${CURL_URL}/tv
