#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

cd
mkdir -p /home/$username/
username=$(id -u -n 1000)
builddir=$(pwd)

mkdir -p /home/$username/Pictures/wallpapers
cp ~/debian-installer/bg.png ~/Pictures/wallpapers/


# DWM Setup
mkdir -p /home/$username/repos
cd /home/$username/repos/
git clone https://github.com/MahendraVadnere/dwm
cd /home/$username/repos/dwm
make clean install
cp dwm.desktop /usr/share/xsessions
cd

# ditfiles management using stow
git clone https://github.com/MahendraVadnere/dotfiles

# Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git
cd

printf "\e[1;32mDone! you can now reboot.\e[0m\n"