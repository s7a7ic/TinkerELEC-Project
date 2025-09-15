# TinkerELEC Scripts

These scripts should be placed under `/storage/.config/scripts`

## Setup scripts

Copy scripts folder to system:
```
scp -r ../scripts root@tinkerelec:~/.config
```

Give them executable permission: `chmod +x /storage/.config/scripts/*.sh`

For libreelec compatibility, ssh into tinkerelec and link scripts:
```
ln -s ~/.config/scripts/autostart.sh ~/.config/autostart.sh
ln -s ~/.config/scripts/autostop.sh ~/.config/autostop.sh
ln -s ~/.config/scripts/shutdown.sh ~/.config/shutdown.sh
```

## Set Environment Variables

add your env settings in /storage/.profile and reboot (see [profile.example](../profile.example))

## Prevent Idle

[prevent_idle](prevent_idle.sh) prevents kodi to run the shutdown function when a network connection is established (ssh, nfs or smb) and between specified times.

## Suspend / Resume Scripts

[on_suspend](on_suspend.sh) runs before system goes into suspend.
- sets RTC Wakealarm and disconnects Bluetooth devices

[on_resume](on_resume.sh) runs after system wakes from suspend.

They are run by [/usr/lib/systemd/system-sleep.serial/20-custom-sleep.sh](https://github.com/s7a7ic/TinkerELEC/blob/master/packages/mediacenter/kodi/sleep.d.serial/20-custom-sleep.sh)

## Handle IR

The [handle_ir](handle_ir.sh) script is run by [lircrc](../ir-receiver/lircrc) when the defined "special" keys are pressed on the TV-Remote.
