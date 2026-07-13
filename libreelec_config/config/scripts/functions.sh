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
  local bt_devices=$(bluetoothctl devices | awk '{print $2}')

  for device_address in $bt_devices; do
    local connection_status=$(bluetoothctl info $device_address | grep "Connected:" | awk '{print $2}')

    if [ "$connection_status" == "yes" ]; then
      logger -t bt-disconnect.sh "Disconnecting from $device_address..."

      bluetoothctl << EOF
      disconnect $device_address
EOF
    fi
  done
}

# wait for network, exit script when network is not reachable after max_tries
wait_for_network() {
  local max_tries=20
  local n=0

  while ! ping -W 1 -c 1 ${PING_HOST} > /dev/null 2>&1;
  do
    n=$(($n + 1))
    [ $n = $max_tries ] && exit 1
    sleep 1
  done
}

power_tv() {
  [ "$1" = "on" ] || [ "$1" = "off" ] && curl ${CURL_OPT} -d "state=$1" ${CURL_URL}/tv
}
