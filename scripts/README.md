# TinkerELEC Scripts

These scripts should be placed under `/storage/.config/scripts`

Give them executable permission: `chmod +x /storage/.config/scripts/*.sh`

## Setup scripts

```
# copy scripts folder
scp -r ../scripts root@tinkerelec:~/.config

# ssh to tinkerelec and link scripts (for libreelec compatibility)
ln -s ~/.config/scripts/autostart.sh ~/.config/autostart.sh
ln -s ~/.config/scripts/autostop.sh ~/.config/autostop.sh
ln -s ~/.config/scripts/shutdown.sh ~/.config/shutdown.sh
```

## Bluetooth disconnect

[bt-disconnect](bt-disconnect.sh) is disconnecting currently connected Bluetooth Devices. It is called from the on_suspend script.

## Prevent Idle

[prevent_idle](prevent_idle.sh) prevents kodi to run the shutdown function when a network connection is established (ssh, nfs or smb) and between specified times.

## RTC Wakealarm

[rtcwake](rtcwake.sh) configures /sys/class/rtc/rtc0/wakealarm to wake the system on a specified time (timezone aware). It is called from the on_suspend script.

## Suspend / Resume Scripts

[on_suspend](on_suspend.sh) runs before system goes into suspend.

[on_resume](on_resume.sh) runs after system wakes from suspend.

They are run by [/usr/lib/systemd/system-sleep.serial/20-custom-sleep.sh](https://github.com/s7a7ic/TinkerELEC/blob/te-kodi21/packages/mediacenter/kodi/sleep.d.serial/20-custom-sleep.sh)
