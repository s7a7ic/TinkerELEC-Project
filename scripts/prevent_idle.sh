#!/bin/sh

# This script is started by autostart.sh and runs in background.
# It prevents kodi to run the shutdown function (shutdown or suspend) when a
# network connection is established (ssh, nfs or smb) and between specified times.
# The shutdown function of kodi can be configured under "System / Power Saving".

ENABLE_NET=1 # prevent on ssh, nfs or smb activity

# time configuration
TIME_1_ENABLED=1
TIME_1_FROM="06:00"
TIME_1_UNTIL="10:00"

TIME_2_ENABLED=0
TIME_2_FROM="16:00"
TIME_2_UNTIL="18:00"

TIME_3_ENABLED=1
TIME_3_FROM="22:00"
TIME_3_UNTIL="23:59"

IDLE_SHUTDOWN_ALLOWED_LAST_STATE=-1

while true; do
  KODI_RUNNING=`ps -A | grep kodi.bin | grep -v grep | wc -l`
  if [ $KODI_RUNNING == 1 ]; then
    IDLE_SHUTDOWN_ALLOWED=1 # default state

    if [ $ENABLE_NET == 1 ]; then
      SSH_ACTIVE=`netstat -tnpa | grep 'tcp.*:22.*ESTABLISHED.*' | wc -l`
      NFS_ACTIVE=`netstat -tnpa | grep 'tcp.*:111.*ESTABLISHED.*' | wc -l`
      SMB_ACTIVE=`netstat -tnpa | grep 'tcp.*:445.*ESTABLISHED.*' | wc -l`
      [ $SSH_ACTIVE -gt 0 -o $NFS_ACTIVE -gt 0 -o $SMB_ACTIVE -gt 0 ] && IDLE_SHUTDOWN_ALLOWED=0 && TYPE="NETWORK"
    fi

    CURRENT_TIME=$(date +%s)

    # some busybox sh loop magic
    for index in 1 2 3; do
      if [ $(eval echo \$TIME_$index\_ENABLED) == 1 ]; then
        time_from=$(date +%s -d $(eval echo \$TIME_$index\_FROM))
        time_until=$(date +%s -d $(eval echo \$TIME_$index\_UNTIL))
        [ $CURRENT_TIME -gt $time_from -a $CURRENT_TIME -lt $time_until ] && IDLE_SHUTDOWN_ALLOWED=0 && TYPE="TIME_$index"
      fi
    done

    if [ $IDLE_SHUTDOWN_ALLOWED_LAST_STATE != $IDLE_SHUTDOWN_ALLOWED ]; then
      IDLE_SHUTDOWN_ALLOWED_LAST_STATE=$IDLE_SHUTDOWN_ALLOWED
      if [ $IDLE_SHUTDOWN_ALLOWED == 1 ]; then
        kodi-send --action="InhibitIdleShutdown(false)"
      else
        kodi-send --action="InhibitIdleShutdown(true)"
        logger -t prevent_idle.sh "Prevent Idle Shutdown ($TYPE)"
      fi
    fi
  fi
  sleep 60
done
