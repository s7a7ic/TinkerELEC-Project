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

## Suspend / Resume Scripts

Run by [/usr/lib/systemd/system-sleep.serial/20-custom-sleep.sh](https://github.com/s7a7ic/TinkerELEC/blob/te-kodi21/packages/mediacenter/kodi/sleep.d.serial/20-custom-sleep.sh)
