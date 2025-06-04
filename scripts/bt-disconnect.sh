#!/bin/sh

# all known devices
bt_devices=$(bluetoothctl devices | awk '{print $2}')

for device_address in $bt_devices; do
  # get the connection status of the device
  connection_status=$(bluetoothctl info $device_address | grep "Connected:" | awk '{print $2}')

  if [ "$connection_status" == "yes" ]; then
    status="connected"
  else
    status="disconnected"
  fi

  echo "Device $device_address is currently $status"

# if the device is connected, disconnect it
  if [ "$connection_status" == "yes" ]; then
    echo "Disconnecting from $device_address..."
    status="disconnected"
    bluetoothctl << EOF
    disconnect $device_address
EOF
  fi

  echo "Device $device_address is now $status"
done
