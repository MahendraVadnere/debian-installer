#!/bin/bash 

#$HOME/.config/suckless/dwm/scripts/dbus &
picom &
#compton &
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 & 
$HOME/.config/suckless/dwm/scripts/dwmbar2 &

eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg) &
#feh --bg-fill /home/mav/Pictures/bg.png &
feh --bg-scale $HOME/Pictures/current-wallpaper.png

numlockx on &, # enable numlock
nm-applet &

pkill pnmixer
pnmixer &

#keybindings
sxhkd -c ~/.config/suckless/dwm/scripts/sxhkdrc &

killall conky
sleep 5s && conky -c ~/.config/suckless/dwm/scripts/test.conckyrc &
