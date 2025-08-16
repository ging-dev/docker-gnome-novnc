#!/bin/bash

VNC_PASSWORD=${VNC_PASSWORD:-123456}
GEOMETRY=${GEOMETRY:-1024x768}

sudo service dbus start

if [ ! -d ".themes" ]; then
    git clone --depth 1 https://github.com/vinceliuice/MacTahoe-gtk-theme.git
    git clone --depth 1 https://github.com/vinceliuice/MacTahoe-icon-theme.git
    cd MacTahoe-gtk-theme
    ./install.sh -l -c light
    cd -
    cd MacTahoe-icon-theme
    ./install.sh
    cd -
    rm -rf MacTahoe-gtk-theme MacTahoe-icon-theme
    dbus-launch --exit-with-session gsettings set org.gnome.desktop.interface gtk-theme MacTahoe-Light
    dbus-launch --exit-with-session gsettings set org.gnome.desktop.interface icon-theme MacTahoe-light
    dbus-launch --exit-with-session gsettings set org.gnome.desktop.wm.preferences button-layout close,minimize,maximize:
fi
if [ ! -d ".config/tigervnc" ]; then
    mkdir -p .config/tigervnc
    touch .config/tigervnc/passwd
    chmod 600 .config/tigervnc/passwd
fi

echo $VNC_PASSWORD | vncpasswd -f > .config/tigervnc/passwd
tigervncserver -geometry $GEOMETRY
./noVNC/utils/novnc_proxy --vnc localhost:5901
