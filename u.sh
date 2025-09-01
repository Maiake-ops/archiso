#!/bin/bash
# This script adds a default user to the ISO rootfs to avoid an empty login screen.

set -e

# Change this to your ISO rootfs path
AIROOTFS_DIR=~/zori/releng/airootfs
USERNAME="zori"
PASSWORD="password"   # Change this to whatever password you want

echo "[*] Adding default user '$USERNAME'..."
arch-chroot "$AIROOTFS_DIR" useradd -m -G wheel -s /bin/bash "$USERNAME"
echo "$USERNAME:$PASSWORD" | arch-chroot "$AIROOTFS_DIR" chpasswd

echo "[*] Giving sudo privileges to wheel group..."
echo "%wheel ALL=(ALL) ALL" >> "$AIROOTFS_DIR/etc/sudoers"

echo "[✓] Default user '$USERNAME' added successfully."
