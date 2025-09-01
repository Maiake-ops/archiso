#!/bin/bash
# This script adds minimal Calamares configuration and branding to your ISO rootfs.

set -e

# Change this to your ISO rootfs path
AIROOTFS_DIR=~/zori/releng/airootfs

echo "[*] Creating Calamares config directories..."
mkdir -p "$AIROOTFS_DIR/etc/calamares/branding/zori"

echo "[*] Writing settings.conf..."
cat > "$AIROOTFS_DIR/etc/calamares/settings.conf" <<EOF
---
modules-search: /usr/share/calamares/modules
sequence:
  - show:
      - welcome
      - locale
      - keyboard
      - partition
      - users
      - summary
      - install
      - finished
branding: zori
EOF

echo "[*] Writing branding.desc..."
cat > "$AIROOTFS_DIR/etc/calamares/branding/zori/branding.desc" <<EOF
---
name: "Zori OS"
version: "1.0"
windowPlacement: "center"
windowSize: 1024x768
productName: "Zori OS"
shortProductName: "Zori"
EOF

echo "[✓] Calamares configuration and branding added successfully."
