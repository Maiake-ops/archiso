#!/bin/bash
# Zori OS setup script (Plasma + SDDM, no autologin)

set -e
AIROOT="airootfs/etc"

echo "[*] Forcing graphical.target as default..."
mkdir -p "$AIROOT/systemd/system/default.target.wants"
ln -sf /usr/lib/systemd/system/graphical.target "$AIROOT/systemd/system/default.target"

echo "[*] Enabling SDDM display manager..."
mkdir -p "$AIROOT/systemd/system"
ln -sf /usr/lib/systemd/system/sddm.service "$AIROOT/systemd/system/display-manager.service"

echo "[*] Done! Zori OS ISO will boot to SDDM (login screen)."
