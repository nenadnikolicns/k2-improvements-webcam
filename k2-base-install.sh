#!/bin/ash
# K2 Base setup script - Fluidd/Moonraker/webcam only, no Pro macros
# Place this file inside the repo at: /mnt/UDISK/printer_data/k2-improvements/
# Run as root from that directory: ./k2-base-install.sh

set -e

SCRIPT_DIR=$(readlink -f $(dirname ${0}))

log()  { echo "### $1"; }
fail() { echo "!!! ERROR: $1"; exit 1; }

# ── Permission checks ────────────────────────────────────────────────────────
log "Checking permissions..."

[ "$(id -u)" = "0" ] || fail "Must be run as root. Try: sudo ./k2-base-install.sh"

[ -d "${SCRIPT_DIR}/features" ] || fail "features/ directory not found. Run this script from inside the repo."
find "${SCRIPT_DIR}" -name "*.sh" -o -name "*.init" | xargs chmod +x

for FEATURE in better-root entware better-init skip-oem-setup moonraker fluidd webcam-fix; do
    INSTALL="${SCRIPT_DIR}/features/${FEATURE}/install.sh"
    [ -f "$INSTALL" ] || fail "Missing: features/${FEATURE}/install.sh (folder name in repo: ${FEATURE})"
done

# ── Better Root (move HOME to UDISK) ─────────────────────────────────────────
if ! grep -qE 'root.*UDISK' /etc/passwd; then
    log "Root home is not on UDISK yet — applying better-root..."
    log "You will be disconnected. Reconnect via SSH and re-run this script to continue."
    ${SCRIPT_DIR}/features/better-root/install.sh
    # SSH session is killed by better-root above — script will not reach here
    exit 0
else
    log "Root home already on UDISK, skipping better-root."
fi

# ── Entware ──────────────────────────────────────────────────────────────────
if [ ! -f /opt/bin/opkg ]; then
    log "Installing Entware..."
    ${SCRIPT_DIR}/features/entware/install.sh
else
    log "Entware already installed, skipping."
fi

[ -f /etc/profile.d/entware.sh ] && source /etc/profile.d/entware.sh
export PATH=/opt/bin:/opt/sbin:$PATH

# ── Features ─────────────────────────────────────────────────────────────────
log "Installing better-init..."
${SCRIPT_DIR}/features/better-init/install.sh

log "Installing skip-oem-setup (disables OEM setup wizard)..."
${SCRIPT_DIR}/features/skip-oem-setup/install.sh

log "Installing moonraker..."
${SCRIPT_DIR}/features/moonraker/install.sh

log "Installing fluidd..."
${SCRIPT_DIR}/features/fluidd/install.sh

log "Installing webcam-fix..."
${SCRIPT_DIR}/features/webcam-fix/install.sh

# ── Optional: USB webcam via go2rtc (auto-detected) ──────────────────────────
if [ -e /dev/video2 ]; then
    log "USB webcam detected at /dev/video2, installing go2rtc..."
    ${SCRIPT_DIR}/features/webcam-usb/install.sh
else
    log "No USB webcam detected, skipping webcam-usb. Run features/webcam-usb/install.sh manually if needed."
fi

# ── Verify patches are present (baked into klipper.init before packaging) ────
log "Verifying klipper.init patches..."
grep -q 'CR0CN200400C10' /etc/init.d/klipper \
    || fail "Board patch missing from /etc/init.d/klipper — was klipper.init pre-patched before packaging?"
grep -q 'sleep 3' /etc/init.d/klipper \
    || fail "Sleep patch missing from /etc/init.d/klipper — was klipper.init pre-patched before packaging?"
log "Patches verified OK."

# ── Restart Klipper ──────────────────────────────────────────────────────────
log "Restarting Klipper..."
/etc/init.d/klipper restart

log "Done. Upload your config files from 'K2/new config/' to /mnt/UDISK/printer_data/config/"
log "Fluidd available at http://$(ip addr | grep -oE 'inet [0-9.]+' | grep -v '127.0.0.1' | head -1 | awk '{print $2}'):4408"
