# GPIO Infrared Receiver

To use a GPIO IR Receiver on the Tinker Board S, it has to be defined in the device tree.
I created a patch, which you can find under [packages/tinkerelec/addons/tinkerelec.nespi/patches/](https://github.com/s7a7ic/TinkerELEC/blob/master/packages/tinkerelec/addons/tinkerelec.nespi/patches/dts-rk3288-tinker-ir-receiver.patch) in the TinkerELEC sourcecode.
The patched DTB file with changes for the ir-receiver and the nespi-case buttons can be installed or uninstalled via [Kodi Addon](https://github.com/s7a7ic/TinkerELEC/blob/master/packages/tinkerelec/addons/tinkerelec.nespi).

The IR Receiver I used is the `TSOP31236` and it's connected to GND, 3.3V and PIN 21 on the GPIO header.

## Required Files

- /storage/.config/rc_maps.cfg
- /storage/.config/rc_keymaps/samsung_tv_remote.toml
- /storage/.config/lircrc (for extra functions like running scripts)

> [!NOTE]
> The files are installed by default in TinkerELEC with the ["tinkerelec-config" package](https://github.com/s7a7ic/TinkerELEC/blob/master/packages/tinkerelec/tinkerelec-config) (see the "config" directory).

## Guide on configuration

The `ir-keytable` command is helpful to find out which protocol the tv-remote uses and which ir-codes it sends.

To do this, run the following command and press any button on the tv-remote:

```sh
ir-keytable -c -p all -t
```

If the protocol is "nec/necx" (necx is a variant of nec) then run this command to test for ir-codes:

```sh
ir-keytable -p nec -t
```

Now you can press the buttons you like to map on the ir-remote and note the codes to create a keymap.

For an example, you can look at my [samsung_tv_remote.toml](https://github.com/s7a7ic/TinkerELEC/blob/master/packages/tinkerelec/tinkerelec-config/config/rc_keymaps/samsung_tv_remote.toml) keymap file.
The toml-file needs to be placed under `/storage/.config/rc_keymaps/`.
To load it automatically you need to edit `/storage/.config/rc_maps.cfg`.\
Look into `/storage/.config/rc_maps.cfg.sample` for inspiration or my
[rc_maps.cfg](https://github.com/s7a7ic/TinkerELEC/blob/master/packages/tinkerelec/tinkerelec-config/config/rc_maps.cfg).

> [!TIP]
> The default "GPIO IR Receiver" kernel driver name is `gpio_ir_recv`.

## Override Kodi Keymap

If you wish to override how some buttons are mapped in Kodi, create a `remote_custom.xml` file in `/storage/.kodi/userdata/keymaps/` and restart Kodi.

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

The defaults for remotes under Kodi are defined in these files:

- /usr/share/kodi/system/Lircmap.xml
- /usr/share/kodi/system/keymaps/remote.xml

Also there are some eventlircd remaps for common remotes under `/etc/eventlircd.d/`.

## List of keycodes and other helpful information

- https://pickpj.github.io/keycodes.html
- https://wiki.libreelec.tv/configuration/ir-remotes

## Special Keys via irexec

To call custom functions like running a command or a script, you can use irexec for this.
The mapping of functions to keys is defined in the lircrc file.

irexec can be started as a daemon like so:

```
irexec -d /storage/.config/lircrc
```

I've added it in [autostart.sh](../scripts/autostart.sh) to start automatically on boot.

Example of the lircrc file that I use:
```
begin
  prog = irexec
  button = KEY_F5
  config = /storage/.config/scripts/handle_ir.sh inhibit
end

begin
  prog = irexec
  button = KEY_F6
  config = /storage/.config/scripts/handle_ir.sh power
end
```

More info on irexec:
- https://www.lirc.org/html/irexec.html
- https://linux.die.net/man/1/irexec

### My use for the "Special Keys"

The "MENU" and "TOOLS" buttons of the TV remote are mapped to KEY_F5 and irexec calls the [handle_ir.sh script](../scripts/handle_ir.sh) with the argument "inhibit".
This loads a different keytable with the `ir-keytable` command to prevent the control of Kodi when using the TV's built-in menus.
By pressing the "EXIT" button or after some time, the default keymap is loaded again.

The "POWER" button of the TV remote is mapped to KEY_F6 in the samsung_tv_remote.toml and irexec calls the [handle_ir.sh script](../scripts/handle_ir.sh) with the argument "power".
This sends a curl request to my home automation setup, which turns the power for the TV on (if it's not already powered).

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
