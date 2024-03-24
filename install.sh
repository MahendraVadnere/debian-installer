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
cd
xdg-user-dirs-update

# Move wallpaper to Pictures directory
mkdir -p $HOME/Pictures/wallpapers
cp $HOME/debian-installer/bg.png $HOME/Pictures/wallpapers

# Installing Essential Programs for xorg and DWM
nala install xorg xserver-xorg x11-xserver-utils xorg-dev -y
nala install libx11-dev libxinerama-dev libxft-dev libxcb1-dev libx11-xcb-dev libxcb-res0-dev xcb libxcb-xkb-dev x11-xkb-utils libxkbcommon-x11-dev -y
nala install build-essential gcc make -y

# Installing Essential Programs 
nala install i3lock xclip qt5-style-plugins dmenu materia-gtk-theme exa feh stow policykit-1-gnome unzip wget -y

# Installing Other less important Programs
nala install flameshot psmisc mangohud lxappearance evince -y

# Installing zsh and dependencies
nala install zsh-syntax-highlighting autojump zsh-autosuggestions -y

# xorg display server installation
nala install xbacklight xvkbd xinput sxhkd redshift -y

# Microcode for Intel/AMD 
# sudo apt install -y amd64-microcode
nala install intel-microcode -y

# Network Manager
nala install network-manager-gnome -y

# Network File Tools/System Events
nala install dialog mtools dosfstools avahi-daemon acpi acpid gvfs-backends -y

sudo systemctl enable avahi-daemon
sudo systemctl enable acpid

# Terminal (eg. terminator,kitty)
nala install terminator alacritty -y

# Sound packages
nala install pipewire wireplumber pulseaudio alsa-utils pavucontrol volumeicon-alsa pnmixer pamixer -y

# Enable wireplumber audio service
sudo -u $username systemctl --user enable wireplumber.service

# Neofetch/HTOP
nala install neofetch htop btop bat -y

# File Manager
nala install thunar thunar-archive-plugin thunar-volman -y

# Browser Installation (Brave)
nala install curl -y

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

nala update

nala install brave-browser -y


# Packages needed dwm after installation
nala install picom numlockx rofi dunst libnotify-bin -y

# Command line text editor
nala install micro geany -y
# sudo apt install -y neovim

# Install fonts
nala install fonts-font-awesome fonts-liberation2 fonts-liberation fonts-terminus fonts-roboto fonts-noto-color-emoji -y

# Reloading Font
fc-cache -vf

# Install Lightdm Console Display Manager
sudo apt install lightdm lightdm-gtk-greeter-settings slick-greeter -y
sudo systemctl enable lightdm
#echo 'greeter-session=slick-greeter' >>  sudo tee -a /etc/lightdm/lightdm.conf
#echo 'greeter-hide-user=false' >>  sudo tee -a /etc/lightdm/lightdm.conf

systemctl set-default graphical.target

# DWM Setup
mkdir -p $HOME/repos
cd $HOME/repos
git clone https://github.com/MahendraVadnere/dwm
cd $HOME/repos/dwm
make clean install
cp dwm.desktop /usr/share/xsessions
cd

# ditfiles management using stow
git clone https://github.com/MahendraVadnere/dotfiles
rm -f .bashrc
rm -f .zshrc
cd dotfiles
stow .
cd

# Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git
cd

sudo apt autoremove

printf "\e[1;32mDone! you can now reboot.\e[0m\n"
