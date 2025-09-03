#!/bin/sh

# returns $status_code and $body or "null" if $status_code is not 200
curlwithcode() {
  local code=0
  local tmpfile; tmpfile=$(mktemp /tmp/curl.XXXXXX)
  body="null"

  status_code=$(curl --connect-timeout 3 --retry 0 -s -w "%{http_code}" -o >(cat >"$tmpfile") "$1") || code="$?"
  [ $status_code = 200 ] && body="$(cat "$tmpfile")"
  rm "$tmpfile"

  return $code
}

# disconnect all bluetooth devices
bt_disconnect() {
  # get all known devices
  bt_devices=$(bluetoothctl devices | awk '{print $2}')

  for device_address in $bt_devices; do
    connection_status=$(bluetoothctl info $device_address | grep "Connected:" | awk '{print $2}')

    if [ "$connection_status" == "yes" ]; then
      logger -t bt-disconnect.sh "Disconnecting from $device_address..."

      bluetoothctl << EOF
      disconnect $device_address
EOF
    fi
  done
}
