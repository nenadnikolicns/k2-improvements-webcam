# K2 Plus Improvements Script Maintainers Fork

CampbellFab has archived his repo, I'm not using the cartographer and thereby will the logic for it be omitted for now. The main functionality will be upstream Moonraker and Fluidd which support webcam in the UI interface as well as use of the k2-improvements for better init/root functionalities.

Most of the underlying features such as Fluidd and Moonraker are being maintained and updated by [Jacob10383](https://github.com/Jacob10383)
* This Fork implements other features such as stock webcam improvements and optional USB webcam support(I'm using Logi C270).

In the `features` folder you will find install scripts for each of the features being installed, if desired to run separately.


## DISCLAIMER

Use at your own risk, I'm not responsible for fires or broken dreams.  But you do get to keep both halves if something breaks.


Additionally, root is enabled by default with the password: 'creality_2024'.

It is recommend to perform a factory reset prior to install to avoid potential conflicts with previous modifications.  
A factory reset can be achieved with the following command in a terminal on the K2:

```raw
echo "all" | /usr/bin/nc -U /var/run/wipe.sock
```


## Install procedure - Need to run the script TWICE

Reset your printer and stop at the calibration prompt(you can do this later - save some time), copy the files to the /mnt/UDISK/printer_data folder(using WinSCP or scp command) and give execute permissions to the k2-base-install.sh script, everything after this is automated.

1. The script will install entware tools necessary to accomplish the installs, first run will also check if the better-root structure is made and if not will make it after which a disconnect will follow.
2. The second execution of the script will then install all the resources needed for the cam fix (Moonraker, Fluidd and better-init).
3. If another camera is connected it will install the necessary components so that it also will be detected by Fluidd, if not it will skip the process.


## Chamber Camera (webcam-fix)
The stock chamber camera is set to 15fps by default. `v4l2-ctl --list-formats-ext -d /dev/v4l/by-id/main-video0` reports 30fps as available. 
This fork sets it to 25fps — good enough for me and this way we are not pushing the limit if for any reason the cam cant handle it properly.


## Features

* [better-init](./features/better-init/README.md) — replaces factory init scripts, enables Fluidd service control
* [better-root](./features/better-root/README.md) — moves root home directory to UDISK (required for Moonraker install)
* [Entware](https://github.com/Entware/Entware) — package manager prerequisite
* updated [Fluidd](./features/fluidd/README.md) — web UI
* updated [Moonraker](./features/moonraker/README.md) — API layer
* skip-oem-setup — disables OEM setup wizard on boot
* [webcam-fix](./features/webcam-fix/) — sets chamber camera to 720p/25fps
* [webcam-usb](./features/webcam-usb/) — optional USB webcam support via go2rtc (auto-detected on `/dev/video2`)
  * go2rtc runs on port `1984`, stream available at `http://PRINTER_IP:1984`
  * After install, update `PRINTER_IP` in `features/webcam-usb/moonraker-webcam.cfg` with your printer's IP address


## Credits

* [@CampbellFabrications](https://github.com/CampbellFabrications/k2-improvements) - Direct upstream fork this repo is based on
* [@jamincollins](https://github.com/jamincollins) - The Guy who made the original k2-improvements project
* [@Jacob10383](https://github.com/Jacob10383/) - Maintaining upstream Fluidd/Moonraker updates and resonance sweeping changes
* [@Guilouz](https://github.com/Guilouz) - standing on the shoulders of giants
* [@stranula](https://github.com/stranula)
* [@juliosueiras](https://github.com/juliosueiras)

* Moonraker - [https://github.com/Arksine/moonraker](https://github.com/Arksine/moonraker)
* Klipper - [https://github.com/Klipper3d/klipper](https://github.com/Klipper3d/klipper)
* Fluidd - [https://github.com/fluidd-core/fluidd](https://github.com/fluidd-core/fluidd)
* Entware - [https://github.com/Entware/Entware](https://github.com/Entware/Entware)
* Obico - [https://www.obico.io/](https://www.obico.io/)
* KAMP - [https://github.com/kyleisah](https://github.com/kyleisah/Klipper-Adaptive-Meshing-Purging)
* GuppyScreen - [https://github.com/foo](https://github.com/foo/guppyscreen)
* go2rtc - [https://github.com/AlexxIT/go2rtc](https://github.com/AlexxIT/go2rtc)

## FAQ

See the [FAQ](./FAQ.md)
