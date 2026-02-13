#!/bin/sh

. $HOME/.profile # load user defined environment variables

case $1 in
  power)
    curl ${CURL_OPT} -d state=on ${CURL_URL}/tv
    ;;

  inhibit)
    # load a different keytable to inhibit kodi menu controls
    INHIBIT_TIME=240 # in seconds
    if [ -e /tmp/remote_alt ]; then
      ir-keytable -c -w /storage/.config/rc_keymaps/samsung_tv_remote.toml
      kodi-send -a "Notification(TV Remote,Full Control,2000)"
      rm /tmp/remote_alt
    else
      ir-keytable -c -w /storage/.config/rc_keymaps/samsung_tv_remote_alt.toml
      kodi-send -a "Notification(TV Remote,Limited Control - Press EXIT,${INHIBIT_TIME}000)"
      echo "yes" > /tmp/remote_alt
      if [ ! -e /tmp/remote_timer ]; then
        (
          echo "running" > /tmp/remote_timer
          # load default layout after "INHIBIT_TIME" if not already happend by pressing EXIT
          sleep ${INHIBIT_TIME}
          if [ -e /tmp/remote_alt ]; then
            sleep 1
            ir-keytable -c -w /storage/.config/rc_keymaps/samsung_tv_remote.toml
            kodi-send -a "Notification(TV Remote,Full Control,2000)"
            rm /tmp/remote_alt
          fi
          rm /tmp/remote_timer
        )&
      fi
    fi
    ;;
esac
