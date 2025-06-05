# TinkerELEC Project

This is the Documentation of my Project to make the **ASUS Tinker Board S** (Rockchip RK3288) work better running [Kodi](https://kodi.tv) and generally with newer Linux Kernels (>= 6.5). The [Sourcecode](https://github.com/s7a7ic/TinkerELEC) is based on [LibreELEC.tv](https://github.com/LibreELEC/LibreELEC.tv) with patches and changes created by myself or found on the internet.

## Introduction / About

More info soon...

## Features

- Includes package updates from LibreELEC.tv master branch
  - Better compatibility, bug- and security fixes
  - Downgrade of ffmpeg to 6.0.1 due to Kodi 21 hard depency
- Enabled Bluetooth
- Alternative Wireless Driver
- NesPi Case+ support
  - "soft" shutdown / reboot / suspend and wake from suspend with front panel buttons
  - PowerLED control via `/sys/class/leds/led-case` interface
- Disable internal LEDs with [autostart.sh](scripts/autostart.sh) script

## Notes

- Compilation on Debian 11 (bullseye)

**Why Kodi Version 21.2 (Omega)?**
- Version 22 is not released yet - May 2025
- Better addon compatibility (mostly Jellyfin)
