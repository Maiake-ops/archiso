#!/bin/bash
# Fully rebuild Zori OS ISO with KDE Plasma, Calamares, default user, extra apps
# Archives old releng with timestamp and creates new one if missing
# Automatically creates ~/zori if missing

set -e

# === CONFIG ===
BASE_DIR=/home/zori/zori
RELENG_DIR="$BASE_DIR/releng"
TEMPLATE_RELENG="$BASE_DIR/releng-template"   # put your template here
OUT_DIR="$BASE_DIR/out"
AIROOTFS_DIR="$RELENG_DIR/airootfs"
CALAMARES_TAG="v3.3.9"
USERNAME="zori"
PASSWORD="password"   # Change this
NUM_CORES=$(nproc)

# Packages to include in the ISO
PACKAGES=("calamares" "plasma" "plasma-wayland-session" "konsole" "firefox" "nano" "dolphin" "kate" "kde-applications")

# === STEP 0: Ensure base Zori folder exists ===
if [ ! -d "$BASE_DIR" ]; then
    echo "[*] Zori base folder not found. Creating $BASE_DIR..."
    mkdir -p "$BASE_DIR"
fi

# === STEP 1: Archive old releng if exists ===
if [ -d "$RELENG_DIR" ]; then
    TIMESTAMP=$(date +%Y.%m.%d-%H%M)
    ARCHIVE_DIR="$BASE_DIR/releng-$TIMESTAMP"
    echo "[*] Archiving old releng to $ARCHIVE_DIR..."
    mv "$RELENG_DIR" "$ARCHIVE_DIR"
fi

# === STEP 2: Prepare releng folder ===
if [ -d "$ARCHIVE_DIR" ]; then
    echo "[*] Using archived releng as base..."
elif [ -d "$TEMPLATE_RELENG" ]; then
    echo "[*] releng not found. Copying template..."
    cp -r "$TEMPLATE_RELENG" "$RELENG_DIR"
else
    echo "[*] No releng or template found. Creating new releng..."
    cp -r /usr/share/archiso/configs/releng ~/zori/
    cd ~/zori/releng

fi

mkdir -p "$OUT_DIR"
mkdir -p "$AIROOTFS_DIR"

# === STEP 4: Build Calamares ===
echo "[*] Cloning Calamares $CALAMARES_TAG..."
git clone --branch "$CALAMARES_TAG" https://github.com/calamares/calamares.git "$BASE_DIR/calamares-src"
mkdir -p "$BASE_DIR/calamares-src/build"
cd "$BASE_DIR/calamares-src/build"
echo "[*] Building Calamares..."
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j"$NUM_CORES"
sudo make install DESTDIR="$AIROOTFS_DIR"

# === STEP 6: Add packages ===
echo "[*] Adding packages..."
for pkg in "${PACKAGES[@]}"; do
    echo "$pkg" >> "$RELENG_DIR/packages.x86_64"
done

# === STEP 7: Add Calamares config & branding ===
echo "[*] Adding Calamares configuration..."
mkdir -p "$AIROOTFS_DIR/etc/calamares/branding/zori"
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

cat > "$AIROOTFS_DIR/etc/calamares/branding/zori/branding.desc" <<EOF
---
name: "Zori OS"
version: "1.0"
windowPlacement: "center"
windowSize: 1024x768
productName: "Zori OS"
shortProductName: "Zori"
EOF

# === STEP 8: Build ISO ===
echo "[*] Building ISO..."
cd "$RELENG_DIR"
sudo mkarchiso -v -o "$OUT_DIR" .

echo "[✓] Zori OS ISO rebuilt successfully!"
echo "ISO location: $OUT_DIR"
if [ -n "$ARCHIVE_DIR" ]; then
    echo "Previous releng archived as: $ARCHIVE_DIR"
fi
