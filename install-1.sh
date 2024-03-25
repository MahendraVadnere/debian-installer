#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Move wallpaper to Pictures directory
mkdir -p /home/$username/Pictures/wallpapers
cp /home/$username/debian-installer/bg.png /home/$username/Pictures/wallpapers/

# DWM Setup
mkdir -p /home/$username/repos
cd /home/$username/repos/
git clone https://github.com/MahendraVadnere/dwm
cd /home/$username/repos/dwm
cd $builddir

# ditfiles management using stow
cd /home/$username/
git clone https://github.com/MahendraVadnere/dotfiles
cd $builddir

# Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git
cd $builddir

sudo apt autoremove

printf "\e[1;32mDone! you can now reboot.\e[0m\n"
