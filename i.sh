#/usr/bash
sudo pacman -S git base-devel cmake extra-cmake-modules python-yaml kpmcore squashfs-tools rsync plasma konsole kde-application firefox nano sddm
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd
rm -rf yay
yay -S calamares
sudo -i
