#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
apt update
apt upgrade -y

# Install nala
apt install nala -y

# Create folders in user directory (eg. Documents,Downloads,etc.)
xdg-user-dirs-update

chown -R $username:$username /home/$username

# Installing Essential Programs 
nala install feh rofi picom thunar lxpolkit x11-xserver-utils unzip wget pipewire wireplumber pavucontrol sxhkd -y
# Installing Other less important Programs
nala install flameshot psmisc mangohud lxappearance fonts-noto-color-emoji -y

# Installing Essential Programs 
nala install xorg xserver-xorg libx11-dev libxinerama-dev libxft-dev libxcb1-dev libx11-xcb-dev libxcb-res0-dev xcb libxcb-xkb-dev x11-xkb-utils libxkbcommon-x11-dev build-essential gcc make

# Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git

# Enable wireplumber audio service
sudo -u $username systemctl --user enable wireplumber.service

# xorg display server installation
sudo apt install -y xorg xbacklight xvkbd xinput xorg-dev


# Microcode for Intel/AMD 
# sudo apt install -y amd64-microcode
sudo apt install -y intel-microcode 

# Network Manager
sudo apt install -y network-manager-gnome

# Network File Tools/System Events
sudo apt install -y dialog mtools dosfstools avahi-daemon acpi acpid gvfs-backends 

sudo systemctl enable avahi-daemon
sudo systemctl enable acpid

# Terminal (eg. terminator,kitty)
sudo apt install -y terminator

# Sound packages
sudo apt install -y pulseaudio alsa-utils pavucontrol volumeicon-alsa pnmixer

# Neofetch/HTOP
sudo apt install -y neofetch htop btop

# Browser Installation (eg. chromium)
sudo apt install -y firefox-esr 

# Packages needed dwm after installation
sudo apt install -y picom numlockx rofi dunst libnotify-bin

# Command line text editor -- nano preinstalled  -- I like micro but vim is great
sudo apt install -y micro
# sudo apt install -y neovim

# Install fonts
sudo apt install fonts-font-awesome fonts-ubuntu fonts-liberation2 fonts-liberation fonts-terminus 

# Reloading Font
fc-cache -vf

# Install Lightdm Console Display Manager
sudo apt install -y lightdm lightdm-gtk-greeter-settings slick-greeter
sudo systemctl enable lightdm
echo 'greeter-session=slick-greeter' >>  sudo tee -a /etc/lightdm/lightdm.conf
echo 'greeter-hide-user=false' >>  sudo tee -a /etc/lightdm/lightdm.conf

systemctl set-default graphical.target

# DWM Setup
git clone https://github.com/MahendraVadnere/dwm
cd $builddir
mkdir -p /home/$username/.config/suckless
mv dwm /home/$username/.config/suckless
cd /home/$username/.config/suckless/dwm
make clean install
cp dwm.desktop /usr/share/xsessions
cd $builddir

sudo apt autoremove

printf "\e[1;32mDone! you can now reboot.\e[0m\n"
