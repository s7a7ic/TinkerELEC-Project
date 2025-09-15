# Infrared Receiver

To use a GPIO IR Receiver on the Tinker Board S, it has to be defined in the device tree.
For the default device tree I created [this patch](dts-rk3288-tinker-ir-receiver.patch), which you can find under [projects/Rockchip/patches/linux/nespi-case/](https://github.com/s7a7ic/TinkerELEC/blob/master/projects/Rockchip/patches/linux/nespi-case/) in the TinkerELEC sourcecode.

The IR sensor used for this project is the TSOP31236 and it's connected to GND, 3.3V and PIN 21.

## Required Files

- /storage/.config/[rc_maps.cfg](rc_maps.cfg)
- /storage/.config/[lircrc](lircrc)
- /storage/.config/rc_keymaps/[samsung_tv_remote.toml](samsung_tv_remote.toml)

## Guide on configuration

The `ir-keytable` command is used to find out which protocol the ir-remote uses and which ir-codes are send.

Run the following command to find out which protocol the ir-remote uses and press any key on the ir-remote:

`ir-keytable -c -p all -t`

If its "nec/necx" (necx is a variant of nec) then run this command to test for inputs:

`ir-keytable -p nec -t`

Now you can press the keys you like to map on the ir-remote and note the codes to create a keymap.

Here is the keymap which I use for my TV-Remote on TinkerELEC: [samsung_tv_remote.toml](samsung_tv_remote.toml)

The file needs to be placed under `/storage/.config/rc_keymaps/`.

To load it automaticaly you need to edit `/storage/.config/rc_maps.cfg`. Look into rc_maps.cfg.sample for inspiration.

The default "GPIO IR Receiver" kernel driver name is `gpio_ir_recv`.

The file I use: [rc_maps.cfg](rc_maps.cfg)

## List of Keycodes

- https://pickpj.github.io/keycodes.html
