# GPIO Infrared Receiver

To use a GPIO IR Receiver on the Tinker Board S, it has to be defined in the device tree.
I created a patch, which you can find under [packages/tinkerelec/addons/tinkerelec.nespi/patches/](https://github.com/s7a7ic/TinkerELEC/blob/master/packages/tinkerelec/addons/tinkerelec.nespi/patches/dts-rk3288-tinker-ir-receiver.patch) in the TinkerELEC sourcecode.

The IR Receiver I used is the `TSOP31236` and it's connected to GND, 3.3V and PIN 21 on the GPIO header.

## Required Files

- /storage/.config/rc_maps.cfg
- /storage/.config/lircrc
- /storage/.config/rc_keymaps/samsung_tv_remote.toml

The files are installed by default with the ["tinkerelec-config" package](https://github.com/s7a7ic/TinkerELEC/blob/master/packages/tinkerelec/tinkerelec-config) (see the "config" directory).

## Guide on configuration

The `ir-keytable` command is used to find out which protocol the ir-remote uses and which ir-codes are send.

Run the following command to find out which protocol the ir-remote uses and press any key on the ir-remote:

`ir-keytable -c -p all -t`

If its "nec/necx" (necx is a variant of nec) then run this command to test for inputs:

`ir-keytable -p nec -t`

Now you can press the keys you like to map on the ir-remote and note the codes to create a keymap.

For an example, you can look at the `samsung_tv_remote.toml` keyfile.

The keymap toml-file needs to be placed under `/storage/.config/rc_keymaps/`.

To load it automaticaly you need to edit `/storage/.config/rc_maps.cfg`. Look into rc_maps.cfg.sample for inspiration.

The default "GPIO IR Receiver" kernel driver name is `gpio_ir_recv`.

## Overwrite kodi keymapping

If you wish to override how some button is mapped in kodi, create a remote.xml file in `/storage/.kodi/userdata/keymaps/` and restart kodi.

Example override of KEY_GREEN:
```
<keymap>
  <global>
    <remote>
      <green>FullScreen</green>
    </remote>
  </global>
</keymap>
```

## List of Keycodes

- https://pickpj.github.io/keycodes.html

## Special Keys via irexec

TODO: describe lircrc file for custom scripts

## Other (old script): inhibit kodi ir-remote controls temporarily

```
kodi-send -a "Notification(TV Remote,Disabled for 60 Sec.,59000)"
systemctl stop eventlircd
sleep 60
systemctl start eventlircd
kodi-send -a "Notification(TV Remote,Enabled)"
# irexec exits after stopping eventlircd and -d arg gives an error, so restart in background with &
irexec /storage/.config/lircrc > /dev/null 2>&1 &
```
