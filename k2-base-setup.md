---
description: K2 Base fresh setup - Fluidd, Moonraker, webcam fix only (no Pro macros)
---

# K2 Base Fresh Setup

Board: CR0CN200400C10 (F021 — K2 Base) / CR0CN200400C10 (F012 — K2 Pro)
Repo folder: `k2-improvements`

## Step 1 — Copy files to printer

Copy the repo and install script to the printer via SCP or USB:

```
Local:   k2-improvements/  (k2-base-install.sh is inside the root)

Printer: /mnt/UDISK/printer_data/k2-improvements/
```

Example via SCP:
```sh
scp -r k2-improvements/ root@<printer-ip>:/mnt/UDISK/printer_data/k2-improvements/
```

## Step 2 — Run the install script

SSH into the printer and run:

```sh
cd /mnt/UDISK/printer_data/k2-improvements
chmod +x k2-base-install.sh
./k2-base-install.sh
```

This will automatically:
- Move root HOME to UDISK (better-root) — disconnects SSH on first run, reconnect and re-run
- Install Entware
- Install: better-init, skip-oem-setup, moonraker, fluidd, webcam-fix
- Board detection and sleep 3 delay already baked into klipper.init
- Restart Klipper

## Step 3 — Upload config files

Upload the following files from `K2/new config/` to `/mnt/UDISK/printer_data/config/` on the printer:
- `gcode_macro.cfg` (contains LED fix: UPDATE_DELAYED_GCODE ID=wait_temp DURATION=0 at start of START_PRINT)
- `motor_control.cfg` (retries: 4)
- `printer.cfg` (verify `# [include custom/main.cfg]` is commented out)

## Step 4 — Verify

Check Fluidd at `http://<printer-ip>:4408`

Verify in Fluidd console:
- No `config_dir is invalid` error
- No key798 motor connection error
- `START_PRINT` uses factory macro (not k2-improvements version)
- Bed mesh adapts to print size (forced_leveling not overridden)

## What this setup gives you

| Feature | Status |
|---|---|
| Fluidd web UI | ✅ Active |
| Moonraker API | ✅ Active |
| Webcam stream (720p/25fps) | ✅ Active |
| Factory START_PRINT macro | ✅ Preserved |
| Factory adaptive bed probing | ✅ Preserved |
| LED stays on at print start | ✅ Fixed |
| key798 motor connection error | ✅ Fixed |
| 5-min heat soak | ❌ Removed |
| screws_tilt_adjust (wrong positions) | ❌ Not installed |
| Pro-specific Z_TILT_ADJUST | ❌ Not installed |
