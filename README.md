# TinkerELEC Project

This is the Documentation of my Project to make the **ASUS Tinker Board S** (Rockchip RK3288) work better running [Kodi](https://kodi.tv) and generally with newer Linux Kernels (>= 6.5). The [Sourcecode](https://github.com/s7a7ic/TinkerELEC) is based on [LibreELEC.tv](https://github.com/LibreELEC/LibreELEC.tv) with patches and changes created by myself or found on the internet.

In this repository you can find additional scripts and configurations to use after the installation of TinkerELEC.

## Introduction / About

More info soon...

## Features

* Includes package updates from [LibreELEC](https://github.com/LibreELEC/LibreELEC.tv) master branch
  * Better compatibility, bug- and security fixes
  * Downgrade of ffmpeg to 6.0.1 (now 6.1.2) due to Kodi 21 hard depency
* Enabled Bluetooth
* Alternative Wireless Driver for RTL8723BS
* Enabled Watchdog
* Support for NesPi Case+ Buttons
  * Power: wake and "soft shutdown" when delatching
  * Reset: suspend, wake and reboot on longpress
  * PowerLED control via `/sys/class/leds/led-case` interface
* Disable internal LEDs via [autostart](scripts/autostart.sh) script

## Notes

* Compilation on Debian 11 (bullseye)

**Why Kodi Version 21.2 (Omega)?**
* Version 22 is not released yet - May 2025
* Better addon compatibility (mostly Jellyfin)

## Pictures

![NesPi Case+ 1](pictures/nespi_case_1.jpg)

![NesPi Case+ 1 open](pictures/nespi_case_1_open.jpg)
