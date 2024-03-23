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

# Installing Essential Programs 
nala install i3lock xclip qt5-style-plugins materia-gtk-theme exa feh thunar stow policykit-1-gnome x11-xserver-utils unzip wget pipewire wireplumber pavucontrol evince sxhkd -y
# Installing Other less important Programs
nala install flameshot psmisc mangohud lxappearance -y

# Installing Essential Programs 
nala install xorg xserver-xorg libx11-dev libxinerama-dev libxft-dev libxcb1-dev libx11-xcb-dev libxcb-res0-dev xcb libxcb-xkb-dev x11-xkb-utils libxkbcommon-x11-dev build-essential gcc make -y

# Installing zsh and dependencies
nala install zsh-syntax-highlighting autojump zsh-autosuggestions

# Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git
cd $builddir 
# Enable wireplumber audio service
sudo -u $username systemctl --user enable wireplumber.service

# xorg display server installation
nala install xbacklight xvkbd xinput xorg-dev redshift -y


# Microcode for Intel/AMD 
# sudo apt install -y amd64-microcode
nala install intel-microcode -y

# Network Manager
nala install network-manager network-manager-gnome -y

# Network File Tools/System Events
nala install dialog mtools dosfstools avahi-daemon acpi acpid gvfs-backends -y

sudo systemctl enable avahi-daemon
sudo systemctl enable acpid

# Terminal (eg. terminator,kitty)
nala install terminator alacritty -y

# Sound packages
nala install pulseaudio alsa-utils pavucontrol volumeicon-alsa pnmixer pamixer -y

# Neofetch/HTOP
nala install neofetch htop btop -y

# Browser Installation (Brave)
nala install curl -y

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

nala update -y

nala install brave-browser -y


# Packages needed dwm after installation
nala install picom numlockx rofi dunst libnotify-bin -y

# Command line text editor -- nano preinstalled  -- I like micro but vim is great
nala install micro -y
# sudo apt install -y neovim

# Install fonts
nala install fonts-font-awesome fonts-ubuntu fonts-liberation2 fonts-liberation fonts-terminus fonts-noto-color-emoji -y

# Reloading Font
fc-cache -vf

# Install Lightdm Console Display Manager
sudo apt install lightdm lightdm-gtk-greeter-settings slick-greeter -y
sudo systemctl enable lightdm
#echo 'greeter-session=slick-greeter' >>  sudo tee -a /etc/lightdm/lightdm.conf
#echo 'greeter-hide-user=false' >>  sudo tee -a /etc/lightdm/lightdm.conf

systemctl set-default graphical.target

# DWM Setup
mkdir -p /home/$username/repos
cd ~/repos
git clone https://github.com/MahendraVadnere/dwm
cd /home/$username/repos/dwm
make clean install
cp dwm.desktop /usr/share/xsessions
cd $builddir

sudo apt autoremove

printf "\e[1;32mDone! you can now reboot.\e[0m\n"
