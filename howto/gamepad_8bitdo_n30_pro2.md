# TinkerELEC 8BitDo N30 Pro 2 Gamepad Configuration

I'm using the **8BitDo N30 Pro 2 bluetooth gamepad** in Kodi mostly for retro gaming.

The gamepad can be used in different modes by holding a letter button (A, B, X, Y) and turning it on by pressing the START button.

- X + START -> xinput
- B + START -> dinput (**I'm using this mode**)
- A + START -> macOS (Kodi detects it as "PlayStation DualShock 2" by the name "Wireless Controller")
- Y + START -> switch (for use on Nintendo Switch)

> [!NOTE]
> To turn the gamepad OFF just hold the START button for some seconds.

## Kodi Joystick Buttonmap

The default buttonmap files are under `/usr/share/kodi/addons/peripheral.joystick/resources/buttonmaps/xml/linux/`.

For editing purposes or changes, a buttonmap file needs to be added into this folder:

```
/storage/.kodi/userdata/addon_data/peripheral.joystick/resources/buttonmaps/xml/linux
```

> [!NOTE]
> The N30 Pro 2 buttonmaps are installed by default in TinkerELEC with the ["tinkerelec-config" package](https://github.com/s7a7ic/TinkerELEC/blob/master/packages/tinkerelec/tinkerelec-config) (see the "files" directory).

- [N30 Pro 2 dinput buttonmap](https://github.com/s7a7ic/TinkerELEC/blob/master/packages/tinkerelec/tinkerelec-config/files/8BitDo_N30_Pro_2_16b_8a.xml)
- [N30 Pro 2 xinput buttonmap](https://github.com/s7a7ic/TinkerELEC/blob/master/packages/tinkerelec/tinkerelec-config/files/8BitDo_N30_Pro_2_10b_8a.xml)

## Prevent Kodi from opening menus when turning the gamepad off

To prevent Kodi opening "Info" or "PlayerControls" when you want to turn the gamepad off (longpress), the default actions from the file `/usr/share/kodi/system/keymaps/joystick.xml` need to be overridden.

Create the following `joystick_custom.xml` file under `/storage/.kodi/userdata/keymaps/` and restart Kodi.

```xml
<!-- prevent action on START button for longpress, when turning gamepad off -->
<keymap>
  <global>
    <joystick profile="game.controller.default">
      <start>ActivateWindow(PlayerControls)</start>
      <start holdtime="500">noop</start>
    </joystick>
  </global>
  <FullscreenVideo>
    <joystick profile="game.controller.default">
      <start>Info</start>
      <start holdtime="500">noop</start>
    </joystick>
  </FullscreenVideo>
  <FullscreenLiveTV>
    <joystick profile="game.controller.default">
      <start>Info</start>
      <start holdtime="500">noop</start>
    </joystick>
  </FullscreenLiveTV>
  <FullscreenRadio>
    <joystick profile="game.controller.default">
      <start>Info</start>
      <start holdtime="500">noop</start>
    </joystick>
  </FullscreenRadio>
  <Visualisation>
    <joystick profile="game.controller.default">
      <start>Info</start>
      <start holdtime="500">noop</start>
    </joystick>
  </Visualisation>
</keymap>
```
