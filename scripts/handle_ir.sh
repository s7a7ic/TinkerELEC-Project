#!/bin/sh

. $HOME/.profile # load user defined environment variables

[ $1 = "power" ] && curl ${CURL_OPT} -d state=on ${CURL_URL}/tv

if [ $1 = "inhibit" ]; then
  kodi-send -a "Notification(TV Remote,Disabled for 60 Sec.,59000)"
  systemctl stop eventlircd
  sleep 60
  systemctl start eventlircd
  kodi-send -a "Notification(TV Remote,Enabled)"
  # irexec exits after stopping eventlircd and -d arg gives an error, so start in background with &
  irexec /storage/.config/lircrc > /dev/null 2>&1 &
fi
