#!/bin/sh

# This script is started by autostart.sh and runs in background.
# It prevents kodi to run the shutdown function (shutdown or suspend) when a
# network connection is established (ssh, nfs or smb) and between specified times.
# The shutdown function of kodi can be configured under System / Power saving.

IDLE_SHUTDOWN_ALLOWED_LAST_STATE=-1

# inhibit idle shutdown between hours
ENABLE_TIME=1

TIME_1_FROM=$(date +%s -d "06:00")
TIME_1_UNTIL=$(date +%s -d "10:30")

TIME_2_FROM=$(date +%s -d "20:00")
TIME_2_UNTIL=$(date +%s -d "23:50")

while true
do
  KODI_RUNNING=`ps -A | grep kodi.bin | grep -v grep | wc -l`
  if [ $KODI_RUNNING == 1 ] ; then
    SSH_ACTIVE=`netstat -tnpa | grep 'tcp.*:22.*ESTABLISHED.*' | wc -l`
    NFS_ACTIVE=`netstat -tnpa | grep 'tcp.*:111.*ESTABLISHED.*' | wc -l`
    SMB_ACTIVE=`netstat -tnpa | grep 'tcp.*:445.*ESTABLISHED.*' | wc -l`
    [ $SSH_ACTIVE -gt 0 -o $NFS_ACTIVE -gt 0 -o $SMB_ACTIVE -gt 0 ] && IDLE_SHUTDOWN_ALLOWED=0 || IDLE_SHUTDOWN_ALLOWED=1

    if [ $ENABLE_TIME == 1 ]; then
      CURRENT_TIME=$(date +%s)
      [ $CURRENT_TIME -gt $TIME_1_FROM -a $CURRENT_TIME -lt $TIME_1_UNTIL ] && IDLE_SHUTDOWN_ALLOWED=0
      [ $CURRENT_TIME -gt $TIME_2_FROM -a $CURRENT_TIME -lt $TIME_2_UNTIL ] && IDLE_SHUTDOWN_ALLOWED=0
    fi

    if [ $IDLE_SHUTDOWN_ALLOWED_LAST_STATE != $IDLE_SHUTDOWN_ALLOWED ] ; then
      IDLE_SHUTDOWN_ALLOWED_LAST_STATE=$IDLE_SHUTDOWN_ALLOWED
      if [ $IDLE_SHUTDOWN_ALLOWED == 1 ] ; then
        kodi-send --action="InhibitIdleShutdown(false)"
      else
        kodi-send --action="InhibitIdleShutdown(true)"
      fi
    fi
  fi
  sleep 60
done
