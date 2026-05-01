#!/bin/ash
set -e

SCRIPT_DIR=$(readlink -f $(dirname ${0}))

progress() { echo "#### $* ..."; }

progress "Installing go2rtc and ffmpeg"
opkg install go2rtc ffmpeg

progress "Creating go2rtc config"
cp ${SCRIPT_DIR}/go2rtc.yaml /opt/etc/go2rtc.yaml

progress "Adding webcam to Moonraker config"
PRINTER_IP=$(ip addr | grep -oE 'inet [0-9.]+' | grep -v '127.0.0.1' | head -1 | awk '{print $2}')
mkdir -p ~/printer_data/config/updates
sed "s/PRINTER_IP/${PRINTER_IP}/g" ${SCRIPT_DIR}/moonraker-webcam.cfg \
    > ~/printer_data/config/updates/webcam-c270.cfg
python3 ${SCRIPT_DIR}/../../scripts/moonraker_include.py updates/webcam-c270.cfg

progress "Starting go2rtc"
/opt/etc/init.d/S98go2rtc restart

progress "Restarting Moonraker to register webcam"
/opt/etc/init.d/S56moonraker restart
