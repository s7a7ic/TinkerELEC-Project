#!/bin/sh

IDLE_SHUTDOWN_ALLOWED_LAST_STATE=-1

while true
do
  KODI_RUNNING=`ps -A | grep kodi.bin | grep -v grep | wc -l`
  if [ 1 == $KODI_RUNNING ] ; then
    SSH_ACTIVE=`netstat -tnpa | grep 'tcp.*:22.*ESTABLISHED.*' | wc -l`
    NFS_ACTIVE=`netstat -tnpa | grep 'tcp.*:111.*ESTABLISHED.*' | wc -l`
    SMB_ACTIVE=`netstat -tnpa | grep 'tcp.*:445.*ESTABLISHED.*' | wc -l`
    [ $SSH_ACTIVE -gt 0 -o $NFS_ACTIVE -gt 0 -o $SMB_ACTIVE -gt 0 ] && IDLE_SHUTDOWN_ALLOWED=1 || IDLE_SHUTDOWN_ALLOWED=0
      if [ $IDLE_SHUTDOWN_ALLOWED_LAST_STATE != $IDLE_SHUTDOWN_ALLOWED ] ; then
        IDLE_SHUTDOWN_ALLOWED_LAST_STATE=$IDLE_SHUTDOWN_ALLOWED
        if [ 0 == $IDLE_SHUTDOWN_ALLOWED ] ; then
          kodi-send --action="InhibitIdleShutdown(false)"
        else
          kodi-send --action="InhibitIdleShutdown(true)"
        fi
      fi
  fi
  sleep 60
done
