# Guide: Kodi with Gamepad (8BitDo N30 Pro 2)

I'm using Kodi with the **8BitDo N30 Pro 2 bluetooth gamepad**.

The gamepad can be used in different modes by holding a letter button (A, B, X, Y) and turning it on by pressing the START button.

- X + START -> xinput
- B + START -> dinput
- A + START -> macOS (Kodi detects it as "PlayStation DualShock 2" by the name "Wireless Controller")
- Y + START -> switch (for use on Nintendo Switch)

I'm using the dinput mode.

> [!NOTE]
> To turn the gamepad OFF just hold the START button.

## Prevent Kodi opening menus when turning the gamepad off

To prevent Kodi opening "Info" or "PlayerControls" when you want to turn the gamepad off but still keep the default actions on a short press, the joystick.xml needs to be modified.

1. Copy system joystick.xml to userdata
`cp /usr/share/kodi/system/keymaps/joystick.xml /storage/.kodi/userdata/keymaps/`

2. Edit the file
`nano /storage/.kodi/userdata/keymaps/joystick.xml`

3. Add <start holdtime="500">noop</start>

under <global>
...
<start>ActivateWindow(PlayerControls)</start>
<start holdtime="500">noop</start>
...

and under <FullscreenVideo>
...
<start>Info</start>
<start holdtime="500">noop</start>
...

## Button Mapping in Kodi

> [!NOTE]
> The buttonmaps are included in TinkerELEC

For editing purposes or on other systems, the linked files need to be added into this folder:
`/storage/.kodi/userdata/addon_data/peripheral.joystick/resources/buttonmaps/xml/linux`

- [N30Pro 2 dinput buttonmap](8BitDo_N30_Pro_2_16b_8a.xml)
- [N30Pro 2 xinput buttonmap](8BitDo_N30_Pro_2_10b_8a.xml)
