# GPIO Infrared Receiver

To use a GPIO IR Receiver on the Tinker Board S, it has to be defined in the device tree.
I created a patch, which you can find under [packages/tinkerelec/addons/tinkerelec.nespi/patches/](https://github.com/s7a7ic/TinkerELEC/blob/master/packages/tinkerelec/addons/tinkerelec.nespi/patches/dts-rk3288-tinker-ir-receiver.patch) in the TinkerELEC sourcecode.

The IR Receiver I used is the `TSOP31236` and it's connected to GND, 3.3V and PIN 21 on the GPIO header.

## Required Files

- /storage/.config/rc_maps.cfg
- /storage/.config/rc_keymaps/samsung_tv_remote.toml
- /storage/.config/lircrc (for extra functions like running scripts)

The files are installed by default with the ["tinkerelec-config" package](https://github.com/s7a7ic/TinkerELEC/blob/master/packages/tinkerelec/tinkerelec-config) (see the "config" directory).

## Guide on configuration

The `ir-keytable` command is used to find out which protocol the tv-remote uses and which ir-codes it sends.

To do this, run the following command and press any button on the tv-remote:

```sh
ir-keytable -c -p all -t
```

If the protocol is "nec/necx" (necx is a variant of nec) then run this command to test for ir-codes:

```sh
ir-keytable -p nec -t
```

Now you can press the buttons you like to map on the ir-remote and note the codes to create a keymap.

For an example, you can look at the [`samsung_tv_remote.toml` keymap file](https://github.com/s7a7ic/TinkerELEC/blob/master/packages/tinkerelec/tinkerelec-config/config/rc_keymaps/samsung_tv_remote.toml).

The toml-file needs to be placed under `/storage/.config/rc_keymaps/`.

To load it automatically you need to edit `/storage/.config/rc_maps.cfg`. Look into rc_maps.cfg.sample for inspiration.

The default "GPIO IR Receiver" kernel driver name is `gpio_ir_recv`.

## Overwrite kodi keymapping

If you wish to override how some button is mapped in kodi, create a remote.xml file in `/storage/.kodi/userdata/keymaps/` and restart kodi.

Example override of KEY_GREEN:
```xml
<keymap>
  <global>
    <remote>
      <green>FullScreen</green>
    </remote>
  </global>
</keymap>
```

The defaults for remotes under kodi are defined in these files:

- /usr/share/kodi/system/Lircmap.xml
- /usr/share/kodi/system/keymaps/remote.xml

## List of Keycodes

- https://pickpj.github.io/keycodes.html

## Special Keys via irexec

TODO: describe lircrc file for custom scripts

## Other (old script): inhibit kodi ir-remote controls temporarily

```sh
kodi-send -a "Notification(TV Remote,Disabled for 60 Sec.,59000)"
systemctl stop eventlircd
sleep 60
systemctl start eventlircd
kodi-send -a "Notification(TV Remote,Enabled)"
# irexec exits after stopping eventlircd and -d arg gives an error, so restart in background with &
irexec /storage/.config/lircrc > /dev/null 2>&1 &
```
