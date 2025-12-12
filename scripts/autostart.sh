#!/bin/sh
# The autostart.sh script runs on system boot

. $HOME/.profile # load user defined environment variables
. ${SCRIPTS_PATH:-.}/functions.sh

# disable internal LEDs
echo none > /sys/class/leds/led-0/trigger
echo none > /sys/class/leds/led-1/trigger
echo none > /sys/class/leds/led-2/trigger

# wait for kodi to start in background
(
  KODI_RUNNING=0
  while [ $KODI_RUNNING -ne 1 ]; do
    KODI_RUNNING=`ps -A | grep kodi.bin | grep -v grep | wc -l`
    if [ $KODI_RUNNING -eq 1 ]; then
      sleep 10
      # pipewire low volume workarround (kodi needs to be running)
      wpctl set-volume @DEFAULT_AUDIO_SINK@ 100%
      break
    fi
    sleep 5
  done
)&

# run prevent_idle in background
if [ -f ${SCRIPTS_PATH:-.}/prevent_idle.sh ]; then
  (
  sh ${SCRIPTS_PATH:-.}/prevent_idle.sh
  )&
fi

# run irexec for scripts via ir-remote
[ -f /storage/.config/lircrc ] && irexec -d /storage/.config/lircrc

wait_for_network

# turn tv on
curl ${CURL_OPT} -d 'state=on' ${CURL_URL}/tv
