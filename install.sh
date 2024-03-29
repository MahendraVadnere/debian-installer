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

# Give user ownership and permissions over their home directory
#chown -R $username:$username /home/$username

# Move wallpaper to Pictures directory
mkdir -p /home/$username/Pictures/wallpapers
cp /home/$username/debian-installer/bg.png /home/$username/Pictures/wallpapers/

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

# Install Lightdm Console Display Manager
sudo apt install lightdm lightdm-gtk-greeter-settings slick-greeter -y
sudo systemctl enable lightdm
#echo 'greeter-session=slick-greeter' >>  sudo tee -a /etc/lightdm/lightdm.conf
#echo 'greeter-hide-user=false' >>  sudo tee -a /etc/lightdm/lightdm.conf

systemctl set-default graphical.target

# Sound packages
#nala install pipewire wireplumber pavucontrol pnmixer -y
#nala install pulseaudio alsa-utils pnmixer pamixer -y
nala install pipewire pipewire-audio-client-libraries pulseaudio-utils pipewire-audio wireplumber pipewire-pulse pipewire-alsa pnmixer pamixer -y

# Enable wireplumber audio service
#sudo -u $username systemctl --user enable wireplumber.service
systemctl --user --now enable wireplumber.service

# Neofetch/HTOP
nala install neofetch htop btop bat conky-all -y

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
nala install fonts-font-awesome fonts-terminus fonts-roboto fonts-noto-color-emoji -y

# Reloading Font
fc-cache -vf

# DWM Setup
mkdir -p /home/$username/repos
cd /home/$username/repos/
git clone https://github.com/MahendraVadnere/dwm
cd /home/$username/repos/dwm
make clean install
cp dwm.desktop /usr/share/xsessions
cd $builddir

# ditfiles management using stow
cd /home/$username/
git clone https://github.com/MahendraVadnere/dotfiles
rm -f .bashrc
rm -f .zshrc
cd /home/$username/dotfiles/
stow .
cd $builddir

# Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git
cd $builddir

sudo apt autoremove

printf "\e[1;32mDone! you can now reboot.\e[0m\n"
