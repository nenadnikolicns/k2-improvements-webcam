#!/bin/ash

set -e

TMPFILE=$(mktemp)
jq \
    '.user_info.self_test_sw = 0 | .user_info.enableselftest = 0 | .user_info.upgrade_remind = 0 | .user_info.screensaver = 120 | .user_info.time_zone = "UTC+02:00"' \
    /mnt/UDISK/creality/userdata/config/system_config.json \
    > $TMPFILE
mv $TMPFILE /mnt/UDISK/creality/userdata/config/system_config.json
jq . /mnt/UDISK/creality/userdata/config/system_config.json

killall display-server 2>/dev/null || true

PERSIST=/opt/etc/init.d/S99skip-oem-setup
cat > $PERSIST << 'EOF'
#!/bin/ash
# Wait for display-server to finish its init write, then override self_test flags
sleep 8
CONF=/mnt/UDISK/creality/userdata/config/system_config.json
TMPFILE=$(mktemp)
jq '.user_info.self_test_sw = 0 | .user_info.enableselftest = 0 | .user_info.upgrade_remind = 0 | .user_info.screensaver = 120 | .user_info.time_zone = "UTC+02:00"' \
    "$CONF" > "$TMPFILE" && mv "$TMPFILE" "$CONF"
killall display-server 2>/dev/null || true
EOF
chmod +x $PERSIST
