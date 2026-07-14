#!/bin/sh
# /storage/.config/autostart.sh script runs on system boot

. $HOME/.profile
. ${SCRIPTS_PATH:-.}/functions.sh

# disable internal LEDs
echo none | tee /sys/class/leds/led-?/trigger > /dev/null

# enable bfq scheduler for emmc/sdcard
#echo bfq | tee /sys/block/mmcblk?/queue/scheduler > /dev/null

# run prevent_idle in background
[ -f ${SCRIPTS_PATH:-.}/prevent_idle.sh ] && sh ${SCRIPTS_PATH:-.}/prevent_idle.sh &

# run irexec for special keys on ir-remote
[ -f /storage/.config/lircrc ] && irexec -d /storage/.config/lircrc

wait_for_network

# trigger home assistant update_entity
curl ${CURL_OPT} -d 'id=media_player.tinkerelec' ${CURL_URL}/update_entity > /dev/null

power_tv "on"
