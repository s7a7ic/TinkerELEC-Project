#!/bin/sh

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
