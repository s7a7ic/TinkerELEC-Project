#!/bin/sh

. $HOME/.profile # load user defined environment variables

case $1 in
  power)
    curl ${CURL_OPT} -d state=on ${CURL_URL}/tv
    ;;

  inhibit)
    # load a different keytable to inhibit kodi menu controls
    if [ -e /tmp/remote_alt ]; then
      ir-keytable -c -w /storage/.config/rc_keymaps/samsung_tv_remote.toml
      kodi-send -a "Notification(TV Remote,Full Control,2000)"
      rm /tmp/remote_alt
    else
      ir-keytable -c -w /storage/.config/rc_keymaps/samsung_tv_remote_alt.toml
      kodi-send -a "Notification(TV Remote,Limited Control - Press EXIT,5000)"
      echo "yes" > /tmp/remote_alt
      if [ ! -e /tmp/remote_timer ]; then
        (
          echo "running" > /tmp/remote_timer
          # load default layout after 240 seconds if not already disabled
          sleep 240
          if [ -e /tmp/remote_alt ]; then
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
