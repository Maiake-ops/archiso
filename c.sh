#!/bin/bash
# Configure Calamares for Zori OS (Arch-based)

set -e
AIROOT="airootfs/etc/calamares"

echo "[*] Setting up Calamares config for Zori OS..."
mkdir -p "$AIROOT"

# Copy sample configs if not exist
if [ ! -f "$AIROOT/settings.conf" ]; then
cat > "$AIROOT/settings.conf" <<EOF
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
fi

# Branding folder
mkdir -p "$AIROOT/branding/zori"
cat > "$AIROOT/branding/zori/branding.desc" <<EOF
---
name: "Zori OS"
version: "1.0"
welcomeStyle: "banner"
windowPlacement: "center"
windowSize: 1024x768
productName: "Zori OS"
shortProductName: "Zori"
EOF

echo "[*] Calamares config ready at $AIROOT"
